contract Pepe {
  struct InitialMintTuple {
    address p;
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
  struct IncreaseAllowanceTotalTuple {
    uint n;
    bool _valid;
  }
  struct BalanceOfTuple {
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
  struct AllowanceTuple {
    uint n;
    bool _valid;
  }
  InitialMintTuple initialMint;
  mapping(address=>TotalBurnTuple) totalBurn;
  OwnerTuple owner;
  mapping(address=>TotalInTransferFromTuple) totalInTransferFrom;
  mapping(address=>TotalInTransferTuple) totalInTransfer;
  mapping(address=>TotalInitialTuple) totalInitial;
  mapping(address=>TotalOutTransferTuple) totalOutTransfer;
  mapping(address=>TotalOutTransferFromTuple) totalOutTransferFrom;
  mapping(address=>mapping(address=>IncreaseAllowanceTotalTuple)) increaseAllowanceTotal;
  mapping(address=>BalanceOfTuple) balanceOf;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  mapping(address=>mapping(address=>SpentTotalTuple)) spentTotal;
  mapping(address=>mapping(address=>DecreaseAllowanceTotalTuple)) decreaseAllowanceTotal;
  event TransferFrom(address from,address to,address spender,uint amount);
  event Burn(address p,uint amount);
  event DecreaseAllowance(address p,address s,uint n);
  event SetRuleAction(bool b,address pair,uint max,uint min);
  event Transfer(address from,address to,uint amount);
  event IncreaseAllowance(address p,address s,uint n);
  event BlacklistAction(address p,bool b);
  constructor(uint totalSupply) public {
    updateTotalSupplyOnInsertConstructor_r16(totalSupply);
    updateOwnerOnInsertConstructor_r19();
    updateInitialMintOnInsertConstructor_r30(totalSupply);
    updateMinHoldingAmountOnInsertConstructor_r24();
    updateMaxHoldingAmountOnInsertConstructor_r18();
    updateUniswapV2PairOnInsertConstructor_r10();
    updateLimitedOnInsertConstructor_r31();
  }
  function approve(address s,uint n) public    {
      bool r29 = updateIncreaseAllowanceOnInsertRecv_approve_r29(s,n);
      bool r0 = updateDecreaseAllowanceOnInsertRecv_approve_r0(s,n);
      if(r29==false && r0==false) {
        revert("Rule condition failed");
      }
  }
  function increaseAllowance(address s,uint n) public    {
      bool r34 = updateIncreaseAllowanceOnInsertRecv_increaseAllowance_r34(s,n);
      if(r34==false) {
        revert("Rule condition failed");
      }
  }
  function decreaseAllowance(address s,uint n) public    {
      bool r4 = updateDecreaseAllowanceOnInsertRecv_decreaseAllowance_r4(s,n);
      if(r4==false) {
        revert("Rule condition failed");
      }
  }
  function blacklist(address p,bool b) public    {
      bool r1 = updateBlacklistActionOnInsertRecv_blacklist_r1(p,b);
      if(r1==false) {
        revert("Rule condition failed");
      }
  }
  function burn(uint amount) public    {
      bool r25 = updateBurnOnInsertRecv_burn_r25(amount);
      if(r25==false) {
        revert("Rule condition failed");
      }
  }
  function setRule(bool b,address pair,uint max,uint min) public    {
      bool r26 = updateSetRuleActionOnInsertRecv_setRule_r26(b,pair,max,min);
      if(r26==false) {
        revert("Rule condition failed");
      }
  }
  function transfer(address to,uint amount) public    {
      bool r33 = updateTransferOnInsertRecv_transfer_r33(to,amount);
      if(r33==false) {
        revert("Rule condition failed");
      }
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r13 = updateTransferFromOnInsertRecv_transferFrom_r13(from,to,amount);
      if(r13==false) {
        revert("Rule condition failed");
      }
  }
  function updateTotalInitialOnInsertInitialMint_r2(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalInitial_r22(p,delta0);
      totalInitial[p].n += n;
  }
  function updateOwnerOnInsertConstructor_r19() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateInitialMintOnInsertTransfer_r11(address p) private    {
      updateTotalInitialOnInsertInitialMint_r2(p,uint(0));
      initialMint = InitialMintTuple(p,0,true);
  }
  function updateUniswapV2PairOnInsertConstructor_r10() private    {
      // Empty()
  }
  function updateBalanceOfOnIncrementTotalOutTransfer_r22(address p,int o1) private    {
      int _delta = int(o1);
      uint newValue = updateuintByint(totalOutTransfer[p].n,_delta);
      updateBalanceOfOnInsertTotalOutTransfer_r22(p,newValue);
  }
  function updateAllowanceOnInsertSpentTotal_r32(address o,address s,uint x) private    {
      SpentTotalTuple memory toDelete = spentTotal[o][s];
      if(toDelete._valid==true) {
        updateAllowanceOnDeleteSpentTotal_r32(o,s,toDelete.n);
      }
      uint d = decreaseAllowanceTotal[o][s].n;
      uint i = increaseAllowanceTotal[o][s].n;
      uint n = (i-d)-x;
      allowance[o][s] = AllowanceTuple(n,true);
  }
  function updateAllowanceOnIncrementDecreaseAllowanceTotal_r32(address o,address s,int d) private    {
      int _delta = int(d);
      uint newValue = updateuintByint(decreaseAllowanceTotal[o][s].n,_delta);
      updateAllowanceOnInsertDecreaseAllowanceTotal_r32(o,s,newValue);
  }
  function updateDecreaseAllowanceOnInsertRecv_approve_r0(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance[o][s].n;
      if(n<m) {
        uint d = m-n;
        updateDecreaseAllowanceTotalOnInsertDecreaseAllowance_r9(o,s,d);
        emit DecreaseAllowance(o,s,d);
        return true;
      }
      return false;
  }
  function updateBalanceOfOnInsertTotalInTransfer_r22(address p,uint t1) private    {
      TotalInTransferTuple memory toDelete = totalInTransfer[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalInTransfer_r22(p,toDelete.n);
      }
      uint b = totalBurn[p].n;
      uint o2 = totalOutTransferFrom[p].n;
      uint o1 = totalOutTransfer[p].n;
      uint i = totalInitial[p].n;
      uint t2 = totalInTransferFrom[p].n;
      uint s = ((((i+t1)+t2)-o1)-o2)-b;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateBalanceOfOnDeleteTotalInTransferFrom_r22(address p,uint t2) private    {
      uint t1 = totalInTransfer[p].n;
      uint b = totalBurn[p].n;
      uint o2 = totalOutTransferFrom[p].n;
      uint o1 = totalOutTransfer[p].n;
      uint i = totalInitial[p].n;
      uint s = ((((i+t1)+t2)-o1)-o2)-b;
      if(s==balanceOf[p].n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateInitialMintOnInsertTransfer_r6(address p) private    {
      updateTotalInitialOnInsertInitialMint_r2(p,uint(0));
      initialMint = InitialMintTuple(p,0,true);
  }
  function updateAllowanceOnDeleteIncreaseAllowanceTotal_r32(address o,address s,uint i) private    {
      uint x = spentTotal[o][s].n;
      uint d = decreaseAllowanceTotal[o][s].n;
      uint n = (i-d)-x;
      if(n==allowance[o][s].n) {
        allowance[o][s] = AllowanceTuple(0,false);
      }
  }
  function updateTotalSupplyOnInsertConstructor_r16(uint n) private    {
      // Empty()
  }
  function updateBalanceOfOnInsertTotalOutTransfer_r22(address p,uint o1) private    {
      TotalOutTransferTuple memory toDelete = totalOutTransfer[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalOutTransfer_r22(p,toDelete.n);
      }
      uint t1 = totalInTransfer[p].n;
      uint b = totalBurn[p].n;
      uint o2 = totalOutTransferFrom[p].n;
      uint i = totalInitial[p].n;
      uint t2 = totalInTransferFrom[p].n;
      uint s = ((((i+t1)+t2)-o1)-o2)-b;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateBalanceOfOnIncrementTotalOutTransferFrom_r22(address p,int o2) private    {
      int _delta = int(o2);
      uint newValue = updateuintByint(totalOutTransferFrom[p].n,_delta);
      updateBalanceOfOnInsertTotalOutTransferFrom_r22(p,newValue);
  }
  function updateBalanceOfOnInsertTotalOutTransferFrom_r22(address p,uint o2) private    {
      TotalOutTransferFromTuple memory toDelete = totalOutTransferFrom[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalOutTransferFrom_r22(p,toDelete.n);
      }
      uint t1 = totalInTransfer[p].n;
      uint b = totalBurn[p].n;
      uint o1 = totalOutTransfer[p].n;
      uint i = totalInitial[p].n;
      uint t2 = totalInTransferFrom[p].n;
      uint s = ((((i+t1)+t2)-o1)-o2)-b;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateBalanceOfOnInsertTotalBurn_r22(address p,uint b) private    {
      TotalBurnTuple memory toDelete = totalBurn[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalBurn_r22(p,toDelete.n);
      }
      uint t1 = totalInTransfer[p].n;
      uint o2 = totalOutTransferFrom[p].n;
      uint o1 = totalOutTransfer[p].n;
      uint i = totalInitial[p].n;
      uint t2 = totalInTransferFrom[p].n;
      uint s = ((((i+t1)+t2)-o1)-o2)-b;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateBalanceOfOnIncrementTotalInitial_r22(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(totalInitial[p].n,_delta);
      updateBalanceOfOnInsertTotalInitial_r22(p,newValue);
  }
  function updateTotalInTransferFromOnInsertTransferFrom_r35(address p,uint n) private    {
      int delta2 = int(n);
      updateBalanceOfOnIncrementTotalInTransferFrom_r22(p,delta2);
      totalInTransferFrom[p].n += n;
  }
  function updateInitialMintOnInsertTransferFrom_r20(address p) private    {
      updateTotalInitialOnInsertInitialMint_r2(p,uint(0));
      initialMint = InitialMintTuple(p,0,true);
  }
  function updateIncreaseAllowanceOnInsertRecv_increaseAllowance_r34(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      if(o!=address(0) && s!=address(0)) {
        updateIncreaseAllowanceTotalOnInsertIncreaseAllowance_r15(o,s,n);
        emit IncreaseAllowance(o,s,n);
        return true;
      }
      return false;
  }
  function updateAllowanceOnDeleteDecreaseAllowanceTotal_r32(address o,address s,uint d) private    {
      uint x = spentTotal[o][s].n;
      uint i = increaseAllowanceTotal[o][s].n;
      uint n = (i-d)-x;
      if(n==allowance[o][s].n) {
        allowance[o][s] = AllowanceTuple(0,false);
      }
  }
  function updateBalanceOfOnInsertTotalInTransferFrom_r22(address p,uint t2) private    {
      TotalInTransferFromTuple memory toDelete = totalInTransferFrom[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalInTransferFrom_r22(p,toDelete.n);
      }
      uint t1 = totalInTransfer[p].n;
      uint b = totalBurn[p].n;
      uint o2 = totalOutTransferFrom[p].n;
      uint o1 = totalOutTransfer[p].n;
      uint i = totalInitial[p].n;
      uint s = ((((i+t1)+t2)-o1)-o2)-b;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateBlacklistActionOnInsertRecv_blacklist_r1(address p,bool b) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        emit BlacklistAction(p,b);
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
  function updateBalanceOfOnDeleteTotalOutTransfer_r22(address p,uint o1) private    {
      uint t1 = totalInTransfer[p].n;
      uint b = totalBurn[p].n;
      uint o2 = totalOutTransferFrom[p].n;
      uint i = totalInitial[p].n;
      uint t2 = totalInTransferFrom[p].n;
      uint s = ((((i+t1)+t2)-o1)-o2)-b;
      if(s==balanceOf[p].n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateTransferOnInsertRecv_transfer_r33(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint m = balanceOf[s].n;
      if(n<=m && s!=address(0) && r!=address(0)) {
        updateTotalInTransferOnInsertTransfer_r3(r,n);
        updateTotalOutTransferOnInsertTransfer_r7(s,n);
        updateInitialMintOnInsertTransfer_r6(r);
        updateInitialMintOnInsertTransfer_r11(s);
        emit Transfer(s,r,n);
        return true;
      }
      return false;
  }
  function updateInitialMintOnInsertConstructor_r30(uint n) private    {
      address p = msg.sender;
      updateTotalInitialOnInsertInitialMint_r2(p,n);
      initialMint = InitialMintTuple(p,n,true);
  }
  function updateTransferFromOnInsertRecv_transferFrom_r13(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint k = allowance[o][s].n;
      uint m = balanceOf[o].n;
      if(n<=m && n<=k && o!=address(0) && r!=address(0)) {
        updateSpentTotalOnInsertTransferFrom_r12(o,s,n);
        updateInitialMintOnInsertTransferFrom_r20(o);
        updateInitialMintOnInsertTransferFrom_r5(r);
        updateTotalOutTransferFromOnInsertTransferFrom_r17(o,n);
        updateTotalInTransferFromOnInsertTransferFrom_r35(r,n);
        emit TransferFrom(o,r,s,n);
        return true;
      }
      return false;
  }
  function updateBalanceOfOnDeleteTotalInTransfer_r22(address p,uint t1) private    {
      uint b = totalBurn[p].n;
      uint o2 = totalOutTransferFrom[p].n;
      uint o1 = totalOutTransfer[p].n;
      uint i = totalInitial[p].n;
      uint t2 = totalInTransferFrom[p].n;
      uint s = ((((i+t1)+t2)-o1)-o2)-b;
      if(s==balanceOf[p].n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateTotalInTransferOnInsertTransfer_r3(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalInTransfer_r22(p,delta0);
      totalInTransfer[p].n += n;
  }
  function updateAllowanceOnIncrementIncreaseAllowanceTotal_r32(address o,address s,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(increaseAllowanceTotal[o][s].n,_delta);
      updateAllowanceOnInsertIncreaseAllowanceTotal_r32(o,s,newValue);
  }
  function updateAllowanceOnInsertIncreaseAllowanceTotal_r32(address o,address s,uint i) private    {
      IncreaseAllowanceTotalTuple memory toDelete = increaseAllowanceTotal[o][s];
      if(toDelete._valid==true) {
        updateAllowanceOnDeleteIncreaseAllowanceTotal_r32(o,s,toDelete.n);
      }
      uint x = spentTotal[o][s].n;
      uint d = decreaseAllowanceTotal[o][s].n;
      uint n = (i-d)-x;
      allowance[o][s] = AllowanceTuple(n,true);
  }
  function updateSpentTotalOnInsertTransferFrom_r12(address o,address s,uint n) private    {
      int delta1 = int(n);
      updateAllowanceOnIncrementSpentTotal_r32(o,s,delta1);
      spentTotal[o][s].n += n;
  }
  function updateTotalOutTransferFromOnInsertTransferFrom_r17(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalOutTransferFrom_r22(p,delta0);
      totalOutTransferFrom[p].n += n;
  }
  function updateBalanceOfOnDeleteTotalOutTransferFrom_r22(address p,uint o2) private    {
      uint t1 = totalInTransfer[p].n;
      uint b = totalBurn[p].n;
      uint o1 = totalOutTransfer[p].n;
      uint i = totalInitial[p].n;
      uint t2 = totalInTransferFrom[p].n;
      uint s = ((((i+t1)+t2)-o1)-o2)-b;
      if(s==balanceOf[p].n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateSetRuleActionOnInsertRecv_setRule_r26(bool b,address p,uint mx,uint mn) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        emit SetRuleAction(b,p,mx,mn);
        return true;
      }
      return false;
  }
  function updateTotalBurnOnInsertBurn_r28(address p,uint n) private    {
      int delta1 = int(n);
      updateBalanceOfOnIncrementTotalBurn_r22(p,delta1);
      totalBurn[p].n += n;
  }
  function updateDecreaseAllowanceTotalOnInsertDecreaseAllowance_r9(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementDecreaseAllowanceTotal_r32(o,s,delta0);
      decreaseAllowanceTotal[o][s].n += n;
  }
  function updateAllowanceOnInsertDecreaseAllowanceTotal_r32(address o,address s,uint d) private    {
      DecreaseAllowanceTotalTuple memory toDelete = decreaseAllowanceTotal[o][s];
      if(toDelete._valid==true) {
        updateAllowanceOnDeleteDecreaseAllowanceTotal_r32(o,s,toDelete.n);
      }
      uint x = spentTotal[o][s].n;
      uint i = increaseAllowanceTotal[o][s].n;
      uint n = (i-d)-x;
      allowance[o][s] = AllowanceTuple(n,true);
  }
  function updateDecreaseAllowanceOnInsertRecv_decreaseAllowance_r4(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance[o][s].n;
      if(o!=address(0) && s!=address(0) && m>=n) {
        updateDecreaseAllowanceTotalOnInsertDecreaseAllowance_r9(o,s,n);
        emit DecreaseAllowance(o,s,n);
        return true;
      }
      return false;
  }
  function updateIncreaseAllowanceTotalOnInsertIncreaseAllowance_r15(address o,address s,uint n) private    {
      int delta1 = int(n);
      updateAllowanceOnIncrementIncreaseAllowanceTotal_r32(o,s,delta1);
      increaseAllowanceTotal[o][s].n += n;
  }
  function updateBalanceOfOnInsertTotalInitial_r22(address p,uint i) private    {
      TotalInitialTuple memory toDelete = totalInitial[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalInitial_r22(p,toDelete.n);
      }
      uint t1 = totalInTransfer[p].n;
      uint b = totalBurn[p].n;
      uint o2 = totalOutTransferFrom[p].n;
      uint o1 = totalOutTransfer[p].n;
      uint t2 = totalInTransferFrom[p].n;
      uint s = ((((i+t1)+t2)-o1)-o2)-b;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r29(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance[o][s].n;
      if(n>=m) {
        uint d = n-m;
        updateIncreaseAllowanceTotalOnInsertIncreaseAllowance_r15(o,s,d);
        emit IncreaseAllowance(o,s,d);
        return true;
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalBurn_r22(address p,int b) private    {
      int _delta = int(b);
      uint newValue = updateuintByint(totalBurn[p].n,_delta);
      updateBalanceOfOnInsertTotalBurn_r22(p,newValue);
  }
  function updateAllowanceOnIncrementSpentTotal_r32(address o,address s,int x) private    {
      int _delta = int(x);
      uint newValue = updateuintByint(spentTotal[o][s].n,_delta);
      updateAllowanceOnInsertSpentTotal_r32(o,s,newValue);
  }
  function updateBalanceOfOnIncrementTotalInTransferFrom_r22(address p,int t2) private    {
      int _delta = int(t2);
      uint newValue = updateuintByint(totalInTransferFrom[p].n,_delta);
      updateBalanceOfOnInsertTotalInTransferFrom_r22(p,newValue);
  }
  function updateMaxHoldingAmountOnInsertConstructor_r18() private    {
      // Empty()
  }
  function updateInitialMintOnInsertBurn_r27(address p) private    {
      updateTotalInitialOnInsertInitialMint_r2(p,uint(0));
      initialMint = InitialMintTuple(p,0,true);
  }
  function updateMinHoldingAmountOnInsertConstructor_r24() private    {
      // Empty()
  }
  function updateAllowanceOnDeleteSpentTotal_r32(address o,address s,uint x) private    {
      uint d = decreaseAllowanceTotal[o][s].n;
      uint i = increaseAllowanceTotal[o][s].n;
      uint n = (i-d)-x;
      if(n==allowance[o][s].n) {
        allowance[o][s] = AllowanceTuple(0,false);
      }
  }
  function updateTotalOutTransferOnInsertTransfer_r7(address p,uint n) private    {
      int delta2 = int(n);
      updateBalanceOfOnIncrementTotalOutTransfer_r22(p,delta2);
      totalOutTransfer[p].n += n;
  }
  function updateBalanceOfOnDeleteTotalInitial_r22(address p,uint i) private    {
      uint t1 = totalInTransfer[p].n;
      uint b = totalBurn[p].n;
      uint o2 = totalOutTransferFrom[p].n;
      uint o1 = totalOutTransfer[p].n;
      uint t2 = totalInTransferFrom[p].n;
      uint s = ((((i+t1)+t2)-o1)-o2)-b;
      if(s==balanceOf[p].n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateBalanceOfOnDeleteTotalBurn_r22(address p,uint b) private    {
      uint t1 = totalInTransfer[p].n;
      uint o2 = totalOutTransferFrom[p].n;
      uint o1 = totalOutTransfer[p].n;
      uint i = totalInitial[p].n;
      uint t2 = totalInTransferFrom[p].n;
      uint s = ((((i+t1)+t2)-o1)-o2)-b;
      if(s==balanceOf[p].n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateBalanceOfOnIncrementTotalInTransfer_r22(address p,int t1) private    {
      int _delta = int(t1);
      uint newValue = updateuintByint(totalInTransfer[p].n,_delta);
      updateBalanceOfOnInsertTotalInTransfer_r22(p,newValue);
  }
  function updateBurnOnInsertRecv_burn_r25(uint n) private   returns (bool) {
      address p = msg.sender;
      uint m = balanceOf[p].n;
      if(p!=address(0) && n<=m) {
        updateTotalBurnOnInsertBurn_r28(p,n);
        updateInitialMintOnInsertBurn_r27(p);
        emit Burn(p,n);
        return true;
      }
      return false;
  }
  function updateLimitedOnInsertConstructor_r31() private    {
      // Empty()
  }
  function updateInitialMintOnInsertTransferFrom_r5(address p) private    {
      updateTotalInitialOnInsertInitialMint_r2(p,uint(0));
      initialMint = InitialMintTuple(p,0,true);
  }
}