// Benchmark reference notes:
// - This is a reduced Uniswap V2 pair reference built specifically for the gas
//   benchmark in this repository. It is not the upstream pair contract.
// - The function surface was reshaped to match the benchmark harness:
//   `initialize(token0, token1)`, `mint(to, amount0, amount1)`,
//   `burn(to, liquidity)`, `swap(amount0In, amount1In, amount0Out, amount1Out, to)`,
//   and `sync(balance0, balance1)`.
// - External ERC20 transfers, callback data, cumulative prices, fee-on minting,
//   permit, and skim were removed because the Datalog benchmark does not model
//   them and the current compiler cannot support that full behavior.
// - LP accounting is intentionally simplified:
//   minted liquidity is `min(amount0, amount1)` and burned outputs are both
//   equal to `liquidity`.
// - This ref remains stricter than the generated Datalog pair on reserve checks
//   and the product invariant, but it still represents a benchmark-friendly
//   approximation rather than a faithful production pair.
pragma solidity ^0.8.12;

contract UniswapPair {
    address public factory;
    bool public initialized;
    address public token0;
    address public token1;
    uint256 public reserve0;
    uint256 public reserve1;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    event Initialize(address token0, address token1);
    event Mint(address sender, address to, uint256 amount0, uint256 amount1, uint256 liquidity);
    event Burn(address sender, address to, uint256 liquidity, uint256 amount0, uint256 amount1);
    event Swap(address sender, address to, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out);
    event Sync(uint256 reserve0, uint256 reserve1);

    constructor() {
        factory = msg.sender;
    }

    function initialize(address _token0, address _token1) external {
        require(msg.sender == factory, "forbidden");
        require(!initialized, "initialized");
        require(_token0 != address(0) && _token1 != address(0) && _token0 != _token1, "bad token");
        token0 = _token0;
        token1 = _token1;
        initialized = true;
        emit Initialize(_token0, _token1);
    }

    function mint(address to, uint256 amount0, uint256 amount1) external returns (uint256 liquidity) {
        require(initialized, "not initialized");
        require(to != address(0), "bad to");
        require(amount0 > 0 && amount1 > 0, "bad amounts");
        liquidity = amount0 < amount1 ? amount0 : amount1;
        reserve0 += amount0;
        reserve1 += amount1;
        totalSupply += liquidity;
        balanceOf[to] += liquidity;
        emit Mint(msg.sender, to, amount0, amount1, liquidity);
    }

    function burn(address to, uint256 liquidity) external returns (uint256 amount0, uint256 amount1) {
        require(initialized, "not initialized");
        require(to != address(0), "bad to");
        require(balanceOf[msg.sender] >= liquidity, "insufficient liquidity");
        require(reserve0 >= liquidity && reserve1 >= liquidity, "insufficient reserves");
        amount0 = liquidity;
        amount1 = liquidity;
        balanceOf[msg.sender] -= liquidity;
        totalSupply -= liquidity;
        reserve0 -= amount0;
        reserve1 -= amount1;
        emit Burn(msg.sender, to, liquidity, amount0, amount1);
    }

    function swap(uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address to) external {
        require(initialized, "not initialized");
        require(to != address(0), "bad to");
        require(amount0Out > 0 || amount1Out > 0, "bad output");
        require(amount0In > 0 || amount1In > 0, "bad input");
        require(amount0Out < reserve0 && amount1Out < reserve1, "insufficient liquidity");
        uint256 new0 = reserve0 + amount0In - amount0Out;
        uint256 new1 = reserve1 + amount1In - amount1Out;
        require(new0 * new1 >= reserve0 * reserve1, "k");
        reserve0 = new0;
        reserve1 = new1;
        emit Swap(msg.sender, to, amount0In, amount1In, amount0Out, amount1Out);
    }

    function sync(uint256 balance0, uint256 balance1) external {
        require(initialized, "not initialized");
        reserve0 = balance0;
        reserve1 = balance1;
        emit Sync(balance0, balance1);
    }
}
