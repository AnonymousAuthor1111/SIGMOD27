// SPDX-License-Identifier: MIT
// Benchmark reference notes:
// - This is a simplified Pudgy Penguins-style reference derived from sol_contracts/PPG.sol.
// - It keeps the sale/admin surface only: `pause`, `setBaseURI`, `mint`,
//   `withdrawAll`, `paused`, `baseURIMarker`, `totalMint`, and `balanceOf`.
// - To match the Datalog benchmark and compiler-supported types, the original
//   `string baseURI` input is replaced with `uint256 baseURIValue`.
// - The original fixed creator/dev constants are replaced with constructor
//   parameters so the payout split remains benchmarkable without hardcoded
//   addresses in the Datalog model.
// - It intentionally omits ERC721 token-id ownership, approvals, transfers,
//   wallet enumeration, and exact per-token mint loops.
pragma solidity ^0.8.12;

contract Ppg {
    address public owner;
    address public creatorAddress;
    address public devAddress;

    uint256 public constant MAX_ELEMENTS = 8888;
    uint256 public constant PRICE = 30000000000000000;
    uint256 public constant MAX_BY_MINT = 20;

    bool public paused;
    uint256 public baseURIMarker;
    uint256 public totalMint;

    mapping(address => uint256) private _balances;

    event PauseAction(bool val);
    event SetBaseURIAction(uint256 baseURIValue);
    event MintAction(address indexed to, uint256 minted);
    event WithdrawAllAction(address indexed dev, uint256 devAmount, address indexed creator, uint256 creatorAmount);

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    modifier saleIsOpen() {
        require(totalMint <= MAX_ELEMENTS, "Sale end");
        if (msg.sender != owner) {
            require(!paused, "Pausable: paused");
        }
        _;
    }

    constructor(uint256 baseURIValue, address creator, address dev) {
        owner = msg.sender;
        creatorAddress = creator;
        devAddress = dev;
        baseURIMarker = baseURIValue;
        paused = true;
    }

    function balanceOf(address account) public view returns (uint256) {
        require(account != address(0), "bad owner");
        return _balances[account];
    }

    function price(uint256 count) public pure returns (uint256) {
        return PRICE * count;
    }

    function setBaseURI(uint256 baseURIValue) public onlyOwner {
        baseURIMarker = baseURIValue;
        emit SetBaseURIAction(baseURIValue);
    }

    function pause(bool val) public onlyOwner {
        paused = val;
        emit PauseAction(val);
    }

    function mint(address to, uint256 count) public payable saleIsOpen {
        require(totalMint + count <= MAX_ELEMENTS, "Max limit");
        require(totalMint <= MAX_ELEMENTS, "Sale end");
        require(count <= MAX_BY_MINT, "Exceeds number");
        require(msg.value >= price(count), "Value below price");

        totalMint += count;
        _balances[to] += count;
        emit MintAction(to, count);
    }

    function withdrawAll() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "empty");
        uint256 devAmount = (balance * 35) / 100;
        uint256 creatorAmount = balance - devAmount;

        (bool okDev, ) = devAddress.call{value: devAmount}("");
        require(okDev, "dev transfer failed");
        (bool okCreator, ) = creatorAddress.call{value: creatorAmount}("");
        require(okCreator, "creator transfer failed");

        emit WithdrawAllAction(devAddress, devAmount, creatorAddress, creatorAmount);
    }
}
