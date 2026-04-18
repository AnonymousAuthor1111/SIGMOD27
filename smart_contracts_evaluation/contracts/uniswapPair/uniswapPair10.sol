contract UniswapPair {
  struct InitializedTuple {
    bool b;
    bool _valid;
  }
  struct Reserve1Tuple {
    uint n;
    bool _valid;
  }
  struct FactoryTuple {
    address p;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct Token1Tuple {
    address p;
    bool _valid;
  }
  struct LpBalanceOfTuple {
    uint n;
    bool _valid;
  }
  struct Reserve0Tuple {
    uint n;
    bool _valid;
  }
  struct Token0Tuple {
    address p;
    bool _valid;
  }
  Token1Tuple token1;
  InitializedTuple initialized;
  Reserve1Tuple reserve1;
  FactoryTuple factory;
  mapping(address=>LpBalanceOfTuple) lpBalanceOf;
  TotalSupplyTuple totalSupply;
  Reserve0Tuple reserve0;
  Token0Tuple token0;
  event Burn(address from,address to,uint liquidity,uint amount0,uint amount1);
  event SyncAction(uint balance0,uint balance1);
  event Mint(address to,uint amount0,uint amount1,uint liquidity);
  event Swap(address sender,address to,uint amount0In,uint amount1In,uint amount0Out,uint amount1Out);
  event Initialize(address token0,address token1);
  constructor() public {
    updateAllReserve1AddOnInsertConstructor_r31();
    updateAllReserve0AddOnInsertConstructor_r4();
    updateToken0OnInsertConstructor_r39();
    updateFactoryOnInsertConstructor_r17();
    updateInitializedOnInsertConstructor_r30();
    updateAllLpBurnOnInsertConstructor_r26();
    updateAllReserve0SubOnInsertConstructor_r19();
    updateAllLpMintOnInsertConstructor_r5();
    updateAllReserve1SubOnInsertConstructor_r9();
    updateToken1OnInsertConstructor_r15();
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function swap(uint amount0In,uint amount1In,uint amount0Out,uint amount1Out,address to) public    {
      bool r23 = updateSwapOnInsertRecv_swap_r23(amount0In,amount1In,amount0Out,amount1Out,to);
      bool r37 = updateSwapOnInsertRecv_swap_r37(amount0In,amount1In,amount0Out,amount1Out,to);
      bool r7 = updateSwapOnInsertRecv_swap_r7(amount0In,amount1In,amount0Out,amount1Out,to);
      bool r22 = updateSwapOnInsertRecv_swap_r22(amount0In,amount1In,amount0Out,amount1Out,to);
      if(r23==false && r37==false && r7==false && r22==false) {
        revert("Rule condition failed");
      }
  }
  function mint(address to,uint amount0,uint amount1) public    {
      bool r6 = updateMintOnInsertRecv_mint_r6(to,amount0,amount1);
      if(r6==false) {
        revert("Rule condition failed");
      }
  }
  function getReserve1() public view  returns (uint) {
      uint n = reserve1.n;
      return n;
  }
  function initialize(address token0,address token1) public    {
      bool r12 = updateInitializeOnInsertRecv_initialize_r12(token0,token1);
      if(r12==false) {
        revert("Rule condition failed");
      }
  }
  function getToken0() public view  returns (address) {
      address p = token0.p;
      return p;
  }
  function burn(address to,uint liquidity) public    {
      bool r29 = updateBurnOnInsertRecv_burn_r29(to,liquidity);
      if(r29==false) {
        revert("Rule condition failed");
      }
  }
  function getToken1() public view  returns (address) {
      address p = token1.p;
      return p;
  }
  function getReserve0() public view  returns (uint) {
      uint n = reserve0.n;
      return n;
  }
  function getInitialized() public view  returns (bool) {
      bool b = initialized.b;
      return b;
  }
  function getLpBalanceOf(address p) public view  returns (uint) {
      uint n = lpBalanceOf[p].n;
      return n;
  }
  function sync(uint balance0,uint balance1) public    {
      bool r21 = updateSyncActionOnInsertRecv_sync_r21(balance0,balance1);
      if(r21==false) {
        revert("Rule condition failed");
      }
  }
  function updateAllReserve0AddOnInsertConstructor_r4() private    {
      // Empty()
  }
  function updateFactoryOnInsertConstructor_r17() private    {
      address s = msg.sender;
      factory = FactoryTuple(s,true);
  }
  function updateTotalSupplyOnIncrementAllLpMint_r18(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateAllReserve1SubOnInsertConstructor_r9() private    {
      // Empty()
  }
  function updateReserve1OnIncrementAllReserve1Sub_r10(int b) private    {
      int _delta = int(-b);
      uint newValue = updateuintByint(reserve1.n,_delta);
      reserve1.n = newValue;
  }
  function updateAllLpMintOnInsertConstructor_r5() private    {
      // Empty()
  }
  function updateMintOnInsertRecv_mint_r6(address to,uint amount0,uint amount1) private   returns (bool) {
      if(true==initialized.b) {
        if(to!=address(0) && amount0>0 && amount1>0) {
          uint liquidity = amount0 < amount1 ? amount0 : amount1;
          updateReserve1AddOnInsertMint_r34(amount1);
          updateLpMintOnInsertMint_r36(to,liquidity);
          updateReserve0AddOnInsertMint_r0(amount0);
          emit Mint(to,amount0,amount1,liquidity);
          return true;
        }
      }
      return false;
  }
  function updateAllReserve1SubOnInsertReserve1Sub_r40(uint n) private    {
      int delta0 = int(n);
      updateReserve1OnIncrementAllReserve1Sub_r10(delta0);
  }
  function updateBurnOnInsertRecv_burn_r29(address to,uint liquidity) private   returns (bool) {
      if(true==initialized.b) {
        address from = msg.sender;
        uint m = lpBalanceOf[from].n;
        if(to!=address(0) && m>=liquidity) {
          uint amount0 = liquidity;
          uint amount1 = liquidity;
          updateLpBurnOnInsertBurn_r24(from,liquidity);
          updateReserve1SubOnInsertBurn_r3(amount1);
          updateReserve0SubOnInsertBurn_r32(amount0);
          emit Burn(from,to,liquidity,amount0,amount1);
          return true;
        }
      }
      return false;
  }
  function updateInitializedOnInsertConstructor_r30() private    {
      initialized = InitializedTuple(false,true);
  }
  function updateInitializeOnInsertRecv_initialize_r12(address t0,address t1) private   returns (bool) {
      if(false==initialized.b) {
        address s = factory.p;
        if(s==msg.sender) {
          if(t0!=address(0) && t1!=address(0) && t0!=t1) {
            updateToken0OnInsertInitialize_r35(t0);
            updateInitializedOnInsertInitialize_r27();
            updateToken1OnInsertInitialize_r16(t1);
            emit Initialize(t0,t1);
            return true;
          }
        }
      }
      return false;
  }
  function updateLpMintOnInsertMint_r36(address to,uint n) private    {
      updateTotalLpMintOnInsertLpMint_r14(to,n);
      updateAllLpMintOnInsertLpMint_r1(n);
  }
  function updateAllLpMintOnInsertLpMint_r1(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllLpMint_r18(delta0);
  }
  function updateReserve1OnIncrementAllReserve1Add_r10(int a) private    {
      int _delta = int(a);
      uint newValue = updateuintByint(reserve1.n,_delta);
      reserve1.n = newValue;
  }
  function updateReserve1SubOnInsertBurn_r3(uint n) private    {
      updateAllReserve1SubOnInsertReserve1Sub_r40(n);
  }
  function updateToken0OnInsertConstructor_r39() private    {
      token0 = Token0Tuple(address(0),true);
  }
  function updateSwapOnInsertRecv_swap_r7(uint amount0In,uint amount1In,uint amount0Out,uint amount1Out,address to) private   returns (bool) {
      if(true==initialized.b) {
        address s = msg.sender;
        if(to!=address(0) && amount0Out>0 && amount1In>0) {
          updateReserve1SubOnInsertSwap_r8(amount1Out);
          updateReserve0SubOnInsertSwap_r11(amount0Out);
          updateReserve1AddOnInsertSwap_r33(amount1In);
          updateReserve0AddOnInsertSwap_r25(amount0In);
          emit Swap(s,to,amount0In,amount1In,amount0Out,amount1Out);
          return true;
        }
      }
      return false;
  }
  function updateTotalSupplyOnIncrementAllLpBurn_r18(int b) private    {
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateSwapOnInsertRecv_swap_r23(uint amount0In,uint amount1In,uint amount0Out,uint amount1Out,address to) private   returns (bool) {
      if(true==initialized.b) {
        address s = msg.sender;
        if(to!=address(0) && amount0Out>0 && amount0In>0) {
          updateReserve1SubOnInsertSwap_r8(amount1Out);
          updateReserve0SubOnInsertSwap_r11(amount0Out);
          updateReserve1AddOnInsertSwap_r33(amount1In);
          updateReserve0AddOnInsertSwap_r25(amount0In);
          emit Swap(s,to,amount0In,amount1In,amount0Out,amount1Out);
          return true;
        }
      }
      return false;
  }
  function updateLpBurnOnInsertBurn_r24(address from,uint n) private    {
      updateTotalLpBurnOnInsertLpBurn_r41(from,n);
      updateAllLpBurnOnInsertLpBurn_r38(n);
  }
  function updateSwapOnInsertRecv_swap_r22(uint amount0In,uint amount1In,uint amount0Out,uint amount1Out,address to) private   returns (bool) {
      if(true==initialized.b) {
        address s = msg.sender;
        if(to!=address(0) && amount1Out>0 && amount0In>0) {
          updateReserve1SubOnInsertSwap_r8(amount1Out);
          updateReserve0SubOnInsertSwap_r11(amount0Out);
          updateReserve1AddOnInsertSwap_r33(amount1In);
          updateReserve0AddOnInsertSwap_r25(amount0In);
          emit Swap(s,to,amount0In,amount1In,amount0Out,amount1Out);
          return true;
        }
      }
      return false;
  }
  function updateAllLpBurnOnInsertLpBurn_r38(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllLpBurn_r18(delta0);
  }
  function updateTotalLpBurnOnInsertLpBurn_r41(address p,uint n) private    {
      int delta0 = int(n);
      updateLpBalanceOfOnIncrementTotalLpBurn_r42(p,delta0);
  }
  function updateReserve0SubOnInsertSwap_r11(uint n) private    {
      updateAllReserve0SubOnInsertReserve0Sub_r20(n);
  }
  function updateSyncActionOnInsertRecv_sync_r21(uint b0,uint b1) private   returns (bool) {
      if(true==initialized.b) {
        emit SyncAction(b0,b1);
        return true;
      }
      return false;
  }
  function updateSwapOnInsertRecv_swap_r37(uint amount0In,uint amount1In,uint amount0Out,uint amount1Out,address to) private   returns (bool) {
      if(true==initialized.b) {
        address s = msg.sender;
        if(to!=address(0) && amount1Out>0 && amount1In>0) {
          updateReserve1SubOnInsertSwap_r8(amount1Out);
          updateReserve0SubOnInsertSwap_r11(amount0Out);
          updateReserve1AddOnInsertSwap_r33(amount1In);
          updateReserve0AddOnInsertSwap_r25(amount0In);
          emit Swap(s,to,amount0In,amount1In,amount0Out,amount1Out);
          return true;
        }
      }
      return false;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateAllReserve0SubOnInsertReserve0Sub_r20(uint n) private    {
      int delta0 = int(n);
      updateReserve0OnIncrementAllReserve0Sub_r28(delta0);
  }
  function updateReserve1AddOnInsertSwap_r33(uint n) private    {
      updateAllReserve1AddOnInsertReserve1Add_r2(n);
  }
  function updateAllReserve1AddOnInsertConstructor_r31() private    {
      // Empty()
  }
  function updateLpBalanceOfOnIncrementTotalLpBurn_r42(address p,int b) private    {
      int _delta = int(-b);
      uint newValue = updateuintByint(lpBalanceOf[p].n,_delta);
      lpBalanceOf[p].n = newValue;
  }
  function updateReserve0SubOnInsertBurn_r32(uint n) private    {
      updateAllReserve0SubOnInsertReserve0Sub_r20(n);
  }
  function updateToken1OnInsertConstructor_r15() private    {
      token1 = Token1Tuple(address(0),true);
  }
  function updateReserve0OnIncrementAllReserve0Add_r28(int a) private    {
      int _delta = int(a);
      uint newValue = updateuintByint(reserve0.n,_delta);
      reserve0.n = newValue;
  }
  function updateLpBalanceOfOnIncrementTotalLpMint_r42(address p,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(lpBalanceOf[p].n,_delta);
      lpBalanceOf[p].n = newValue;
  }
  function updateToken1OnInsertInitialize_r16(address t1) private    {
      token1 = Token1Tuple(t1,true);
  }
  function updateToken0OnInsertInitialize_r35(address t0) private    {
      token0 = Token0Tuple(t0,true);
  }
  function updateReserve1SubOnInsertSwap_r8(uint n) private    {
      updateAllReserve1SubOnInsertReserve1Sub_r40(n);
  }
  function updateReserve1AddOnInsertMint_r34(uint n) private    {
      updateAllReserve1AddOnInsertReserve1Add_r2(n);
  }
  function updateInitializedOnInsertInitialize_r27() private    {
      initialized = InitializedTuple(true,true);
  }
  function updateTotalLpMintOnInsertLpMint_r14(address p,uint n) private    {
      int delta0 = int(n);
      updateLpBalanceOfOnIncrementTotalLpMint_r42(p,delta0);
  }
  function updateAllReserve0SubOnInsertConstructor_r19() private    {
      // Empty()
  }
  function updateAllReserve1AddOnInsertReserve1Add_r2(uint n) private    {
      int delta0 = int(n);
      updateReserve1OnIncrementAllReserve1Add_r10(delta0);
  }
  function updateAllLpBurnOnInsertConstructor_r26() private    {
      // Empty()
  }
  function updateAllReserve0AddOnInsertReserve0Add_r13(uint n) private    {
      int delta0 = int(n);
      updateReserve0OnIncrementAllReserve0Add_r28(delta0);
  }
  function updateReserve0AddOnInsertSwap_r25(uint n) private    {
      updateAllReserve0AddOnInsertReserve0Add_r13(n);
  }
  function updateReserve0OnIncrementAllReserve0Sub_r28(int b) private    {
      int _delta = int(-b);
      uint newValue = updateuintByint(reserve0.n,_delta);
      reserve0.n = newValue;
  }
  function updateReserve0AddOnInsertMint_r0(uint n) private    {
      updateAllReserve0AddOnInsertReserve0Add_r13(n);
  }
}