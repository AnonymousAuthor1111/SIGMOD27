// SPDX-License-Identifier: MIT
// Benchmark reference notes:
// - This is a simplified CryptoPunks-style reference derived from
//   sol_contracts/CryptoPunks.sol.
// - It keeps the benchmark surface only:
//   `allInitialOwnersAssigned`, `getPunk`, `transferPunk`,
//   `punkNoLongerForSale`, `offerPunkForSale`, `buyPunk`,
//   `enterBidForPunk`, `acceptBidForPunk`, `withdrawBidForPunk`, and
//   `withdraw`.
// - Minimal compatibility changes from the original source:
//   removed string metadata and events, removed batch owner setup,
//   removed `offerPunkForSaleToAddress`, and rewritten to Solidity 0.8.x.
// - This benchmark keeps unrestricted sale offers only.
// - The Datalog benchmark cannot express the fresh-punk absence check cleanly,
//   so traces must not claim the same punk twice. This reference still enforces
//   the check with `punkIndexToAddress[punkIndex] == address(0)`.
// - To keep the ref aligned with the benchmark, a direct buy clears and refunds
//   any outstanding bid on that punk through `pendingWithdrawals`.
// - The original transfer edge case that only refunds the bid when the new
//   owner already was the bidder is omitted here.
pragma solidity ^0.8.12;

contract CryptoPunks {
    address public owner;
    uint256 public constant totalSupply = 10000;
    bool public allPunksAssigned;

    mapping(uint256 => address) public punkIndexToAddress;
    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public pendingWithdrawals;

    mapping(uint256 => bool) public punksOfferedForSale;
    mapping(uint256 => address) public offerSeller;
    mapping(uint256 => uint256) public offerMinValue;

    mapping(uint256 => bool) public punkHasBid;
    mapping(uint256 => address) public bidBidder;
    mapping(uint256 => uint256) public bidValue;

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        allPunksAssigned = false;
    }

    function allInitialOwnersAssigned() external onlyOwner {
        require(!allPunksAssigned, "already assigned");
        allPunksAssigned = true;
    }

    function getPunk(uint256 punkIndex) external {
        require(allPunksAssigned, "not enabled");
        require(punkIndex < totalSupply, "bad punk");
        require(punkIndexToAddress[punkIndex] == address(0), "already claimed");
        punkIndexToAddress[punkIndex] = msg.sender;
        balanceOf[msg.sender] += 1;
        _clearOffer(punkIndex);
        _clearBid(punkIndex, false);
    }

    function transferPunk(address to, uint256 punkIndex) external {
        require(allPunksAssigned, "not enabled");
        require(to != address(0), "bad receiver");
        require(punkIndex < totalSupply, "bad punk");
        require(punkIndexToAddress[punkIndex] == msg.sender, "not owner");
        punkIndexToAddress[punkIndex] = to;
        unchecked {
            balanceOf[msg.sender] -= 1;
            balanceOf[to] += 1;
        }
        _clearOffer(punkIndex);
    }

    function punkNoLongerForSale(uint256 punkIndex) external {
        require(allPunksAssigned, "not enabled");
        require(punkIndex < totalSupply, "bad punk");
        require(punkIndexToAddress[punkIndex] == msg.sender, "not owner");
        _clearOffer(punkIndex);
    }

    function offerPunkForSale(uint256 punkIndex, uint256 minSalePriceInWei) external {
        require(allPunksAssigned, "not enabled");
        require(punkIndex < totalSupply, "bad punk");
        require(punkIndexToAddress[punkIndex] == msg.sender, "not owner");
        punksOfferedForSale[punkIndex] = true;
        offerSeller[punkIndex] = msg.sender;
        offerMinValue[punkIndex] = minSalePriceInWei;
    }

    function buyPunk(uint256 punkIndex) external payable {
        require(allPunksAssigned, "not enabled");
        require(punkIndex < totalSupply, "bad punk");
        require(punksOfferedForSale[punkIndex], "not for sale");
        address seller = offerSeller[punkIndex];
        require(seller != address(0), "bad seller");
        require(punkIndexToAddress[punkIndex] == seller, "seller mismatch");
        require(msg.value >= offerMinValue[punkIndex], "insufficient payment");

        punkIndexToAddress[punkIndex] = msg.sender;
        unchecked {
            balanceOf[seller] -= 1;
            balanceOf[msg.sender] += 1;
        }
        _clearOffer(punkIndex);
        pendingWithdrawals[seller] += msg.value;
        _clearBid(punkIndex, true);
    }

    function enterBidForPunk(uint256 punkIndex) external payable {
        require(allPunksAssigned, "not enabled");
        require(punkIndex < totalSupply, "bad punk");
        address ownerOfPunk = punkIndexToAddress[punkIndex];
        require(ownerOfPunk != address(0), "unassigned");
        require(ownerOfPunk != msg.sender, "owner cannot bid");
        require(msg.value > 0, "zero bid");
        if (punkHasBid[punkIndex]) {
            require(msg.value > bidValue[punkIndex], "bid too low");
            pendingWithdrawals[bidBidder[punkIndex]] += bidValue[punkIndex];
        }
        punkHasBid[punkIndex] = true;
        bidBidder[punkIndex] = msg.sender;
        bidValue[punkIndex] = msg.value;
    }

    function acceptBidForPunk(uint256 punkIndex, uint256 minPrice) external {
        require(allPunksAssigned, "not enabled");
        require(punkIndex < totalSupply, "bad punk");
        require(punkIndexToAddress[punkIndex] == msg.sender, "not owner");
        require(punkHasBid[punkIndex], "no bid");
        require(bidValue[punkIndex] >= minPrice, "bid too low");

        address bidder = bidBidder[punkIndex];
        uint256 amount = bidValue[punkIndex];
        punkIndexToAddress[punkIndex] = bidder;
        unchecked {
            balanceOf[msg.sender] -= 1;
            balanceOf[bidder] += 1;
        }
        _clearOffer(punkIndex);
        _clearBid(punkIndex, false);
        pendingWithdrawals[msg.sender] += amount;
    }

    function withdrawBidForPunk(uint256 punkIndex) external {
        require(allPunksAssigned, "not enabled");
        require(punkIndex < totalSupply, "bad punk");
        require(punkHasBid[punkIndex], "no bid");
        require(bidBidder[punkIndex] == msg.sender, "not bidder");
        uint256 amount = bidValue[punkIndex];
        _clearBid(punkIndex, false);
        payable(msg.sender).transfer(amount);
    }

    function withdraw() external {
        require(allPunksAssigned, "not enabled");
        uint256 amount = pendingWithdrawals[msg.sender];
        require(amount > 0, "nothing to withdraw");
        pendingWithdrawals[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function _clearOffer(uint256 punkIndex) internal {
        punksOfferedForSale[punkIndex] = false;
        offerSeller[punkIndex] = address(0);
        offerMinValue[punkIndex] = 0;
    }

    function _clearBid(uint256 punkIndex, bool refundBidderToPending) internal {
        if (refundBidderToPending && punkHasBid[punkIndex]) {
            pendingWithdrawals[bidBidder[punkIndex]] += bidValue[punkIndex];
        }
        punkHasBid[punkIndex] = false;
        bidBidder[punkIndex] = address(0);
        bidValue[punkIndex] = 0;
    }
}
