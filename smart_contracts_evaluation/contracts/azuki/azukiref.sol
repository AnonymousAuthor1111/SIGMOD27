// SPDX-License-Identifier: MIT
// Benchmark reference notes:
// - This is a simplified Azuki-style reference derived from sol_contracts/Azuki.sol.
// - It keeps the sale configuration and mint gating surface, and adds a
//   reduced benchmark-only ERC721 transfer layer:
//   `auctionMint`, `allowlistMint`, `publicSaleMint`, `devMint`,
//   `endAuctionAndSetupNonAuctionSaleInfo`, `setAuctionSaleStartTime`,
//   `setPublicSaleKey`, `seedAllowlist`, plus `mintToken`, `approve`,
//   `setApprovalForAll`, `transferFrom`, `ownerOf`, `getApproved`,
//   `isApprovedForAll`, `balanceOf`, `numberMinted`, and `allowlist`.
// - To match the Datalog benchmark, it intentionally omits ERC721A token ownership,
//   approvals, transfers, refund logic, timestamp-based auction pricing,
//   metadata/baseURI, withdrawal, and batch array seeding.
// - `seedAllowlist` is reduced from array inputs to a single `(address, slots)` update.
// - `devMint` is reduced to aggregate supply/accounting updates rather than looping in
//   `maxBatchSize` chunks.
// - The benchmark simplification also drops global total-supply / collection-size
//   guards and does not consume allowlist slots after mint.
// - The added transfer layer is a reduced ERC721-style layer used only for
//   transfer/approval benchmarking; the sale mints do not allocate token IDs.
pragma solidity ^0.8.12;

contract Azuki {
    address public owner;

    uint256 public maxPerAddressDuringMint;
    uint256 public collectionSize;
    uint256 public amountForAuctionAndDev;
    uint256 public amountForDevs;

    uint256 public auctionSaleStartTime;
    uint256 public publicSaleStartTime;
    uint256 public mintlistPrice;
    uint256 public publicPrice;
    uint256 public publicSaleKey;
    uint256 public totalSupply;

    mapping(uint256 => address) private _owners;
    mapping(address => uint256) public balanceOf;
    mapping(address => uint256) public numberMinted;
    mapping(address => uint256) public allowlist;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor(
        uint256 maxBatchSize_,
        uint256 collectionSize_,
        uint256 amountForAuctionAndDev_,
        uint256 amountForDevs_
    ) {
        owner = msg.sender;
        maxPerAddressDuringMint = maxBatchSize_;
        collectionSize = collectionSize_;
        amountForAuctionAndDev = amountForAuctionAndDev_;
        amountForDevs = amountForDevs_;
        require(amountForAuctionAndDev_ <= collectionSize_, "bad auction cap");
        require(amountForDevs_ <= collectionSize_, "bad dev cap");
    }

    function auctionMint(uint256 quantity) external {
        require(msg.sender != address(0), "bad caller");
        require(quantity > 0, "bad quantity");
        require(auctionSaleStartTime > 0, "auction off");
        require(quantity <= amountForAuctionAndDev, "auction cap");
        require(numberMinted[msg.sender] + quantity <= maxPerAddressDuringMint, "wallet cap");

        totalSupply += quantity;
        balanceOf[msg.sender] += quantity;
        numberMinted[msg.sender] += quantity;
    }

    function allowlistMint() external {
        require(msg.sender != address(0), "bad caller");
        require(mintlistPrice > 0, "allowlist off");
        require(allowlist[msg.sender] > 0, "no slots");
        totalSupply += 1;
        balanceOf[msg.sender] += 1;
        numberMinted[msg.sender] += 1;
    }

    function publicSaleMint(uint256 quantity, uint256 callerPublicSaleKey) external {
        require(msg.sender != address(0), "bad caller");
        require(quantity > 0, "bad quantity");
        require(publicSaleKey > 0, "key unset");
        require(publicSaleKey == callerPublicSaleKey, "bad key");
        require(publicPrice > 0, "public price off");
        require(publicSaleStartTime > 0, "public sale off");
        require(numberMinted[msg.sender] + quantity <= maxPerAddressDuringMint, "wallet cap");

        totalSupply += quantity;
        balanceOf[msg.sender] += quantity;
        numberMinted[msg.sender] += quantity;
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

    function mintToken(address to, uint256 tokenId) external onlyOwner {
        require(to != address(0), "bad receiver");
        require(_owners[tokenId] == address(0), "already minted");
        _owners[tokenId] = to;
        unchecked {
            balanceOf[to] += 1;
        }
    }

    function approve(address to, uint256 tokenId) external {
        address tokenOwner = ownerOf(tokenId);
        require(msg.sender == tokenOwner, "invalid approver");
        require(to != tokenOwner, "approve to owner");
        _tokenApprovals[tokenId] = to;
    }

    function setApprovalForAll(address operator, bool approved) external {
        require(operator != address(0), "bad operator");
        require(operator != msg.sender, "self approval");
        _operatorApprovals[msg.sender][operator] = approved;
    }

    function transferFrom(address from, address to, uint256 tokenId) external {
        require(to != address(0), "bad receiver");
        require(ownerOf(tokenId) == from, "incorrect owner");
        require(
            msg.sender == from ||
            isApprovedForAll(from, msg.sender) ||
            getApproved(tokenId) == msg.sender,
            "insufficient approval"
        );

        _tokenApprovals[tokenId] = address(0);
        unchecked {
            balanceOf[from] -= 1;
            balanceOf[to] += 1;
        }
        _owners[tokenId] = to;
    }

    function endAuctionAndSetupNonAuctionSaleInfo(
        uint64 mintlistPriceWei,
        uint64 publicPriceWei,
        uint32 publicSaleStartTime_
    ) external onlyOwner {
        mintlistPrice = mintlistPriceWei;
        publicPrice = publicPriceWei;
        publicSaleStartTime = publicSaleStartTime_;
        auctionSaleStartTime = 0;
    }

    function setAuctionSaleStartTime(uint32 timestamp) external onlyOwner {
        auctionSaleStartTime = timestamp;
    }

    function setPublicSaleKey(uint32 key) external onlyOwner {
        publicSaleKey = key;
    }

    function seedAllowlist(address account, uint256 slots) external onlyOwner {
        require(account != address(0), "bad account");
        allowlist[account] = slots;
    }

    function devMint(uint256 quantity) external onlyOwner {
        require(quantity > 0, "bad quantity");
        require(quantity <= amountForDevs, "dev cap");

        totalSupply += quantity;
        balanceOf[msg.sender] += quantity;
        numberMinted[msg.sender] += quantity;
    }
}
