// SPDX-License-Identifier: UNLICENSED
// Benchmark reference notes:
// - This is a simplified ERC-1155-style reference derived from the EIP-1155
//   specification at https://eips.ethereum.org/EIPS/eip-1155.
// - It keeps the core benchmark surface only:
//   `setApprovalForAll`, `transferFrom`, `mint`, `burn`, per-(owner,id)
//   balances, and per-id total supply.
// - It intentionally omits full ERC-1155 compliance features that are outside
//   the current Datalog/compiler benchmark scope: batch array operations,
//   bytes payload handling, receiver callbacks, ERC-165 support, and metadata.
// - Because the receiver-hook path is omitted, this benchmark exposes
//   `transferFrom` rather than ERC-1155's standard `safeTransferFrom`.
// - The goal is to match the simplified benchmark contract, not to implement
//   the full production standard.
pragma solidity ^0.8.12;

contract Erc1155 {
    address public owner;

    mapping(address => mapping(uint256 => uint256)) public balanceOf;
    mapping(uint256 => uint256) public totalSupplyById;
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    event SetApprovalForAllAction(address indexed owner, address indexed operator, bool approved);
    event TransferSingle(address indexed from, address indexed to, address indexed operator, uint256 id, uint256 value);
    event Mint(address indexed to, uint256 id, uint256 value);
    event Burn(address indexed from, address indexed operator, uint256 id, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setApprovalForAll(address operator, bool approved) external {
        require(msg.sender != address(0) && operator != address(0), "bad address");
        require(msg.sender != operator, "self approve");
        isApprovedForAll[msg.sender][operator] = approved;
        emit SetApprovalForAllAction(msg.sender, operator, approved);
    }

    function transferFrom(address from, address to, uint256 id, uint256 value) external {
        require(from != address(0) && to != address(0), "bad address");
        require(value > 0, "bad value");
        require(msg.sender == from || isApprovedForAll[from][msg.sender], "not approved");
        require(balanceOf[from][id] >= value, "insufficient balance");
        unchecked {
            balanceOf[from][id] -= value;
            balanceOf[to][id] += value;
        }
        emit TransferSingle(from, to, msg.sender, id, value);
    }

    function mint(address to, uint256 id, uint256 value) external onlyOwner {
        require(to != address(0), "bad address");
        require(value > 0, "bad value");
        balanceOf[to][id] += value;
        totalSupplyById[id] += value;
        emit Mint(to, id, value);
    }

    function burn(address from, uint256 id, uint256 value) external {
        require(from != address(0), "bad address");
        require(value > 0, "bad value");
        require(msg.sender == from || isApprovedForAll[from][msg.sender], "not approved");
        require(balanceOf[from][id] >= value, "insufficient balance");
        unchecked {
            balanceOf[from][id] -= value;
            totalSupplyById[id] -= value;
        }
        emit Burn(from, msg.sender, id, value);
    }
}
