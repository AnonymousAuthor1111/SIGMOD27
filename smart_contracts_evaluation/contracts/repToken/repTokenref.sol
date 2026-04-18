// source: https://etherscan.io/address/0xe94327d07fc17907b4db788e5adf2ed424addff6#code

// Upgraded from pragma solidity ^0.4.11 to ^0.8.12
pragma solidity ^0.8.12;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}


/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
abstract contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) public view virtual returns (uint256);
  function transfer(address to, uint256 value) public virtual returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}


/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
abstract contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view virtual returns (uint256);
  function transferFrom(address from, address to, uint256 value) public virtual returns (bool);
  function approve(address spender, uint256 value) public virtual returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}


/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public virtual override returns (bool) {
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return balance An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view override returns (uint256 balance) {
    return balances[_owner];
  }

}


/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {
  using SafeMath for uint256;

  mapping (address => mapping (address => uint256)) allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amout of tokens to be transfered
   */
  function transferFrom(address _from, address _to, uint256 _value) public virtual override returns (bool) {
    uint256 _allowance = allowed[_from][msg.sender];

    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
    // require (_value <= _allowance);

    balances[_to] = balances[_to].add(_value);
    balances[_from] = balances[_from].sub(_value);
    allowed[_from][msg.sender] = _allowance.sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public override returns (bool) {

    // To change the approve amount you first have to reduce the addresses`
    //  allowance to zero by calling `approve(_spender, 0)` if it is not
    //  already 0 to mitigate the race condition described here:
    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    require((_value == 0) || (allowed[msg.sender][_spender] == 0));

    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return remaining A uint256 specifing the amount of tokens still avaible for the spender.
   */
  function allowance(address _owner, address _spender) public view override returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

}


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    if (newOwner != address(0)) {
      owner = newOwner;
    }
  }

}


/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev modifier to allow actions only when the contract IS paused
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev modifier to allow actions only when the contract IS NOT paused
   */
  modifier whenPaused {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() public onlyOwner whenNotPaused returns (bool) {
    paused = true;
    emit Pause();
    return true;
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() public virtual onlyOwner whenPaused returns (bool) {
    paused = false;
    emit Unpause();
    return true;
  }
}

/**
 * Pausable token
 *
 * Simple ERC20 Token example, with pausable token creation
 **/

contract PausableToken is StandardToken, Pausable {

  function transfer(address _to, uint _value) public override(BasicToken, ERC20Basic) whenNotPaused returns (bool) {
    return super.transfer(_to, _value);
  }

  function transferFrom(address _from, address _to, uint _value) public override(StandardToken) whenNotPaused returns (bool) {
    return super.transferFrom(_from, _to, _value);
  }
}


contract Initializable {
  bool public initialized = false;

  modifier afterInitialized {
    require(initialized);
    _;
  }

  modifier beforeInitialized {
    require(!initialized);
    _;
  }

  function endInitialization() internal beforeInitialized returns (bool) {
    initialized = true;
    return true;
  }
}


/**
 * @title REP2 Token
 * @dev REP2 Mintable Token with migration from legacy contract
 */
contract RepToken is Initializable, PausableToken {
  using SafeMath for uint256;

  ERC20Basic public legacyRepContract;
  uint256 public targetSupply;

  string public constant name = "Reputation";
  string public constant symbol = "REP";
  uint256 public constant decimals = 18;

  event Migrated(address indexed holder, uint256 amount);

  /**
    * @dev Creates a new RepToken instance
    * @param _legacyRepContract Address of the legacy ERC20Basic REP contract to migrate balances from
    * @param _targetSupply Legacy contract's totalSupply, passed in explicitly.
    *        Originally the constructor called `legacyRepContract.totalSupply()`,
    *        but the Datalog spec (benchmarks/repToken.dl) declares the
    *        constructor with four parameters because Datalog cannot express
    *        external calls at construction time. Keeping the signatures
    *        aligned lets a single test trace drive both the reference and the
    *        generated variants.
    */
  constructor(address _legacyRepContract, uint256 _amountUsedToFreeze, address _accountToSendFrozenRepTo, uint256 _targetSupply) {
    require(_legacyRepContract != address(0));
    legacyRepContract = ERC20Basic(_legacyRepContract);
    targetSupply = _targetSupply;
    balances[_accountToSendFrozenRepTo] = _amountUsedToFreeze;
    totalSupply = _amountUsedToFreeze;
    pause();
  }

  /**
    * @dev Copies the balance of a batch of addresses from the legacy contract
    * @param _holders Array of addresses to migrate balance
    * @return True if operation was completed
    */
  function migrateBalances(address[] memory _holders, uint256[] memory _legacyBalances) public onlyOwner beforeInitialized returns (bool) {
    for (uint256 i = 0; i < _holders.length; i++) {
      migrateBalance(_holders[i], _legacyBalances[i]);
    }
    return true;
  }

  /**
    * @dev Copies the balance of a single addresses from the legacy contract
    * @param _holder Address to migrate balance
    * @param _legacyBalance Legacy contract's balanceOf(_holder), passed in explicitly.
    *        Originally this function called `legacyRepContract.balanceOf(_holder)`,
    *        but the Datalog spec declares `migrateBalance(holder, legacyBalance)`
    *        with two parameters because Datalog cannot express external calls
    *        in rule bodies. Kept aligned so a single test trace drives both.
    * @return True if balance was copied, false if was already copied or address had no balance
    */
  function migrateBalance(address _holder, uint256 _legacyBalance) public onlyOwner beforeInitialized returns (bool) {
    if (balances[_holder] > 0) {
      return false; // Already copied, move on
    }

    if (_legacyBalance == 0) {
      return false; // Has no balance in legacy contract, move on
    }

    balances[_holder] = _legacyBalance;
    totalSupply = totalSupply.add(_legacyBalance);
    emit Migrated(_holder, _legacyBalance);

    if (targetSupply == totalSupply) {
      endInitialization();
    }
    return true;
  }

  /**
    * @dev Unpauses the contract with the caveat added that it can only happen after initialization.
    */
  function unpause() public override onlyOwner whenPaused afterInitialized returns (bool) {
    super.unpause();
    return true;
  }
}
