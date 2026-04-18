// SPDX-License-Identifier: UNLICENSED
// Benchmark reference notes:
// - This is a benchmark-oriented PEPE reference, not a faithful reproduction of
//   the production token and its inheritance tree.
// - It keeps the callable surface used by the gas harness:
//   `transfer`, `approve`, `transferFrom`, `increaseAllowance`,
//   `decreaseAllowance`, `burn`, `blacklist`, `setRule`.
// - Trading restrictions are intentionally simplified. In particular, transfer
//   paths are plain ERC20-style and do not enforce the original launch gating,
//   pair-based buy limits, or blacklist checks inside transfers.
// - The owner-controlled bookkeeping state is kept so benchmark calls still
//   have meaningful storage effects, but the contract is intentionally reduced
//   to match the compiler-supported Datalog benchmark.
pragma solidity ^0.8.12;

contract Pepe {
    string public constant name = "Pepe";
    string public constant symbol = "PEPE";
    uint8 public constant decimals = 18;

    uint256 public totalSupply;
    address public owner;
    bool public limited;
    uint256 public maxHoldingAmount;
    uint256 public minHoldingAmount;
    address public uniswapV2Pair;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => bool) public blacklists;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
    event BlacklistAction(address indexed account, bool blacklisted);
    event SetRuleAction(bool limited, address indexed pair, uint256 maxHoldingAmount, uint256 minHoldingAmount);

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor(uint256 supply) {
        owner = msg.sender;
        totalSupply = supply;
        balanceOf[msg.sender] = supply;
        emit Transfer(address(0), msg.sender, supply);
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        require(msg.sender != address(0) && to != address(0), "bad address");
        require(balanceOf[msg.sender] >= amount, "insufficient balance");
        unchecked {
            balanceOf[msg.sender] -= amount;
            balanceOf[to] += amount;
        }
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
        allowance[msg.sender][spender] += addedValue;
        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
        uint256 currentAllowance = allowance[msg.sender][spender];
        require(currentAllowance >= subtractedValue, "decreased below zero");
        unchecked {
            allowance[msg.sender][spender] = currentAllowance - subtractedValue;
        }
        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(from != address(0) && to != address(0), "bad address");
        require(balanceOf[from] >= amount, "insufficient balance");
        uint256 currentAllowance = allowance[from][msg.sender];
        require(currentAllowance >= amount, "insufficient allowance");
        unchecked {
            allowance[from][msg.sender] = currentAllowance - amount;
            balanceOf[from] -= amount;
            balanceOf[to] += amount;
        }
        emit Approval(from, msg.sender, allowance[from][msg.sender]);
        emit Transfer(from, to, amount);
        return true;
    }

    function burn(uint256 amount) external {
        require(balanceOf[msg.sender] >= amount, "insufficient balance");
        unchecked {
            balanceOf[msg.sender] -= amount;
            totalSupply -= amount;
        }
        emit Transfer(msg.sender, address(0), amount);
    }

    function blacklist(address account, bool blocked) external onlyOwner {
        blacklists[account] = blocked;
        emit BlacklistAction(account, blocked);
    }

    function setRule(bool isLimited, address pair, uint256 maxHolding, uint256 minHolding) external onlyOwner {
        limited = isLimited;
        uniswapV2Pair = pair;
        maxHoldingAmount = maxHolding;
        minHoldingAmount = minHolding;
        emit SetRuleAction(isLimited, pair, maxHolding, minHolding);
    }
}
