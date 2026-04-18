contract Weth {
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct AllowanceTuple {
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
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  MaxUintTuple maxUint;
  TotalSupplyTuple totalSupply;
  TotalBalancesTuple totalBalances;
  mapping(address=>BalanceOfTuple) balanceOf;
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  event Withdraw(address p,uint amount);
  event DecreaseAllowance(address p,address s,uint n);
  event TransferFromLimited(address from,address to,address spender,uint amount);
  event Transfer(address from,address to,uint amount);
  event Deposit(address p,uint amount);
  event IncreaseAllowance(address p,address s,uint n);
  constructor() public {
    updateTotalBalancesOnInsertConstructor_r27();
    updateMaxUintOnInsertConstructor_r8();
  }
  function approve(address s,uint n) public    {
      bool r0 = updateIncreaseAllowanceOnInsertRecv_approve_r0(s,n);
      bool r14 = updateDecreaseAllowanceOnInsertRecv_approve_r14(s,n);
      if(r0==false && r14==false) {
        revert("Rule condition failed");
      }
  }
  function deposit() public  payable  {
      bool r1 = updateDepositOnInsertRecv_deposit_r1();
      if(r1==false) {
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
  function transferFrom(address src,address dst,uint amount) public    {
      bool r10 = updateTransferFromOnInsertRecv_transferFrom_r10(src,dst,amount);
      bool r7 = updateTransferFromLimitedOnInsertRecv_transferFrom_r7(src,dst,amount);
      bool r4 = updateTransferFromOnInsertRecv_transferFrom_r4(src,dst,amount);
      if(r10==false && r7==false && r4==false) {
        revert("Rule condition failed");
      }
  }
  function withdraw(uint wad) public    {
      bool r21 = updateWithdrawOnInsertRecv_withdraw_r21(wad);
      if(r21==false) {
        revert("Rule condition failed");
      }
  }
  function transfer(address to,uint amount) public    {
      bool r19 = updateTransferOnInsertRecv_transfer_r19(to,amount);
      if(r19==false) {
        revert("Rule condition failed");
      }
  }
  function updateTransferFromLimitedOnInsertRecv_transferFrom_r7(address o,address r,uint n) private   returns (bool) {
      uint max = maxUint.n;
      address s = msg.sender;
      uint m = balanceOf[o].n;
      uint k = allowance[o][s].n;
      if(o!=s && m>=n && k>=n && k!=max) {
        updateSpentTotalOnInsertTransferFromLimited_r15(o,s,n);
        emit TransferFromLimited(o,r,s,n);
        return true;
      }
      return false;
  }
  function updateMaxUintOnInsertConstructor_r8() private    {
      uint n = 999999999999;
      maxUint = MaxUintTuple(n,true);
  }
  function updateBalanceOfOnIncrementTotalOut_r23(address p,int o) private    {
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateSpentTotalOnInsertTransferFromLimited_r15(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementSpentTotal_r3(o,s,delta0);
  }
  function updateAllowanceOnIncrementAllowanceTotal_r3(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateAllMintOnInsertMint_r2(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllMint_r18(delta0);
  }
  function updateBurnOnInsertWithdraw_r25(address p,uint n) private    {
      updateTotalBurnOnInsertBurn_r16(p,n);
      updateAllBurnOnInsertBurn_r11(n);
  }
  function updateTotalBurnOnInsertBurn_r16(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalBurn_r23(p,delta0);
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r0(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance[o][s].n;
      if(n>m) {
        uint d = n-m;
        updateAllowanceTotalOnInsertIncreaseAllowance_r26(o,s,d);
        emit IncreaseAllowance(o,s,d);
        return true;
      }
      return false;
  }
  function updateWithdrawOnInsertRecv_withdraw_r21(uint n) private   returns (bool) {
      address p = msg.sender;
      uint m = balanceOf[p].n;
      if(n<=m) {
        updateSendOnInsertWithdraw_r24(p,n);
        updateBurnOnInsertWithdraw_r25(p,n);
        emit Withdraw(p,n);
        return true;
      }
      return false;
  }
  function updateTransferOnInsertRecv_transfer_r19(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint m = balanceOf[s].n;
      if(n<=m) {
        updateTotalOutOnInsertTransfer_r20(s,n);
        updateTotalInOnInsertTransfer_r12(r,n);
        emit Transfer(s,r,n);
        return true;
      }
      return false;
  }
  function updateDecreaseAllowanceOnInsertRecv_approve_r14(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance[o][s].n;
      if(n<m) {
        uint d = m-n;
        updateDecreaseTotalOnInsertDecreaseAllowance_r5(o,s,d);
        emit DecreaseAllowance(o,s,d);
        return true;
      }
      return false;
  }
  function updateTotalOutOnInsertTransfer_r20(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalOut_r23(p,delta0);
  }
  function updateDepositOnInsertRecv_deposit_r1() private   returns (bool) {
      uint v = msg.value;
      address p = msg.sender;
      updateMintOnInsertDeposit_r9(p,v);
      emit Deposit(p,v);
      return true;
      return false;
  }
  function updateAllowanceOnIncrementDecreaseTotal_r3(address o,address s,int d) private    {
      int _delta = int(-d);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateTotalBalancesOnInsertConstructor_r27() private    {
      totalBalances = TotalBalancesTuple(0,true);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateTotalSupplyOnIncrementAllMint_r18(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateTotalSupplyOnIncrementAllBurn_r18(int b) private    {
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r26(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r3(o,s,delta0);
  }
  function updateTotalMintOnInsertMint_r17(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalMint_r23(p,delta0);
  }
  function updateTransferOnInsertTransferFrom_r13(address o,address r,address _spender2,uint n) private    {
      updateTotalOutOnInsertTransfer_r20(o,n);
      updateTotalInOnInsertTransfer_r12(r,n);
      emit Transfer(o,r,n);
  }
  function updateTransferFromOnInsertRecv_transferFrom_r10(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint k = allowance[o][s].n;
      uint m = balanceOf[o].n;
      if(o!=s && m>=n && k>=n) {
        updateTransferOnInsertTransferFrom_r13(o,r,s,n);
        return true;
      }
      return false;
  }
  function updateDecreaseTotalOnInsertDecreaseAllowance_r5(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementDecreaseTotal_r3(o,s,delta0);
  }
  function updateAllBurnOnInsertBurn_r11(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllBurn_r18(delta0);
  }
  function updateAllowanceOnIncrementSpentTotal_r3(address o,address s,int l) private    {
      int _delta = int(-l);
      uint newValue = updateuintByint(allowance[o][s].n,_delta);
      allowance[o][s].n = newValue;
  }
  function updateBalanceOfOnIncrementTotalMint_r23(address p,int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateMintOnInsertDeposit_r9(address p,uint n) private    {
      updateTotalMintOnInsertMint_r17(p,n);
      updateAllMintOnInsertMint_r2(n);
  }
  function updateTransferFromOnInsertRecv_transferFrom_r4(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint m = balanceOf[o].n;
      if(o==s && m>=n) {
        updateTransferOnInsertTransferFrom_r13(o,r,s,n);
        return true;
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalBurn_r23(address p,int m) private    {
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTotalInOnInsertTransfer_r12(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalIn_r23(p,delta0);
  }
  function updateBalanceOfOnIncrementTotalIn_r23(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateSendOnInsertWithdraw_r24(address p,uint n) private    {
      payable(p).send(n);
  }
}