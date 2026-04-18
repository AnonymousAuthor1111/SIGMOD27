contract RepToken {
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct DecreaseTotalTuple {
    uint m;
    bool _valid;
  }
  struct AllMintTuple {
    uint n;
    bool _valid;
  }
  struct AllowanceTotalTuple {
    uint m;
    bool _valid;
  }
  struct TargetSupplyTuple {
    uint n;
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
  struct TotalBalancesTuple {
    uint m;
    bool _valid;
  }
  struct PausedTuple {
    bool b;
    bool _valid;
  }
  OwnerTuple owner;
  mapping(address=>mapping(address=>DecreaseTotalTuple)) decreaseTotal;
  AllMintTuple allMint;
  mapping(address=>mapping(address=>AllowanceTotalTuple)) allowanceTotal;
  TotalBalancesTuple totalBalances;
  TargetSupplyTuple targetSupply;
  mapping(address=>mapping(address=>SpentTotalTuple)) spentTotal;
  mapping(address=>BalanceOfTuple) balanceOf;
  PausedTuple paused;
  event TransferOwnership(address newOwner);
  event Pause();
  event DecreaseAllowance(address p,address s,uint n);
  event IncreaseAllowance(address p,address s,uint n);
  event Unpause();
  event MigrateBalance(address holder,uint amount);
  event Transfer(address from,address to,uint amount);
  constructor(address legacy,uint amountFreeze,address freezeAcct,uint target) public {
    updateTargetSupplyOnInsertConstructor_r28(legacy,amountFreeze,freezeAcct,target);
    updateTotalBalancesOnInsertConstructor_r15(legacy,amountFreeze,freezeAcct,target);
    updateOwnerOnInsertConstructor_r27(legacy,amountFreeze,freezeAcct,target);
    updateMintOnInsertConstructor_r6(legacy,amountFreeze,freezeAcct,target);
    updateLegacyRepContractOnInsertConstructor_r29(legacy,amountFreeze,freezeAcct,target);
    updatePausedOnInsertConstructor_r11(legacy,amountFreeze,freezeAcct,target);
  }
  function migrateBalance(address holder,uint legacyBalance) public    {
      bool r16 = updateMigrateBalanceOnInsertRecv_migrateBalance_r16(holder,legacyBalance);
      if(r16==false) {
        revert("Rule condition failed");
      }
  }
  function pause() public    {
      bool r9 = updatePauseOnInsertRecv_pause_r9();
      if(r9==false) {
        revert("Rule condition failed");
      }
  }
  function unpause() public    {
      bool r19 = updateUnpauseOnInsertRecv_unpause_r19();
      if(r19==false) {
        revert("Rule condition failed");
      }
  }
  function getPaused() public view  returns (bool) {
      bool b = paused.b;
      return b;
  }
  function getOwner() public view  returns (address) {
      address p = owner.p;
      return p;
  }
  function transferOwnership(address newOwner) public    {
      bool r23 = updateTransferOwnershipOnInsertRecv_transferOwnership_r23(newOwner);
      if(r23==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      uint n = balanceOf[p].n;
      return n;
  }
  function approve(address s,uint n) public    {
      bool r26 = updateIncreaseAllowanceOnInsertRecv_approve_r26(s,n);
      bool r8 = updateDecreaseAllowanceOnInsertRecv_approve_r8(s,n);
      if(r26==false && r8==false) {
        revert("Rule condition failed");
      }
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r1 = updateTransferFromOnInsertRecv_transferFrom_r1(from,to,amount);
      if(r1==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      uint n = allowance(p,s);
      return n;
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply();
      return n;
  }
  function transfer(address to,uint amount) public    {
      bool r4 = updateTransferOnInsertRecv_transfer_r4(to,amount);
      if(r4==false) {
        revert("Rule condition failed");
      }
  }
  function totalSupply() private view  returns (uint) {
      uint n = allMint.n;
      return n;
  }
  function updateTransferOnInsertTransferFrom_r0(address o,address r,address _spender2,uint n) private    {
      updateTotalInOnInsertTransfer_r30(r,n);
      updateTotalOutOnInsertTransfer_r21(o,n);
      emit Transfer(o,r,n);
  }
  function updateTargetSupplyOnInsertConstructor_r28(address _legacy0,uint _amountFreeze1,address _freezeAcct2,uint t) private    {
      targetSupply = TargetSupplyTuple(t,true);
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r31(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r3(o,s,delta0);
      allowanceTotal[o][s].m += n;
  }
  function updateLegacyRepContractOnInsertConstructor_r29(address l,uint _amountFreeze1,address _freezeAcct2,uint _target3) private    {
      if(l!=address(0)) {
        // Empty()
      }
  }
  function updateMintOnInsertConstructor_r6(address _legacy0,uint n,address f,uint _target3) private    {
      if(n>0) {
        updateTotalMintOnInsertMint_r5(f,n);
        updateAllMintOnInsertMint_r2(n);
      }
  }
  function updateTotalMintOnInsertMint_r5(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalMint_r7(p,delta0);
  }
  function updateTotalInOnInsertTransfer_r30(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalIn_r7(p,delta0);
  }
  function updateTransferFromOnInsertRecv_transferFrom_r1(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      if(false==paused.b) {
        uint m = balanceOf[o].n;
        uint k = allowance(o,s);
        if(m>=n && k>=n) {
          updateTransferOnInsertTransferFrom_r0(o,r,s,n);
          updateSpentTotalOnInsertTransferFrom_r25(o,s,n);
          return true;
        }
      }
      return false;
  }
  function updateDecreaseTotalOnInsertDecreaseAllowance_r10(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementDecreaseTotal_r3(o,s,delta0);
      decreaseTotal[o][s].m += n;
  }
  function updateAllowanceOnIncrementDecreaseTotal_r3(address o,address s,int d) private    {
      // Empty()
  }
  function updatePausedOnInsertPause_r13() private    {
      paused = PausedTuple(true,true);
  }
  function updateAllowanceOnIncrementAllowanceTotal_r3(address o,address s,int m) private    {
      // Empty()
  }
  function updateTransferOnInsertRecv_transfer_r4(address r,uint n) private   returns (bool) {
      if(false==paused.b) {
        address s = msg.sender;
        uint m = balanceOf[s].n;
        if(n<=m) {
          updateTotalInOnInsertTransfer_r30(r,n);
          updateTotalOutOnInsertTransfer_r21(s,n);
          emit Transfer(s,r,n);
          return true;
        }
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalOut_r7(address p,int o) private    {
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateOwnerOnInsertConstructor_r27(address _legacy0,uint _amountFreeze1,address _freezeAcct2,uint _target3) private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateSpentTotalOnInsertTransferFrom_r25(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementSpentTotal_r3(o,s,delta0);
      spentTotal[o][s].m += n;
  }
  function updateDecreaseAllowanceOnInsertRecv_approve_r8(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance(o,s);
      if(n==0 && m>0) {
        uint d = m;
        updateDecreaseTotalOnInsertDecreaseAllowance_r10(o,s,d);
        emit DecreaseAllowance(o,s,d);
        return true;
      }
      return false;
  }
  function updatePausedOnInsertConstructor_r11(address _legacy0,uint _amountFreeze1,address _freezeAcct2,uint _target3) private    {
      paused = PausedTuple(true,true);
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
  function updateMigrateBalanceOnInsertRecv_migrateBalance_r16(address h,uint amt) private   returns (bool) {
      address s = msg.sender;
      uint t = targetSupply.n;
      uint ts = totalSupply();
      if(s==owner.p) {
        if(ts!=t && amt>0) {
          updateMintOnInsertMigrateBalance_r32(h,amt);
          emit MigrateBalance(h,amt);
          return true;
        }
      }
      return false;
  }
  function updateMintOnInsertMigrateBalance_r32(address h,uint amt) private    {
      updateTotalMintOnInsertMint_r5(h,amt);
      updateAllMintOnInsertMint_r2(amt);
  }
  function updateTransferOwnershipOnInsertRecv_transferOwnership_r23(address a) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(a!=address(0)) {
          updateOwnerOnInsertTransferOwnership_r14(a);
          emit TransferOwnership(a);
          return true;
        }
      }
      return false;
  }
  function updateTotalSupplyOnIncrementAllMint_r18(int n) private    {
      // Empty()
  }
  function updateTotalOutOnInsertTransfer_r21(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalOut_r7(p,delta0);
  }
  function updateTotalBalancesOnInsertConstructor_r15(address _legacy0,uint _amountFreeze1,address _freezeAcct2,uint _target3) private    {
      totalBalances = TotalBalancesTuple(0,true);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateUnpauseOnInsertRecv_unpause_r19() private   returns (bool) {
      address s = msg.sender;
      if(true==paused.b) {
        uint t = targetSupply.n;
        uint ts = totalSupply();
        if(s==owner.p) {
          if(ts==t) {
            updatePausedOnInsertUnpause_r17();
            emit Unpause();
            return true;
          }
        }
      }
      return false;
  }
  function updateAllMintOnInsertMint_r2(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllMint_r18(delta0);
      allMint.n += n;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r26(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance(o,s);
      if(n>0 && m==0) {
        uint d = n-m;
        updateAllowanceTotalOnInsertIncreaseAllowance_r31(o,s,d);
        emit IncreaseAllowance(o,s,d);
        return true;
      }
      return false;
  }
  function updateOwnerOnInsertTransferOwnership_r14(address a) private    {
      owner = OwnerTuple(a,true);
  }
  function updatePausedOnInsertUnpause_r17() private    {
      paused = PausedTuple(false,true);
  }
  function updatePauseOnInsertRecv_pause_r9() private   returns (bool) {
      if(false==paused.b) {
        address s = owner.p;
        if(s==msg.sender) {
          updatePausedOnInsertPause_r13();
          emit Pause();
          return true;
        }
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalIn_r7(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateBalanceOfOnIncrementTotalMint_r7(address p,int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
}