// SPDX-License-Identifier: UNLICENSED
// Benchmark reference notes:
// - This is not the full upstream UNI governance token.
// - It was reduced to the benchmark surface used in this repo:
//   `constructor(holder, supply)`, `transfer`, `delegate`, `delegateBySig`.
// - Voting checkpoints, historical vote lookup, permit/EIP-712, and mint policy
//   were removed because the Datalog benchmark does not model them and the gas
//   harness only exercises the reduced surface above.
// - The goal of this ref is to provide a stable comparison target for the
//   generated benchmark contract, not to preserve full production UNI behavior.
pragma solidity ^0.8.12;

contract Uni {
    string public constant name = "Uniswap";
    string public constant symbol = "UNI";
    uint8 public constant decimals = 18;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => address) public delegates;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);

    constructor(address holder, uint256 supply) {
        totalSupply = supply;
        balanceOf[holder] = supply;
        emit Transfer(address(0), holder, supply);
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

    function delegate(address delegatee) external {
        address oldDelegate = delegates[msg.sender];
        delegates[msg.sender] = delegatee;
        emit DelegateChanged(msg.sender, oldDelegate, delegatee);
    }

    function delegateBySig(address delegator, address delegatee) external {
        address oldDelegate = delegates[delegator];
        delegates[delegator] = delegatee;
        emit DelegateChanged(delegator, oldDelegate, delegatee);
    }
}
