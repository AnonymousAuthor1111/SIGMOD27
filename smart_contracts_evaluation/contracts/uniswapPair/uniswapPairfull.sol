contract UniswapPair {
  struct InitializedTuple {
    bool b;
    bool _valid;
  }
  struct Reserve1Tuple {
    uint n;
    bool _valid;
  }
  struct LpMintTuple {
    address to;
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
  struct Reserve1AddTuple {
    uint n;
    bool _valid;
  }
  struct Reserve0SubTuple {
    uint n;
    bool _valid;
  }
  struct AllLpMintTuple {
    uint n;
    bool _valid;
  }
  struct AllLpBurnTuple {
    uint n;
    bool _valid;
  }
  struct AllReserve1AddTuple {
    uint n;
    bool _valid;
  }
  struct Token1Tuple {
    address p;
    bool _valid;
  }
  struct Reserve0AddTuple {
    uint n;
    bool _valid;
  }
  struct TotalLpBurnTuple {
    uint n;
    bool _valid;
  }
  struct LpBalanceOfTuple {
    uint n;
    bool _valid;
  }
  struct AllReserve0AddTuple {
    uint n;
    bool _valid;
  }
  struct AllReserve1SubTuple {
    uint n;
    bool _valid;
  }
  struct AllReserve0SubTuple {
    uint n;
    bool _valid;
  }
  struct Reserve1SubTuple {
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
  struct TotalLpMintTuple {
    uint n;
    bool _valid;
  }
  struct LpBurnTuple {
    address from;
    uint n;
    bool _valid;
  }
  InitializedTuple initialized;
  Reserve1Tuple reserve1;
  LpMintTuple lpMint;
  FactoryTuple factory;
  TotalSupplyTuple totalSupply;
  Reserve1AddTuple reserve1Add;
  Reserve0SubTuple reserve0Sub;
  AllLpMintTuple allLpMint;
  AllLpBurnTuple allLpBurn;
  AllReserve1AddTuple allReserve1Add;
  Token1Tuple token1;
  Reserve0AddTuple reserve0Add;
  mapping(address=>TotalLpBurnTuple) totalLpBurn;
  mapping(address=>LpBalanceOfTuple) lpBalanceOf;
  AllReserve0AddTuple allReserve0Add;
  AllReserve1SubTuple allReserve1Sub;
  AllReserve0SubTuple allReserve0Sub;
  Reserve1SubTuple reserve1Sub;
  Reserve0Tuple reserve0;
  Token0Tuple token0;
  mapping(address=>TotalLpMintTuple) totalLpMint;
  LpBurnTuple lpBurn;
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
  function updateFactoryOnInsertConstructor_r17() private    {
      address s = msg.sender;
      factory = FactoryTuple(s,true);
  }
  function updateAllLpBurnOnInsertConstructor_r26() private    {
      updateTotalSupplyOnInsertAllLpBurn_r18(uint(0));
      allLpBurn = AllLpBurnTuple(0,true);
  }
  function updateReserve1OnIncrementAllReserve1Add_r10(int a) private    {
      int _delta = int(a);
      uint newValue = updateuintByint(allReserve1Add.n,_delta);
      updateReserve1OnInsertAllReserve1Add_r10(newValue);
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
  function updateToken1OnInsertConstructor_r15() private    {
      token1 = Token1Tuple(address(0),true);
  }
  function updateReserve1SubOnInsertSwap_r8(uint n) private    {
      updateAllReserve1SubOnInsertReserve1Sub_r40(n);
      reserve1Sub = Reserve1SubTuple(n,true);
  }
  function updateAllReserve1AddOnInsertConstructor_r31() private    {
      updateReserve1OnInsertAllReserve1Add_r10(uint(0));
      allReserve1Add = AllReserve1AddTuple(0,true);
  }
  function updateInitializedOnInsertInitialize_r27() private    {
      initialized = InitializedTuple(true,true);
  }
  function updateAllReserve1SubOnInsertConstructor_r9() private    {
      updateReserve1OnInsertAllReserve1Sub_r10(uint(0));
      allReserve1Sub = AllReserve1SubTuple(0,true);
  }
  function updateAllReserve1AddOnInsertReserve1Add_r2(uint n) private    {
      int delta1 = int(n);
      updateReserve1OnIncrementAllReserve1Add_r10(delta1);
      allReserve1Add.n += n;
  }
  function updateLpBalanceOfOnInsertTotalLpBurn_r42(address p,uint b) private    {
      TotalLpBurnTuple memory toDelete = totalLpBurn[p];
      if(toDelete._valid==true) {
        updateLpBalanceOfOnDeleteTotalLpBurn_r42(p,toDelete.n);
      }
      uint m = totalLpMint[p].n;
      uint n = m-b;
      lpBalanceOf[p] = LpBalanceOfTuple(n,true);
  }
  function updateAllReserve0SubOnInsertReserve0Sub_r20(uint n) private    {
      int delta1 = int(n);
      updateReserve0OnIncrementAllReserve0Sub_r28(delta1);
      allReserve0Sub.n += n;
  }
  function updateTotalLpBurnOnInsertLpBurn_r41(address p,uint n) private    {
      int delta1 = int(n);
      updateLpBalanceOfOnIncrementTotalLpBurn_r42(p,delta1);
      totalLpBurn[p].n += n;
  }
  function updateReserve0SubOnInsertBurn_r32(uint n) private    {
      updateAllReserve0SubOnInsertReserve0Sub_r20(n);
      reserve0Sub = Reserve0SubTuple(n,true);
  }
  function updateToken0OnInsertConstructor_r39() private    {
      token0 = Token0Tuple(address(0),true);
  }
  function updateReserve0AddOnInsertMint_r0(uint n) private    {
      updateAllReserve0AddOnInsertReserve0Add_r13(n);
      reserve0Add = Reserve0AddTuple(n,true);
  }
  function updateAllLpBurnOnInsertLpBurn_r38(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllLpBurn_r18(delta0);
      allLpBurn.n += n;
  }
  function updateLpBalanceOfOnDeleteTotalLpMint_r42(address p,uint m) private    {
      uint b = totalLpBurn[p].n;
      uint n = m-b;
      if(n==lpBalanceOf[p].n) {
        lpBalanceOf[p] = LpBalanceOfTuple(0,false);
      }
  }
  function updateTotalSupplyOnInsertAllLpBurn_r18(uint b) private    {
      uint m = allLpMint.n;
      uint n = m-b;
      totalSupply = TotalSupplyTuple(n,true);
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
  function updateReserve1OnIncrementAllReserve1Sub_r10(int b) private    {
      int _delta = int(b);
      uint newValue = updateuintByint(allReserve1Sub.n,_delta);
      updateReserve1OnInsertAllReserve1Sub_r10(newValue);
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
  function updateReserve1OnInsertAllReserve1Sub_r10(uint b) private    {
      uint a = allReserve1Add.n;
      uint n = a-b;
      reserve1 = Reserve1Tuple(n,true);
  }
  function updateReserve0SubOnInsertSwap_r11(uint n) private    {
      updateAllReserve0SubOnInsertReserve0Sub_r20(n);
      reserve0Sub = Reserve0SubTuple(n,true);
  }
  function updateAllReserve0SubOnInsertConstructor_r19() private    {
      updateReserve0OnInsertAllReserve0Sub_r28(uint(0));
      allReserve0Sub = AllReserve0SubTuple(0,true);
  }
  function updateLpBalanceOfOnInsertTotalLpMint_r42(address p,uint m) private    {
      TotalLpMintTuple memory toDelete = totalLpMint[p];
      if(toDelete._valid==true) {
        updateLpBalanceOfOnDeleteTotalLpMint_r42(p,toDelete.n);
      }
      uint b = totalLpBurn[p].n;
      uint n = m-b;
      lpBalanceOf[p] = LpBalanceOfTuple(n,true);
  }
  function updateReserve0OnIncrementAllReserve0Add_r28(int a) private    {
      int _delta = int(a);
      uint newValue = updateuintByint(allReserve0Add.n,_delta);
      updateReserve0OnInsertAllReserve0Add_r28(newValue);
  }
  function updateReserve1AddOnInsertSwap_r33(uint n) private    {
      updateAllReserve1AddOnInsertReserve1Add_r2(n);
      reserve1Add = Reserve1AddTuple(n,true);
  }
  function updateReserve0OnIncrementAllReserve0Sub_r28(int b) private    {
      int _delta = int(b);
      uint newValue = updateuintByint(allReserve0Sub.n,_delta);
      updateReserve0OnInsertAllReserve0Sub_r28(newValue);
  }
  function updateTotalSupplyOnInsertAllLpMint_r18(uint m) private    {
      uint b = allLpBurn.n;
      uint n = m-b;
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateReserve1SubOnInsertBurn_r3(uint n) private    {
      updateAllReserve1SubOnInsertReserve1Sub_r40(n);
      reserve1Sub = Reserve1SubTuple(n,true);
  }
  function updateReserve0OnInsertAllReserve0Add_r28(uint a) private    {
      uint b = allReserve0Sub.n;
      uint n = a-b;
      reserve0 = Reserve0Tuple(n,true);
  }
  function updateTotalSupplyOnIncrementAllLpBurn_r18(int b) private    {
      int _delta = int(b);
      uint newValue = updateuintByint(allLpBurn.n,_delta);
      updateTotalSupplyOnInsertAllLpBurn_r18(newValue);
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
  function updateAllReserve0AddOnInsertReserve0Add_r13(uint n) private    {
      int delta0 = int(n);
      updateReserve0OnIncrementAllReserve0Add_r28(delta0);
      allReserve0Add.n += n;
  }
  function updateAllLpMintOnInsertLpMint_r1(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllLpMint_r18(delta0);
      allLpMint.n += n;
  }
  function updateLpBalanceOfOnIncrementTotalLpBurn_r42(address p,int b) private    {
      int _delta = int(b);
      uint newValue = updateuintByint(totalLpBurn[p].n,_delta);
      updateLpBalanceOfOnInsertTotalLpBurn_r42(p,newValue);
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
  function updateLpBalanceOfOnIncrementTotalLpMint_r42(address p,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalLpMint[p].n,_delta);
      updateLpBalanceOfOnInsertTotalLpMint_r42(p,newValue);
  }
  function updateAllReserve1SubOnInsertReserve1Sub_r40(uint n) private    {
      int delta1 = int(n);
      updateReserve1OnIncrementAllReserve1Sub_r10(delta1);
      allReserve1Sub.n += n;
  }
  function updateReserve0AddOnInsertSwap_r25(uint n) private    {
      updateAllReserve0AddOnInsertReserve0Add_r13(n);
      reserve0Add = Reserve0AddTuple(n,true);
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
  function updateReserve1AddOnInsertMint_r34(uint n) private    {
      updateAllReserve1AddOnInsertReserve1Add_r2(n);
      reserve1Add = Reserve1AddTuple(n,true);
  }
  function updateReserve1OnInsertAllReserve1Add_r10(uint a) private    {
      uint b = allReserve1Sub.n;
      uint n = a-b;
      reserve1 = Reserve1Tuple(n,true);
  }
  function updateInitializedOnInsertConstructor_r30() private    {
      initialized = InitializedTuple(false,true);
  }
  function updateTotalSupplyOnIncrementAllLpMint_r18(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allLpMint.n,_delta);
      updateTotalSupplyOnInsertAllLpMint_r18(newValue);
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
  function updateTotalLpMintOnInsertLpMint_r14(address p,uint n) private    {
      int delta2 = int(n);
      updateLpBalanceOfOnIncrementTotalLpMint_r42(p,delta2);
      totalLpMint[p].n += n;
  }
  function updateAllReserve0AddOnInsertConstructor_r4() private    {
      updateReserve0OnInsertAllReserve0Add_r28(uint(0));
      allReserve0Add = AllReserve0AddTuple(0,true);
  }
  function updateLpMintOnInsertMint_r36(address to,uint n) private    {
      updateTotalLpMintOnInsertLpMint_r14(to,n);
      updateAllLpMintOnInsertLpMint_r1(n);
      lpMint = LpMintTuple(to,n,true);
  }
  function updateToken1OnInsertInitialize_r16(address t1) private    {
      token1 = Token1Tuple(t1,true);
  }
  function updateToken0OnInsertInitialize_r35(address t0) private    {
      token0 = Token0Tuple(t0,true);
  }
  function updateAllLpMintOnInsertConstructor_r5() private    {
      updateTotalSupplyOnInsertAllLpMint_r18(uint(0));
      allLpMint = AllLpMintTuple(0,true);
  }
  function updateLpBurnOnInsertBurn_r24(address from,uint n) private    {
      updateTotalLpBurnOnInsertLpBurn_r41(from,n);
      updateAllLpBurnOnInsertLpBurn_r38(n);
      lpBurn = LpBurnTuple(from,n,true);
  }
  function updateLpBalanceOfOnDeleteTotalLpBurn_r42(address p,uint b) private    {
      uint m = totalLpMint[p].n;
      uint n = m-b;
      if(n==lpBalanceOf[p].n) {
        lpBalanceOf[p] = LpBalanceOfTuple(0,false);
      }
  }
  function updateReserve0OnInsertAllReserve0Sub_r28(uint b) private    {
      uint a = allReserve0Add.n;
      uint n = a-b;
      reserve0 = Reserve0Tuple(n,true);
  }
}