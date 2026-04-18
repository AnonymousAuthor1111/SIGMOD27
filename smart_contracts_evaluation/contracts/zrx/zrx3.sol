contract Zrx {
  struct DecreaseTotalTuple {
    uint m;
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
  struct MaxUintTuple {
    uint n;
    bool _valid;
  }
  struct TotalBalancesTuple {
    uint m;
    bool _valid;
  }
  MaxUintTuple maxUint;
  mapping(address=>mapping(address=>DecreaseTotalTuple)) decreaseTotal;
  TotalSupplyTuple totalSupply;
  mapping(address=>mapping(address=>AllowanceTotalTuple)) allowanceTotal;
  TotalBalancesTuple totalBalances;
  mapping(address=>mapping(address=>SpentTotalTuple)) spentTotal;
  mapping(address=>BalanceOfTuple) balanceOf;
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
  function getAllowance(address p,address s) public view  returns (uint) {
      uint n = allowance(p,s);
      return n;
  }
  function updateAllowanceOnIncrementDecreaseTotal_r3(address o,address s,int d) private    {
      // Empty()
  }
  function updateTransferFromLimitedOnInsertRecv_transferFrom_r2(address o,address r,uint n) private   returns (bool) {
      uint max = maxUint.n;
      address s = msg.sender;
      uint m = balanceOf[o].n;
      uint k = allowance(o,s);
      if(m>=n && k>=n && k!=max) {
        updateSpentTotalOnInsertTransferFromLimited_r13(o,s,n);
        emit TransferFromLimited(o,r,s,n);
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
  function updateSpentTotalOnInsertTransferFromLimited_r13(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementSpentTotal_r3(o,s,delta0);
      spentTotal[o][s].m += n;
  }
  function updateTotalSupplyOnInsertConstructor_r8() private    {
      uint n = 1000000000;
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateDecreaseAllowanceOnInsertRecv_approve_r12(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance(o,s);
      if(n<m) {
        uint d = m-n;
        updateDecreaseTotalOnInsertDecreaseAllowance_r4(o,s,d);
        emit DecreaseAllowance(o,s,d);
        return true;
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalOut_r6(address p,int o) private    {
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
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
  function updateBalanceOfOnIncrementTotalIn_r6(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r0(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance(o,s);
      if(n>m) {
        uint d = n-m;
        updateAllowanceTotalOnInsertIncreaseAllowance_r18(o,s,d);
        emit IncreaseAllowance(o,s,d);
        return true;
      }
      return false;
  }
  function updateDecreaseTotalOnInsertDecreaseAllowance_r4(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementDecreaseTotal_r3(o,s,delta0);
      decreaseTotal[o][s].m += n;
  }
  function updateAllowanceOnIncrementAllowanceTotal_r3(address o,address s,int m) private    {
      // Empty()
  }
  function updateTotalBalancesOnInsertConstructor_r19() private    {
      totalBalances = TotalBalancesTuple(0,true);
  }
  function updateTransferOnInsertTransferFrom_r11(address o,address r,address _spender2,uint n) private    {
      updateTotalOutOnInsertTransfer_r16(o,n);
      updateTotalInOnInsertTransfer_r10(r,n);
      emit Transfer(o,r,n);
  }
  function updateTotalOutOnInsertTransfer_r16(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalOut_r6(p,delta0);
  }
  function updateAllowanceOnIncrementSpentTotal_r3(address o,address s,int l) private    {
      // Empty()
  }
  function allowance(address o,address s) private view  returns (uint) {
      uint d = decreaseTotal[o][s].m;
      uint l = spentTotal[o][s].m;
      uint m = allowanceTotal[o][s].m;
      uint n = (m-l)-d;
      return n;
  }
  function updateTotalInOnInsertTransfer_r10(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalIn_r6(p,delta0);
  }
  function updateTransferFromOnInsertRecv_transferFrom_r9(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint m = balanceOf[o].n;
      uint k = allowance(o,s);
      if(m>=n && k>=n) {
        updateTransferOnInsertTransferFrom_r11(o,r,s,n);
        return true;
      }
      return false;
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r18(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r3(o,s,delta0);
      allowanceTotal[o][s].m += n;
  }
  function updateMaxUintOnInsertConstructor_r7() private    {
      uint n = 999999999999;
      maxUint = MaxUintTuple(n,true);
  }
  function updateMintOnInsertConstructor_r1() private    {
      address s = msg.sender;
      uint n = 1000000000;
  }
}