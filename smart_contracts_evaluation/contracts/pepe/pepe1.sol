contract Pepe {
  struct MinHoldingAmountTuple {
    uint n;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct TotalInTransferFromTuple {
    uint n;
    bool _valid;
  }
  struct TotalInTransferTuple {
    uint n;
    bool _valid;
  }
  struct TotalInitialTuple {
    uint n;
    bool _valid;
  }
  struct TotalOutTransferTuple {
    uint n;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct LimitedTuple {
    bool b;
    bool _valid;
  }
  struct MaxHoldingAmountTuple {
    uint n;
    bool _valid;
  }
  struct TotalBurnTuple {
    uint n;
    bool _valid;
  }
  struct SpentTotalTuple {
    uint n;
    bool _valid;
  }
  struct DecreaseAllowanceTotalTuple {
    uint n;
    bool _valid;
  }
  struct TotalOutTransferFromTuple {
    uint n;
    bool _valid;
  }
  struct BlacklistsTuple {
    bool b;
    bool _valid;
  }
  struct IncreaseAllowanceTotalTuple {
    uint n;
    bool _valid;
  }
  struct UniswapV2PairTuple {
    address p;
    bool _valid;
  }
  MinHoldingAmountTuple minHoldingAmount;
  mapping(address=>TotalBurnTuple) totalBurn;
  OwnerTuple owner;
  mapping(address=>TotalInTransferFromTuple) totalInTransferFrom;
  mapping(address=>TotalInTransferTuple) totalInTransfer;
  mapping(address=>TotalInitialTuple) totalInitial;
  mapping(address=>TotalOutTransferTuple) totalOutTransfer;
  TotalSupplyTuple totalSupply;
  LimitedTuple limited;
  mapping(address=>TotalOutTransferFromTuple) totalOutTransferFrom;
  MaxHoldingAmountTuple maxHoldingAmount;
  UniswapV2PairTuple uniswapV2Pair;
  mapping(address=>mapping(address=>SpentTotalTuple)) spentTotal;
  mapping(address=>mapping(address=>DecreaseAllowanceTotalTuple)) decreaseAllowanceTotal;
  mapping(address=>BlacklistsTuple) blacklists;
  mapping(address=>mapping(address=>IncreaseAllowanceTotalTuple)) increaseAllowanceTotal;
  event TransferFrom(address from,address to,address spender,uint amount);
  event Burn(address p,uint amount);
  event DecreaseAllowance(address p,address s,uint n);
  event SetRuleAction(bool b,address pair,uint max,uint min);
  event Transfer(address from,address to,uint amount);
  event IncreaseAllowance(address p,address s,uint n);
  event BlacklistAction(address p,bool b);
  constructor(uint totalSupply) public {
    updateMinHoldingAmountOnInsertConstructor_r26();
    updateMaxHoldingAmountOnInsertConstructor_r20();
    updateTotalSupplyOnInsertConstructor_r18(totalSupply);
    updateOwnerOnInsertConstructor_r21();
    updateUniswapV2PairOnInsertConstructor_r42();
    updateLimitedOnInsertConstructor_r36();
    updateInitialMintOnInsertConstructor_r32(totalSupply);
  }
  function decreaseAllowance(address s,uint n) public    {
      bool r5 = updateDecreaseAllowanceOnInsertRecv_decreaseAllowance_r5(s,n);
      if(r5==false) {
        revert("Rule condition failed");
      }
  }
  function getUniswapV2Pair() public view  returns (address) {
      address p = uniswapV2Pair.p;
      return p;
  }
  function getBlacklists(address p) public view  returns (bool) {
      bool b = blacklists[p].b;
      return b;
  }
  function burn(uint amount) public    {
      bool r27 = updateBurnOnInsertRecv_burn_r27(amount);
      if(r27==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r33 = updateTransferFromOnInsertRecv_transferFrom_r33(from,to,amount);
      bool r35 = updateTransferFromOnInsertRecv_transferFrom_r35(from,to,amount);
      bool r16 = updateTransferFromOnInsertRecv_transferFrom_r16(from,to,amount);
      bool r17 = updateTransferFromOnInsertRecv_transferFrom_r17(from,to,amount);
      bool r41 = updateTransferFromOnInsertRecv_transferFrom_r41(from,to,amount);
      if(r35==false && r17==false && r16==false && r33==false && r41==false) {
        revert("Rule condition failed");
      }
  }
  function transfer(address to,uint amount) public    {
      bool r11 = updateTransferOnInsertRecv_transfer_r11(to,amount);
      bool r38 = updateTransferOnInsertRecv_transfer_r38(to,amount);
      bool r44 = updateTransferOnInsertRecv_transfer_r44(to,amount);
      bool r6 = updateTransferOnInsertRecv_transfer_r6(to,amount);
      bool r43 = updateTransferOnInsertRecv_transfer_r43(to,amount);
      if(r38==false && r44==false && r6==false && r43==false && r11==false) {
        revert("Rule condition failed");
      }
  }
  function increaseAllowance(address s,uint n) public    {
      bool r39 = updateIncreaseAllowanceOnInsertRecv_increaseAllowance_r39(s,n);
      if(r39==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      uint n = balanceOf(p);
      return n;
  }
  function approve(address s,uint n) public    {
      bool r1 = updateDecreaseAllowanceOnInsertRecv_approve_r1(s,n);
      bool r31 = updateIncreaseAllowanceOnInsertRecv_approve_r31(s,n);
      if(r1==false && r31==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      uint n = allowance(p,s);
      return n;
  }
  function blacklist(address p,bool b) public    {
      bool r2 = updateBlacklistActionOnInsertRecv_blacklist_r2(p,b);
      if(r2==false) {
        revert("Rule condition failed");
      }
  }
  function getLimited() public view  returns (bool) {
      bool b = limited.b;
      return b;
  }
  function setRule(bool b,address pair,uint max,uint min) public    {
      bool r28 = updateSetRuleActionOnInsertRecv_setRule_r28(b,pair,max,min);
      if(r28==false) {
        revert("Rule condition failed");
      }
  }
  function balanceOf(address p) private view  returns (uint) {
      uint t1 = totalInTransfer[p].n;
      uint b = totalBurn[p].n;
      uint o2 = totalOutTransferFrom[p].n;
      uint o1 = totalOutTransfer[p].n;
      uint i = totalInitial[p].n;
      uint t2 = totalInTransferFrom[p].n;
      uint s = ((((i+t1)+t2)-o1)-o2)-b;
      return s;
  }
  function updateIncreaseAllowanceOnInsertRecv_increaseAllowance_r39(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      if(o!=address(0) && s!=address(0)) {
        updateIncreaseAllowanceTotalOnInsertIncreaseAllowance_r15(o,s,n);
        emit IncreaseAllowance(o,s,n);
        return true;
      }
      return false;
  }
  function updateTotalOutTransferOnInsertTransfer_r9(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalOutTransfer_r24(p,delta0);
      totalOutTransfer[p].n += n;
  }
  function updateInitialMintOnInsertTransfer_r13(address p) private    {
      updateTotalInitialOnInsertInitialMint_r3(p,uint(0));
  }
  function updateMinHoldingAmountOnInsertSetRuleAction_r14(uint n) private    {
      minHoldingAmount = MinHoldingAmountTuple(n,true);
  }
  function updateBalanceOfOnIncrementTotalBurn_r24(address p,int b) private    {
      // Empty()
  }
  function updateTransferFromOnInsertRecv_transferFrom_r33(address o,address r,uint n) private   returns (bool) {
      address p = uniswapV2Pair.p;
      address s = msg.sender;
      if(true==limited.b) {
        uint m = balanceOf(o);
        uint k = allowance(o,s);
        if(r!=address(0) && p!=address(0) && n<=m && n<=k && o!=address(0) && o!=p) {
          updateInitialMintOnInsertTransferFrom_r7(r);
          updateSpentTotalOnInsertTransferFrom_r0(o,s,n);
          updateTotalInTransferFromOnInsertTransferFrom_r40(r,n);
          updateInitialMintOnInsertTransferFrom_r22(o);
          updateTotalOutTransferFromOnInsertTransferFrom_r19(o,n);
          emit TransferFrom(o,r,s,n);
          return true;
        }
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalInTransfer_r24(address p,int t1) private    {
      // Empty()
  }
  function updateTransferOnInsertRecv_transfer_r44(address r,uint n) private   returns (bool) {
      if(r==owner.p) {
        address s = msg.sender;
        if(address(0)==uniswapV2Pair.p) {
          uint m = balanceOf(s);
          if(n<=m && s!=address(0) && r!=address(0)) {
            updateTotalOutTransferOnInsertTransfer_r9(s,n);
            updateTotalInTransferOnInsertTransfer_r34(r,n);
            updateInitialMintOnInsertTransfer_r13(s);
            updateInitialMintOnInsertTransfer_r8(r);
            emit Transfer(s,r,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalInTransferFrom_r24(address p,int t2) private    {
      // Empty()
  }
  function allowance(address o,address s) private view  returns (uint) {
      uint x = spentTotal[o][s].n;
      uint d = decreaseAllowanceTotal[o][s].n;
      uint i = increaseAllowanceTotal[o][s].n;
      uint n = (i-d)-x;
      return n;
  }
  function updateIncreaseAllowanceTotalOnInsertIncreaseAllowance_r15(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementIncreaseAllowanceTotal_r37(o,s,delta0);
      increaseAllowanceTotal[o][s].n += n;
  }
  function updateTotalBurnOnInsertBurn_r30(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalBurn_r24(p,delta0);
      totalBurn[p].n += n;
  }
  function updateBalanceOfOnIncrementTotalOutTransfer_r24(address p,int o1) private    {
      // Empty()
  }
  function updateTotalInTransferFromOnInsertTransferFrom_r40(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalInTransferFrom_r24(p,delta0);
      totalInTransferFrom[p].n += n;
  }
  function updateBalanceOfOnIncrementTotalInitial_r24(address p,int i) private    {
      // Empty()
  }
  function updateUniswapV2PairOnInsertConstructor_r42() private    {
      uniswapV2Pair = UniswapV2PairTuple(address(0),true);
  }
  function updateBlacklistActionOnInsertRecv_blacklist_r2(address p,bool b) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        updateBlacklistsOnInsertBlacklistAction_r4(p,b);
        emit BlacklistAction(p,b);
        return true;
      }
      return false;
  }
  function updateDecreaseAllowanceTotalOnInsertDecreaseAllowance_r12(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementDecreaseAllowanceTotal_r37(o,s,delta0);
      decreaseAllowanceTotal[o][s].n += n;
  }
  function updateBalanceOfOnIncrementTotalOutTransferFrom_r24(address p,int o2) private    {
      // Empty()
  }
  function updateDecreaseAllowanceOnInsertRecv_approve_r1(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance(o,s);
      if(n<m) {
        uint d = m-n;
        updateDecreaseAllowanceTotalOnInsertDecreaseAllowance_r12(o,s,d);
        emit DecreaseAllowance(o,s,d);
        return true;
      }
      return false;
  }
  function updateDecreaseAllowanceOnInsertRecv_decreaseAllowance_r5(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance(o,s);
      if(o!=address(0) && s!=address(0) && m>=n) {
        updateDecreaseAllowanceTotalOnInsertDecreaseAllowance_r12(o,s,n);
        emit DecreaseAllowance(o,s,n);
        return true;
      }
      return false;
  }
  function updateAllowanceOnIncrementIncreaseAllowanceTotal_r37(address o,address s,int i) private    {
      // Empty()
  }
  function updateTransferOnInsertRecv_transfer_r43(address r,uint n) private   returns (bool) {
      address p = uniswapV2Pair.p;
      address s = msg.sender;
      uint mx = maxHoldingAmount.n;
      if(true==limited.b) {
        uint mn = minHoldingAmount.n;
        uint m = balanceOf(s);
        uint b = balanceOf(r);
        if(r!=address(0) && p!=address(0) && b+n>=mn && n<=m && s==p && s!=address(0) && b+n<=mx) {
          updateTotalOutTransferOnInsertTransfer_r9(s,n);
          updateTotalInTransferOnInsertTransfer_r34(r,n);
          updateInitialMintOnInsertTransfer_r13(s);
          updateInitialMintOnInsertTransfer_r8(r);
          emit Transfer(s,r,n);
          return true;
        }
      }
      return false;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r41(address o,address r,uint n) private   returns (bool) {
      address p = uniswapV2Pair.p;
      address s = msg.sender;
      if(false==limited.b) {
        uint m = balanceOf(o);
        uint k = allowance(o,s);
        if(r!=address(0) && p!=address(0) && n<=m && n<=k && o!=address(0)) {
          updateInitialMintOnInsertTransferFrom_r7(r);
          updateSpentTotalOnInsertTransferFrom_r0(o,s,n);
          updateTotalInTransferFromOnInsertTransferFrom_r40(r,n);
          updateInitialMintOnInsertTransferFrom_r22(o);
          updateTotalOutTransferFromOnInsertTransferFrom_r19(o,n);
          emit TransferFrom(o,r,s,n);
          return true;
        }
      }
      return false;
  }
  function updateAllowanceOnIncrementDecreaseAllowanceTotal_r37(address o,address s,int d) private    {
      // Empty()
  }
  function updateTransferOnInsertRecv_transfer_r6(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      if(address(0)==uniswapV2Pair.p) {
        if(s==owner.p) {
          uint m = balanceOf(s);
          if(n<=m && s!=address(0) && r!=address(0)) {
            updateTotalOutTransferOnInsertTransfer_r9(s,n);
            updateTotalInTransferOnInsertTransfer_r34(r,n);
            updateInitialMintOnInsertTransfer_r13(s);
            updateInitialMintOnInsertTransfer_r8(r);
            emit Transfer(s,r,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateMaxHoldingAmountOnInsertConstructor_r20() private    {
      maxHoldingAmount = MaxHoldingAmountTuple(0,true);
  }
  function updateBurnOnInsertRecv_burn_r27(uint n) private   returns (bool) {
      address p = msg.sender;
      uint m = balanceOf(p);
      if(p!=address(0) && n<=m) {
        updateTotalBurnOnInsertBurn_r30(p,n);
        updateInitialMintOnInsertBurn_r29(p);
        emit Burn(p,n);
        return true;
      }
      return false;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateTotalInitialOnInsertInitialMint_r3(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalInitial_r24(p,delta0);
      totalInitial[p].n += n;
  }
  function updateTotalSupplyOnInsertConstructor_r18(uint n) private    {
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateBlacklistsOnInsertBlacklistAction_r4(address p,bool b) private    {
      blacklists[p] = BlacklistsTuple(b,true);
  }
  function updateLimitedOnInsertSetRuleAction_r10(bool b) private    {
      limited = LimitedTuple(b,true);
  }
  function updateTransferFromOnInsertRecv_transferFrom_r16(address o,address r,uint n) private   returns (bool) {
      if(r==owner.p) {
        address s = msg.sender;
        if(address(0)==uniswapV2Pair.p) {
          uint m = balanceOf(o);
          uint k = allowance(o,s);
          if(n<=m && n<=k && o!=address(0) && r!=address(0)) {
            updateInitialMintOnInsertTransferFrom_r7(r);
            updateSpentTotalOnInsertTransferFrom_r0(o,s,n);
            updateTotalInTransferFromOnInsertTransferFrom_r40(r,n);
            updateInitialMintOnInsertTransferFrom_r22(o);
            updateTotalOutTransferFromOnInsertTransferFrom_r19(o,n);
            emit TransferFrom(o,r,s,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateLimitedOnInsertConstructor_r36() private    {
      limited = LimitedTuple(false,true);
  }
  function updateTransferFromOnInsertRecv_transferFrom_r35(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      if(address(0)==uniswapV2Pair.p) {
        if(o==owner.p) {
          uint m = balanceOf(o);
          uint k = allowance(o,s);
          if(n<=m && n<=k && o!=address(0) && r!=address(0)) {
            updateInitialMintOnInsertTransferFrom_r7(r);
            updateSpentTotalOnInsertTransferFrom_r0(o,s,n);
            updateTotalInTransferFromOnInsertTransferFrom_r40(r,n);
            updateInitialMintOnInsertTransferFrom_r22(o);
            updateTotalOutTransferFromOnInsertTransferFrom_r19(o,n);
            emit TransferFrom(o,r,s,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateInitialMintOnInsertTransferFrom_r22(address p) private    {
      updateTotalInitialOnInsertInitialMint_r3(p,uint(0));
  }
  function updateMaxHoldingAmountOnInsertSetRuleAction_r25(uint n) private    {
      maxHoldingAmount = MaxHoldingAmountTuple(n,true);
  }
  function updateSpentTotalOnInsertTransferFrom_r0(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementSpentTotal_r37(o,s,delta0);
      spentTotal[o][s].n += n;
  }
  function updateUniswapV2PairOnInsertSetRuleAction_r23(address p) private    {
      uniswapV2Pair = UniswapV2PairTuple(p,true);
  }
  function updateInitialMintOnInsertTransfer_r8(address p) private    {
      updateTotalInitialOnInsertInitialMint_r3(p,uint(0));
  }
  function updateTotalOutTransferFromOnInsertTransferFrom_r19(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalOutTransferFrom_r24(p,delta0);
      totalOutTransferFrom[p].n += n;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r31(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance(o,s);
      if(n>=m) {
        uint d = n-m;
        updateIncreaseAllowanceTotalOnInsertIncreaseAllowance_r15(o,s,d);
        emit IncreaseAllowance(o,s,d);
        return true;
      }
      return false;
  }
  function updateInitialMintOnInsertBurn_r29(address p) private    {
      updateTotalInitialOnInsertInitialMint_r3(p,uint(0));
  }
  function updateOwnerOnInsertConstructor_r21() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateSetRuleActionOnInsertRecv_setRule_r28(bool b,address p,uint mx,uint mn) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        updateLimitedOnInsertSetRuleAction_r10(b);
        updateMinHoldingAmountOnInsertSetRuleAction_r14(mn);
        updateMaxHoldingAmountOnInsertSetRuleAction_r25(mx);
        updateUniswapV2PairOnInsertSetRuleAction_r23(p);
        emit SetRuleAction(b,p,mx,mn);
        return true;
      }
      return false;
  }
  function updateMinHoldingAmountOnInsertConstructor_r26() private    {
      minHoldingAmount = MinHoldingAmountTuple(0,true);
  }
  function updateTransferOnInsertRecv_transfer_r11(address r,uint n) private   returns (bool) {
      address p = uniswapV2Pair.p;
      address s = msg.sender;
      if(false==limited.b) {
        uint m = balanceOf(s);
        if(n<=m && s!=address(0) && r!=address(0) && p!=address(0)) {
          updateTotalOutTransferOnInsertTransfer_r9(s,n);
          updateTotalInTransferOnInsertTransfer_r34(r,n);
          updateInitialMintOnInsertTransfer_r13(s);
          updateInitialMintOnInsertTransfer_r8(r);
          emit Transfer(s,r,n);
          return true;
        }
      }
      return false;
  }
  function updateAllowanceOnIncrementSpentTotal_r37(address o,address s,int x) private    {
      // Empty()
  }
  function updateTransferFromOnInsertRecv_transferFrom_r17(address o,address r,uint n) private   returns (bool) {
      address p = uniswapV2Pair.p;
      address s = msg.sender;
      uint mx = maxHoldingAmount.n;
      if(true==limited.b) {
        uint mn = minHoldingAmount.n;
        uint b = balanceOf(r);
        uint m = balanceOf(o);
        uint k = allowance(o,s);
        if(r!=address(0) && p!=address(0) && b+n>=mn && n<=m && n<=k && b+n<=mx && o!=address(0) && o==p) {
          updateInitialMintOnInsertTransferFrom_r7(r);
          updateSpentTotalOnInsertTransferFrom_r0(o,s,n);
          updateTotalInTransferFromOnInsertTransferFrom_r40(r,n);
          updateInitialMintOnInsertTransferFrom_r22(o);
          updateTotalOutTransferFromOnInsertTransferFrom_r19(o,n);
          emit TransferFrom(o,r,s,n);
          return true;
        }
      }
      return false;
  }
  function updateTotalInTransferOnInsertTransfer_r34(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalInTransfer_r24(p,delta0);
      totalInTransfer[p].n += n;
  }
  function updateTransferOnInsertRecv_transfer_r38(address r,uint n) private   returns (bool) {
      address p = uniswapV2Pair.p;
      address s = msg.sender;
      if(true==limited.b) {
        uint m = balanceOf(s);
        if(r!=address(0) && s!=p && p!=address(0) && n<=m && s!=address(0)) {
          updateTotalOutTransferOnInsertTransfer_r9(s,n);
          updateTotalInTransferOnInsertTransfer_r34(r,n);
          updateInitialMintOnInsertTransfer_r13(s);
          updateInitialMintOnInsertTransfer_r8(r);
          emit Transfer(s,r,n);
          return true;
        }
      }
      return false;
  }
  function updateInitialMintOnInsertConstructor_r32(uint n) private    {
      address p = msg.sender;
      updateTotalInitialOnInsertInitialMint_r3(p,n);
  }
  function updateInitialMintOnInsertTransferFrom_r7(address p) private    {
      updateTotalInitialOnInsertInitialMint_r3(p,uint(0));
  }
}