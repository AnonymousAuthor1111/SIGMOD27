// source: https://github.com/eth-sri/verx-benchmarks/blob/master/overview/main.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Escrow {
  mapping(address => uint256) deposits;
  enum State {OPEN, SUCCESS, REFUND}
  State state = State.OPEN;
  address owner;
  address payable beneficiary;
  // uint256 totalFunds;
  uint256 raised;

  // constructor(address payable b) public {
  constructor(address payable b) {
    beneficiary = b;
    owner = msg.sender;
    // totalFunds = 0;
    raised = 0;
  }

  function deposit(address p) onlyOwner public payable {
    deposits[p] = deposits[p] + msg.value;
    // totalFunds += msg.value;
    raised += msg.value;
  }

  function withdraw() public {
    require(state == State.SUCCESS);
    beneficiary.transfer(address(this).balance);
    // totalFunds = 0;
  }

  function claimRefund(address payable p) public {
    require(state == State.REFUND);
    uint256 amount = deposits[p];
    deposits[p] = 0;
    p.transfer(amount);
    // totalFunds -= amount;
  }

  modifier onlyOwner {require(owner == msg.sender); _; }
  function close() onlyOwner public{state = State.SUCCESS;}
  function refund() onlyOwner public{state = State.REFUND;}
  // function check() public view {
  //   assert(totalFunds == raised || state != State.OPEN);
  // }
}

contract CrowFunding {
  Escrow escrow;
  uint256 raised = 0;
  uint256 goal = 10000 * 10**18;
  // closeTime is now passed in via the constructor for testing
  // Keeping the reference contract's signature aligned with the generated Datlog variants
  // lets a single test trace drive all versions.
  // uint256 closeTime = block.timestamp + 30 days;
  uint256 closeTime;
  bool closed;

  //address payable constant init = payable(address(uint160(0xDEADBEEF)));

  // constructor(uint256 _goal, address _escrow) public
  constructor(uint256 _goal, address _escrow, uint256 _closeTime) {
    // escrow = new Escrow(payable(address(0xDEADBEEF)));
    escrow = new Escrow(payable(_escrow));
    goal = _goal;
    closeTime = _closeTime;
    closed = false;
  }

  function invest() payable public{
    // fix:
    require(block.timestamp<=closeTime);
    require(raised < goal);
    escrow.deposit{value: msg.value}(msg.sender);
    raised += msg.value;
  }

  function close() public{
    require(block.timestamp > closeTime || raised >= goal);
    if (raised >= goal) {
      escrow.close();
      closed = true;
    } else {
      escrow.refund();
   }
  }
}

contract Deployer{
    CrowFunding c = new CrowFunding(10000 * 10**18, address(0xDEADBEEF), block.timestamp + 30 days);
}