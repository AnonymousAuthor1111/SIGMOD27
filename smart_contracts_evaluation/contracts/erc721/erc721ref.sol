// SPDX-License-Identifier: MIT
// Benchmark reference notes:
// - This is a simplified ERC-721-style reference derived from the OpenZeppelin
//   ERC721 core implementation in sol_contracts/erc721.sol.
// - It keeps the benchmark surface only:
//   owner-only `mint`, auth-checked `burn`, `transferFrom`, `approve`,
//   `setApprovalForAll`, `ownerOf`, `balanceOf`, `getApproved`,
//   and `isApprovedForAll`.
// - Minimal compatibility changes from the OpenZeppelin source:
//   removed `string` metadata fields and URI logic, removed ERC165 interface
//   plumbing, removed safe-transfer receiver hooks and `bytes` payloads, and
//   exposed external mint/burn entrypoints for benchmarking.
// - Because safe receiver callbacks are omitted, this benchmark exposes only
//   `transferFrom`.
// - The generated Datalog contract cannot currently lower the ERC721 branch
//   that lets an operator call `approve` on behalf of the owner, so this
//   benchmark keeps `approve` owner-only.
// - The compiler also mis-lowers the operator-for-all branch of `burn`, so this
//   benchmark keeps `burn` callable by the owner or the token-approved address.
//   Operator-for-all approval is still preserved for `transferFrom`.
pragma solidity ^0.8.12;

contract Erc721 {
    address public owner;

    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function balanceOf(address account) public view returns (uint256) {
        require(account != address(0), "bad owner");
        return _balances[account];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address tokenOwner = _owners[tokenId];
        require(tokenOwner != address(0), "nonexistent token");
        return tokenOwner;
    }

    function getApproved(uint256 tokenId) public view returns (address) {
        require(_owners[tokenId] != address(0), "nonexistent token");
        return _tokenApprovals[tokenId];
    }

    function isApprovedForAll(address tokenOwner, address operator) public view returns (bool) {
        return _operatorApprovals[tokenOwner][operator];
    }

    function approve(address to, uint256 tokenId) public {
        address tokenOwner = ownerOf(tokenId);
        require(to != tokenOwner, "approve to owner");
        require(msg.sender == tokenOwner, "invalid approver");
        _tokenApprovals[tokenId] = to;
        emit Approval(tokenOwner, to, tokenId);
    }

    function setApprovalForAll(address operator, bool approved) public {
        require(operator != address(0), "bad operator");
        require(operator != msg.sender, "self approval");
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        require(to != address(0), "bad receiver");
        address tokenOwner = ownerOf(tokenId);
        require(tokenOwner == from, "incorrect owner");
        require(
            msg.sender == from ||
            isApprovedForAll(from, msg.sender) ||
            getApproved(tokenId) == msg.sender,
            "insufficient approval"
        );

        _tokenApprovals[tokenId] = address(0);
        unchecked {
            _balances[from] -= 1;
            _balances[to] += 1;
        }
        _owners[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }

    function mint(address to, uint256 tokenId) public onlyOwner {
        require(to != address(0), "bad receiver");
        require(_owners[tokenId] == address(0), "already minted");
        unchecked {
            _balances[to] += 1;
        }
        _owners[tokenId] = to;
        emit Transfer(address(0), to, tokenId);
    }

    function burn(uint256 tokenId) public {
        address tokenOwner = ownerOf(tokenId);
        require(
            msg.sender == tokenOwner ||
            getApproved(tokenId) == msg.sender,
            "insufficient approval"
        );
        _tokenApprovals[tokenId] = address(0);
        unchecked {
            _balances[tokenOwner] -= 1;
        }
        _owners[tokenId] = address(0);
        emit Transfer(tokenOwner, address(0), tokenId);
    }
}
