contract Zrx {
  struct TotalInTuple {
    uint n;
    bool _valid;
  }
  struct DecreaseTotalTuple {
    uint m;
    bool _valid;
  }
  struct TotalMintTuple {
    uint n;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct AllowanceTotalTuple {
    uint m;
    bool _valid;
  }
  struct SpentTotalTuple {
    uint m;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  struct AllowanceTuple {
    uint n;
    bool _valid;
  }
  struct TotalOutTuple {
    uint n;
    bool _valid;
  }
  struct MintTuple {
    address p;
    uint amount;
    bool _valid;
  }
  struct MaxUintTuple {
    uint n;
    bool _valid;
  }
  struct TotalBalancesTuple {
    uint m;
    bool _valid;
  }
  mapping(address=>TotalInTuple) totalIn;
  mapping(address=>TotalOutTuple) totalOut;
  mapping(address=>mapping(address=>DecreaseTotalTuple)) decreaseTotal;
  mapping(address=>TotalMintTuple) totalMint;
  TotalSupplyTuple totalSupply;
  mapping(address=>mapping(address=>AllowanceTotalTuple)) allowanceTotal;
  TotalBalancesTuple totalBalances;
  mapping(address=>mapping(address=>SpentTotalTuple)) spentTotal;
  mapping(address=>BalanceOfTuple) balanceOf;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  MintTuple mint;
  MaxUintTuple maxUint;
  event DecreaseAllowance(address p,address s,uint n);
  event IncreaseAllowance(address p,address s,uint n);
  event TransferFromLimited(address from,address to,address spender,uint amount);
  event Transfer(address from,address to,uint amount);
  constructor() public {
    updateMaxUintOnInsertConstructor_r7();
    updateTotalBalancesOnInsertConstructor_r19();
    updateTotalSupplyOnInsertConstructor_r8();
    updateMintOnInsertConstructor_r1();
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r2 = updateTransferFromLimitedOnInsertRecv_transferFrom_r2(from,to,amount);
      bool r9 = updateTransferFromOnInsertRecv_transferFrom_r9(from,to,amount);
      if(r2==false && r9==false) {
        revert("Rule condition failed");
      }
  }
  function transfer(address to,uint amount) public    {
      bool r15 = updateTransferOnInsertRecv_transfer_r15(to,amount);
      if(r15==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      uint n = allowance[p][s].n;
      return n;
  }
  function getBalanceOf(address p) public view  returns (uint) {
      uint n = balanceOf[p].n;
      return n;
  }
  function approve(address s,uint n) public    {
      bool r0 = updateIncreaseAllowanceOnInsertRecv_approve_r0(s,n);
      bool r12 = updateDecreaseAllowanceOnInsertRecv_approve_r12(s,n);
      if(r0==false && r12==false) {
        revert("Rule condition failed");
      }
  }
  function updateAllowanceOnInsertSpentTotal_r3(address o,address s,uint l) private    {
      SpentTotalTuple memory toDelete = spentTotal[o][s];
      if(toDelete._valid==true) {
        updateAllowanceOnDeleteSpentTotal_r3(o,s,toDelete.m);
      }
      uint d = decreaseTotal[o][s].m;
      uint m = allowanceTotal[o][s].m;
      uint n = (m-l)-d;
      allowance[o][s] = AllowanceTuple(n,true);
  }
  function updateTotalOutOnInsertTransfer_r16(address p,uint n) private    {
      int delta2 = int(n);
      updateBalanceOfOnIncrementTotalOut_r6(p,delta2);
      totalOut[p].n += n;
  }
  function updateTransferFromLimitedOnInsertRecv_transferFrom_r2(address o,address r,uint n) private   returns (bool) {
      uint max = maxUint.n;
      address s = msg.sender;
      uint m = balanceOf[o].n;
      uint k = allowance[o][s].n;
      if(m>=n && k>=n && k!=max) {
        updateSpentTotalOnInsertTransferFromLimited_r13(o,s,n);
        emit TransferFromLimited(o,r,s,n);
        return true;
      }
      return false;
  }
  function updateAllowanceOnInsertAllowanceTotal_r3(address o,address s,uint m) private    {
      AllowanceTotalTuple memory toDelete = allowanceTotal[o][s];
      if(toDelete._valid==true) {
        updateAllowanceOnDeleteAllowanceTotal_r3(o,s,toDelete.m);
      }
      uint d = decreaseTotal[o][s].m;
      uint l = spentTotal[o][s].m;
      uint n = (m-l)-d;
      allowance[o][s] = AllowanceTuple(n,true);
  }
  function updateMintOnInsertConstructor_r1() private    {
      address s = msg.sender;
      uint n = 1000000000;
      mint = MintTuple(s,n,true);
  }
  function updateAllowanceOnDeleteAllowanceTotal_r3(address o,address s,uint m) private    {
      uint d = decreaseTotal[o][s].m;
      uint l = spentTotal[o][s].m;
      uint n = (m-l)-d;
      if(n==allowance[o][s].n) {
        allowance[o][s] = AllowanceTuple(0,false);
      }
  }
  function updateBalanceOfOnIncrementTotalOut_r6(address p,int o) private    {
      int _delta = int(o);
      uint newValue = updateuintByint(totalOut[p].n,_delta);
      updateBalanceOfOnInsertTotalOut_r6(p,newValue);
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r18(address o,address s,uint n) private    {
      int delta1 = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r3(o,s,delta1);
      allowanceTotal[o][s].m += n;
  }
  function updateTransferOnInsertRecv_transfer_r15(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint m = balanceOf[s].n;
      if(n<=m) {
        updateTotalOutOnInsertTransfer_r16(s,n);
        updateTotalInOnInsertTransfer_r10(r,n);
        emit Transfer(s,r,n);
        return true;
      }
      return false;
  }
  function updateAllowanceOnDeleteSpentTotal_r3(address o,address s,uint l) private    {
      uint d = decreaseTotal[o][s].m;
      uint m = allowanceTotal[o][s].m;
      uint n = (m-l)-d;
      if(n==allowance[o][s].n) {
        allowance[o][s] = AllowanceTuple(0,false);
      }
  }
  function updateAllowanceOnIncrementAllowanceTotal_r3(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowanceTotal[o][s].m,_delta);
      updateAllowanceOnInsertAllowanceTotal_r3(o,s,newValue);
  }
  function updateDecreaseTotalOnInsertDecreaseAllowance_r4(address o,address s,uint n) private    {
      int delta2 = int(n);
      updateAllowanceOnIncrementDecreaseTotal_r3(o,s,delta2);
      decreaseTotal[o][s].m += n;
  }
  function updateBalanceOfOnInsertTotalIn_r6(address p,uint i) private    {
      TotalInTuple memory toDelete = totalIn[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalIn_r6(p,toDelete.n);
      }
      uint o = totalOut[p].n;
      uint n = totalMint[p].n;
      uint s = (n+i)-o;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateBalanceOfOnIncrementTotalIn_r6(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(totalIn[p].n,_delta);
      updateBalanceOfOnInsertTotalIn_r6(p,newValue);
  }
  function updateBalanceOfOnDeleteTotalIn_r6(address p,uint i) private    {
      uint o = totalOut[p].n;
      uint n = totalMint[p].n;
      uint s = (n+i)-o;
      if(s==balanceOf[p].n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateBalanceOfOnInsertTotalOut_r6(address p,uint o) private    {
      TotalOutTuple memory toDelete = totalOut[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalOut_r6(p,toDelete.n);
      }
      uint i = totalIn[p].n;
      uint n = totalMint[p].n;
      uint s = (n+i)-o;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateTotalBalancesOnInsertConstructor_r19() private    {
      totalBalances = TotalBalancesTuple(0,true);
  }
  function updateTransferOnInsertTransferFrom_r11(address o,address r,address _spender2,uint n) private    {
      updateTotalOutOnInsertTransfer_r16(o,n);
      updateTotalInOnInsertTransfer_r10(r,n);
      emit Transfer(o,r,n);
  }
  function updateAllowanceOnInsertDecreaseTotal_r3(address o,address s,uint d) private    {
      DecreaseTotalTuple memory toDelete = decreaseTotal[o][s];
      if(toDelete._valid==true) {
        updateAllowanceOnDeleteDecreaseTotal_r3(o,s,toDelete.m);
      }
      uint l = spentTotal[o][s].m;
      uint m = allowanceTotal[o][s].m;
      uint n = (m-l)-d;
      allowance[o][s] = AllowanceTuple(n,true);
  }
  function updateDecreaseAllowanceOnInsertRecv_approve_r12(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance[o][s].n;
      if(n<m) {
        uint d = m-n;
        updateDecreaseTotalOnInsertDecreaseAllowance_r4(o,s,d);
        emit DecreaseAllowance(o,s,d);
        return true;
      }
      return false;
  }
  function updateBalanceOfOnDeleteTotalOut_r6(address p,uint o) private    {
      uint i = totalIn[p].n;
      uint n = totalMint[p].n;
      uint s = (n+i)-o;
      if(s==balanceOf[p].n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateAllowanceOnDeleteDecreaseTotal_r3(address o,address s,uint d) private    {
      uint l = spentTotal[o][s].m;
      uint m = allowanceTotal[o][s].m;
      uint n = (m-l)-d;
      if(n==allowance[o][s].n) {
        allowance[o][s] = AllowanceTuple(0,false);
      }
  }
  function updateSpentTotalOnInsertTransferFromLimited_r13(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementSpentTotal_r3(o,s,delta0);
      spentTotal[o][s].m += n;
  }
  function updateMaxUintOnInsertConstructor_r7() private    {
      uint n = 999999999999;
      maxUint = MaxUintTuple(n,true);
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r0(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance[o][s].n;
      if(n>m) {
        uint d = n-m;
        updateAllowanceTotalOnInsertIncreaseAllowance_r18(o,s,d);
        emit IncreaseAllowance(o,s,d);
        return true;
      }
      return false;
  }
  function updateAllowanceOnIncrementSpentTotal_r3(address o,address s,int l) private    {
      int _delta = int(l);
      uint newValue = updateuintByint(spentTotal[o][s].m,_delta);
      updateAllowanceOnInsertSpentTotal_r3(o,s,newValue);
  }
  function updateAllowanceOnIncrementDecreaseTotal_r3(address o,address s,int d) private    {
      int _delta = int(d);
      uint newValue = updateuintByint(decreaseTotal[o][s].m,_delta);
      updateAllowanceOnInsertDecreaseTotal_r3(o,s,newValue);
  }
  function updateTotalSupplyOnInsertConstructor_r8() private    {
      uint n = 1000000000;
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateTotalInOnInsertTransfer_r10(address p,uint n) private    {
      int delta2 = int(n);
      updateBalanceOfOnIncrementTotalIn_r6(p,delta2);
      totalIn[p].n += n;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r9(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint k = allowance[o][s].n;
      uint m = balanceOf[o].n;
      if(m>=n && k>=n) {
        updateTransferOnInsertTransferFrom_r11(o,r,s,n);
        return true;
      }
      return false;
  }
}