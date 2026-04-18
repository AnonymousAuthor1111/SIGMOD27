contract BrickBlockToken {
  struct TotalInTuple {
    uint n;
    bool _valid;
  }
  struct TotalOutTuple {
    uint n;
    bool _valid;
  }
  struct AllowedTuple {
    uint n;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct BurnTotalTuple {
    uint n;
    bool _valid;
  }
  struct PausedTuple {
    bool p;
    bool _valid;
  }
  struct OnceUnpausedTuple {
    bool b;
    bool _valid;
  }
  struct TotalBurnTuple {
    uint n;
    bool _valid;
  }
  struct InitialSupplyTuple {
    uint n;
    bool _valid;
  }
  struct OnceEndSaleTuple {
    bool b;
    bool _valid;
  }
  struct BonusDistributionAddressTuple {
    address p;
    bool _valid;
  }
  struct TokenSaleActiveTuple {
    bool b;
    bool _valid;
  }
  struct FountainContractAddressTuple {
    address p;
    bool _valid;
  }
  struct DeadTuple {
    bool b;
    bool _valid;
  }
  mapping(address=>TotalInTuple) totalIn;
  mapping(address=>TotalOutTuple) totalOut;
  mapping(address=>mapping(address=>AllowedTuple)) allowed;
  mapping(address=>TotalBurnTuple) totalBurn;
  OwnerTuple owner;
  BurnTotalTuple burnTotal;
  InitialSupplyTuple initialSupply;
  PausedTuple paused;
  OnceEndSaleTuple onceEndSale;
  BonusDistributionAddressTuple bonusDistributionAddress;
  TokenSaleActiveTuple tokenSaleActive;
  OnceUnpausedTuple onceUnpaused;
  FountainContractAddressTuple fountainContractAddress;
  DeadTuple dead;
  event Transfer(address from,address to,uint a);
  event ToggleDead(bool b);
  event IncreaseAllowance(address o,address s,uint d);
  event DecreaseAllowance(address o,address s,uint a);
  event TransferBeforeUnpause();
  event Pause();
  event TransferOwnership(address old,address _new);
  event TransferAfterEndSale();
  event Unpause();
  event ChangeFountainContractAddress(address p);
  constructor(address bonusAddr) public {
    updatePausedOnInsertConstructor_r32(bonusAddr);
    updateOwnerOnInsertConstructor_r27(bonusAddr);
    updateDeadOnInsertConstructor_r49(bonusAddr);
    updateOnceEndSaleOnInsertConstructor_r11(bonusAddr);
    updateInitialSupplyOnInsertConstructor_r5(bonusAddr);
    updateTransferOnInsertConstructor_r52(bonusAddr);
    updateOnceUnpausedOnInsertConstructor_r40(bonusAddr);
    updateBonusDistributionAddressOnInsertConstructor_r4(bonusAddr);
    updateTransferOnInsertConstructor_r28(bonusAddr);
    updateTokenSaleActiveOnInsertConstructor_r50(bonusAddr);
  }
  function transferFrom(address from,address to,uint a) public    {
      bool r24 = updateTransferFromOnInsertRecv_transferFrom_r24(from,to,a);
      if(r24==false) {
        revert("Rule condition failed");
      }
  }
  function changeFountainContractAddress(address p) public    {
      bool r31 = updateChangeFountainContractAddressOnInsertRecv_changeFountainContractAddress_r31(p);
      if(r31==false) {
        revert("Rule condition failed");
      }
  }
  function finalizeTokenSale() public    {
      bool r17 = updateFinalizeTokenSaleOnInsertRecv_finalizeTokenSale_r17();
      if(r17==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply();
      return n;
  }
  function transfer(address to,uint a) public    {
      bool r39 = updateTransferOnInsertRecv_transfer_r39(to,a);
      if(r39==false) {
        revert("Rule condition failed");
      }
  }
  function approve(address s,uint n) public    {
      bool r0 = updateIncreaseAllowanceOnInsertRecv_approve_r0(s,n);
      bool r44 = updateDecreaseAllowanceOnInsertRecv_approve_r44(s,n);
      if(r0==false && r44==false) {
        revert("Rule condition failed");
      }
  }
  function transferOwnership(address _new) public    {
      bool r9 = updateTransferOwnershipOnInsertRecv_transferOwnership_r9(_new);
      if(r9==false) {
        revert("Rule condition failed");
      }
  }
  function unpause() public    {
      bool r37 = updateUnpauseOnInsertRecv_unpause_r37();
      if(r37==false) {
        revert("Rule condition failed");
      }
  }
  function increaseApproval(address s,uint a) public    {
      bool r1 = updateIncreaseAllowanceOnInsertRecv_increaseApproval_r1(s,a);
      if(r1==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowed(address p,address s) public view  returns (uint) {
      uint n = allowed[p][s].n;
      return n;
  }
  function distributeTokens(address p,uint v) public    {
      bool r33 = updateDistributeTokensOnInsertRecv_distributeTokens_r33(p,v);
      if(r33==false) {
        revert("Rule condition failed");
      }
  }
  function getBalances(address p) public view  returns (uint) {
      uint n = balances(p);
      return n;
  }
  function pause() public    {
      bool r46 = updatePauseOnInsertRecv_pause_r46();
      if(r46==false) {
        revert("Rule condition failed");
      }
  }
  function toggleDead() public    {
      bool r36 = updateToggleDeadOnInsertRecv_toggleDead_r36();
      bool r25 = updateToggleDeadOnInsertRecv_toggleDead_r25();
      if(r36==false && r25==false) {
        revert("Rule condition failed");
      }
  }
  function decreaseApproval(address s,uint a) public    {
      bool r18 = updateDecreaseAllowanceOnInsertRecv_decreaseApproval_r18(s,a);
      bool r16 = updateDecreaseAllowanceOnInsertRecv_decreaseApproval_r16(s,a);
      if(r18==false && r16==false) {
        revert("Rule condition failed");
      }
  }
  function distributeBonusTokens(address p,uint v) public    {
      bool r8 = updateDistributeBonusTokensOnInsertRecv_distributeBonusTokens_r8(p,v);
      if(r8==false) {
        revert("Rule condition failed");
      }
  }
  function updateSpentTotalOnInsertTransferFrom_r30(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowedOnIncrementSpentTotal_r20(o,s,delta0);
  }
  function updateTransferFromOnInsertRecv_transferFrom_r24(address f,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      if(false==paused.p) {
        uint a = allowed[f][s].n;
        uint m = balances(f);
        if(r!=address(0) && n<=m && n<=a) {
          updateSpentTotalOnInsertTransferFrom_r30(f,s,n);
          updateTransferOnInsertTransferFrom_r45(f,r,s,n);
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
  function updateIncreaseAllowanceOnInsertRecv_increaseApproval_r1(address s,uint n) private   returns (bool) {
      if(false==paused.p) {
        address o = msg.sender;
        updateAllowanceTotalOnInsertIncreaseAllowance_r14(o,s,n);
        emit IncreaseAllowance(o,s,n);
        return true;
      }
      return false;
  }
  function updateInitialSupplyOnInsertConstructor_r5(address _bonusAddr0) private    {
      uint a = 500*1000000;
      initialSupply = InitialSupplyTuple(a,true);
  }
  function updateDistributeBonusTokensOnInsertRecv_distributeBonusTokens_r8(address p,uint n) private   returns (bool) {
      address s = msg.sender;
      address a = bonusDistributionAddress.p;
      if(s==owner.p) {
        uint m = balances(a);
        if(p!=address(0) && p!=s && n<=m) {
          updateTransferOnInsertDistributeBonusTokens_r47(p,n);
          return true;
        }
      }
      return false;
  }
  function updateBalancesOnIncrementTotalOut_r51(address p,int o) private    {
      // Empty()
  }
  function updateFinalizeTokenSaleOnInsertRecv_finalizeTokenSale_r17() private   returns (bool) {
      address s = msg.sender;
      uint c = companyTokens();
      if(true==tokenSaleActive.b) {
        address f = fountainContractAddress.p;
        if(s==owner.p) {
          address t = address(this);
          uint bal = balances(t);
          if(f!=address(0)) {
            uint burnAmt = bal-c;
            updateTokenSaleActiveOnInsertFinalizeTokenSale_r12(burnAmt);
            updateIncreaseAllowanceOnInsertFinalizeTokenSale_r26(burnAmt);
            updateBurnOnInsertFinalizeTokenSale_r23(burnAmt);
            updateOnceEndSaleOnInsertFinalizeTokenSale_r43(burnAmt);
            return true;
          }
        }
      }
      return false;
  }
  function updatePausedOnInsertUnpause_r35() private    {
      paused = PausedTuple(false,true);
  }
  function updateTransferOnInsertRecv_transfer_r39(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      if(false==paused.p) {
        uint m = balances(s);
        if(r!=address(0) && n<=m) {
          updateTotalOutOnInsertTransfer_r13(s,n);
          updateTotalInOnInsertTransfer_r21(r,n);
          emit Transfer(s,r,n);
          return true;
        }
      }
      return false;
  }
  function updateTransferOnInsertConstructor_r52(address a) private    {
      address t = address(this);
      uint b = ((500*1000000)*14)/100;
      updateTotalOutOnInsertTransfer_r13(t,b);
      updateTotalInOnInsertTransfer_r21(a,b);
      emit Transfer(t,a,b);
  }
  function updateOwnerOnInsertConstructor_r27(address _bonusAddr0) private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateDecreaseAllowanceOnInsertRecv_decreaseApproval_r16(address s,uint n) private   returns (bool) {
      if(false==paused.p) {
        address o = msg.sender;
        uint m = allowed[o][s].n;
        if(n>m) {
          updateDecreaseTotalOnInsertDecreaseAllowance_r22(o,s,m);
          emit DecreaseAllowance(o,s,m);
          return true;
        }
      }
      return false;
  }
  function updateTotalInOnInsertTransfer_r21(address p,uint n) private    {
      int delta0 = int(n);
      updateBalancesOnIncrementTotalIn_r51(p,delta0);
      totalIn[p].n += n;
  }
  function updateUnpauseOnInsertRecv_unpause_r37() private   returns (bool) {
      if(true==paused.p) {
        address s = owner.p;
        if(s==msg.sender) {
          updatePausedOnInsertUnpause_r35();
          updateOnceUnpausedOnInsertUnpause_r2();
          emit Unpause();
          return true;
        }
      }
      return false;
  }
  function updateDeadOnInsertConstructor_r49(address _bonusAddr0) private    {
      dead = DeadTuple(false,true);
  }
  function updateBurnTotalOnInsertBurn_r42(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementBurnTotal_r41(delta0);
      burnTotal.n += n;
  }
  function updateTransferOnInsertDistributeBonusTokens_r47(address p,uint n) private    {
      address a = bonusDistributionAddress.p;
      updateTotalOutOnInsertTransfer_r13(a,n);
      updateTotalInOnInsertTransfer_r21(p,n);
      emit Transfer(a,p,n);
  }
  function updateToggleDeadOnInsertRecv_toggleDead_r25() private   returns (bool) {
      if(true==dead.b) {
        address s = owner.p;
        if(s==msg.sender) {
          updateDeadOnInsertToggleDead_r29(bool(false));
          emit ToggleDead(false);
          return true;
        }
      }
      return false;
  }
  function updateBurnOnInsertFinalizeTokenSale_r23(uint n) private    {
      address t = address(this);
      updateTotalBurnOnInsertBurn_r34(t,n);
      updateBurnTotalOnInsertBurn_r42(n);
  }
  function updateDeadOnInsertToggleDead_r29(bool b) private    {
      dead = DeadTuple(b,true);
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r14(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowedOnIncrementAllowanceTotal_r20(o,s,delta0);
  }
  function updateFountainContractAddressOnInsertChangeFountainContractAddress_r10(address a) private    {
      updateIncreaseAllowanceOnInsertFountainContractAddress_r26(a);
      fountainContractAddress = FountainContractAddressTuple(a,true);
  }
  function updateOnceEndSaleOnInsertFinalizeTokenSale_r43(uint _burnAmount0) private    {
      onceEndSale = OnceEndSaleTuple(true,true);
  }
  function updateDecreaseTotalOnInsertDecreaseAllowance_r22(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowedOnIncrementDecreaseTotal_r20(o,s,delta0);
  }
  function updateBalancesOnIncrementTotalIn_r51(address p,int i) private    {
      // Empty()
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r0(address s,uint n) private   returns (bool) {
      if(false==paused.p) {
        address o = msg.sender;
        uint m = allowed[o][s].n;
        if(n>m) {
          uint d = n-m;
          updateAllowanceTotalOnInsertIncreaseAllowance_r14(o,s,d);
          emit IncreaseAllowance(o,s,d);
          return true;
        }
      }
      return false;
  }
  function updateTotalSupplyOnIncrementBurnTotal_r41(int b) private    {
      // Empty()
  }
  function updateOnceUnpausedOnInsertConstructor_r40(address _bonusAddr0) private    {
      onceUnpaused = OnceUnpausedTuple(false,true);
  }
  function updateTransferOnInsertTransferFrom_r45(address f,address r,address _spender2,uint n) private    {
      updateTotalOutOnInsertTransfer_r13(f,n);
      updateTotalInOnInsertTransfer_r21(r,n);
      emit Transfer(f,r,n);
  }
  function updateTokenSaleActiveOnInsertConstructor_r50(address _bonusAddr0) private    {
      tokenSaleActive = TokenSaleActiveTuple(true,true);
  }
  function updateTransferOnInsertDistributeTokens_r3(address p,uint n) private    {
      address t = address(this);
      updateTotalOutOnInsertTransfer_r13(t,n);
      updateTotalInOnInsertTransfer_r21(p,n);
      emit Transfer(t,p,n);
  }
  function totalSupply() private view  returns (uint) {
      uint b = burnTotal.n;
      uint i = initialSupply.n;
      uint n = i-b;
      return n;
  }
  function updateTransferOwnershipOnInsertRecv_transferOwnership_r9(address _new) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(_new!=address(0)) {
          updateOwnerOnInsertTransferOwnership_r7(s,_new);
          emit TransferOwnership(s,_new);
          return true;
        }
      }
      return false;
  }
  function updateBalancesOnIncrementTotalBurn_r51(address p,int b) private    {
      // Empty()
  }
  function updateTransferOnInsertConstructor_r28(address _bonusAddr0) private    {
      address t = address(this);
      uint n = 500*1000000;
      updateTotalInOnInsertTransfer_r21(t,n);
      updateTotalOutOnInsertTransfer_r13(address(0),n);
      emit Transfer(address(0),t,n);
  }
  function updateIncreaseAllowanceOnInsertFountainContractAddress_r26(address f) private    {
      uint c = companyTokens();
      address t = address(this);
      updateAllowanceTotalOnInsertIncreaseAllowance_r14(t,f,c);
      emit IncreaseAllowance(t,f,c);
  }
  function updateOnceEndSaleOnInsertConstructor_r11(address _bonusAddr0) private    {
      onceEndSale = OnceEndSaleTuple(false,true);
  }
  function updateToggleDeadOnInsertRecv_toggleDead_r36() private   returns (bool) {
      if(false==dead.b) {
        address s = owner.p;
        if(s==msg.sender) {
          updateDeadOnInsertToggleDead_r29(bool(true));
          emit ToggleDead(true);
          return true;
        }
      }
      return false;
  }
  function updateDecreaseAllowanceOnInsertRecv_decreaseApproval_r18(address s,uint n) private   returns (bool) {
      if(false==paused.p) {
        address o = msg.sender;
        uint m = allowed[o][s].n;
        if(m>=n) {
          updateDecreaseTotalOnInsertDecreaseAllowance_r22(o,s,n);
          emit DecreaseAllowance(o,s,n);
          return true;
        }
      }
      return false;
  }
  function updateIncreaseAllowanceOnInsertFinalizeTokenSale_r26(uint _burnAmount0) private    {
      uint c = companyTokens();
      address f = fountainContractAddress.p;
      address t = address(this);
      updateAllowanceTotalOnInsertIncreaseAllowance_r14(t,f,c);
      emit IncreaseAllowance(t,f,c);
  }
  function companyTokens() private view  returns (uint) {
      uint s = initialSupply.n;
      uint n = (s*35)/100;
      return n;
  }
  function updateAllowedOnIncrementAllowanceTotal_r20(address o,address s,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(allowed[o][s].n,_delta);
      allowed[o][s].n = newValue;
  }
  function balances(address p) private view  returns (uint) {
      uint b = totalBurn[p].n;
      uint i = totalIn[p].n;
      uint o = totalOut[p].n;
      uint s = (i-o)-b;
      return s;
  }
  function updatePausedOnInsertPause_r15() private    {
      paused = PausedTuple(true,true);
  }
  function updateChangeFountainContractAddressOnInsertRecv_changeFountainContractAddress_r31(address a) private   returns (bool) {
      address t = address(this);
      address s = owner.p;
      if(s==msg.sender) {
        if(a!=t && a!=s) {
          updateFountainContractAddressOnInsertChangeFountainContractAddress_r10(a);
          emit ChangeFountainContractAddress(a);
          return true;
        }
      }
      return false;
  }
  function updatePausedOnInsertConstructor_r32(address _bonusAddr0) private    {
      paused = PausedTuple(true,true);
  }
  function updateAllowedOnIncrementSpentTotal_r20(address o,address s,int l) private    {
      int _delta = int(-l);
      uint newValue = updateuintByint(allowed[o][s].n,_delta);
      allowed[o][s].n = newValue;
  }
  function updateAllowedOnIncrementDecreaseTotal_r20(address o,address s,int d) private    {
      int _delta = int(-d);
      uint newValue = updateuintByint(allowed[o][s].n,_delta);
      allowed[o][s].n = newValue;
  }
  function updateBonusDistributionAddressOnInsertConstructor_r4(address a) private    {
      if(a!=address(0)) {
        bonusDistributionAddress = BonusDistributionAddressTuple(a,true);
      }
  }
  function updateOnceUnpausedOnInsertUnpause_r2() private    {
      onceUnpaused = OnceUnpausedTuple(true,true);
  }
  function updateOwnerOnInsertTransferOwnership_r7(address _old0,address _new) private    {
      owner = OwnerTuple(_new,true);
  }
  function updateTotalBurnOnInsertBurn_r34(address p,uint n) private    {
      int delta0 = int(n);
      updateBalancesOnIncrementTotalBurn_r51(p,delta0);
      totalBurn[p].n += n;
  }
  function updatePauseOnInsertRecv_pause_r46() private   returns (bool) {
      if(false==paused.p) {
        address s = owner.p;
        if(s==msg.sender) {
          updatePausedOnInsertPause_r15();
          emit Pause();
          return true;
        }
      }
      return false;
  }
  function updateDecreaseAllowanceOnInsertRecv_approve_r44(address s,uint n) private   returns (bool) {
      if(false==paused.p) {
        address o = msg.sender;
        uint m = allowed[o][s].n;
        if(n<m) {
          uint d = m-n;
          updateDecreaseTotalOnInsertDecreaseAllowance_r22(o,s,d);
          emit DecreaseAllowance(o,s,d);
          return true;
        }
      }
      return false;
  }
  function updateTokenSaleActiveOnInsertFinalizeTokenSale_r12(uint _burnAmount0) private    {
      tokenSaleActive = TokenSaleActiveTuple(false,true);
  }
  function updateTotalOutOnInsertTransfer_r13(address p,uint n) private    {
      int delta0 = int(n);
      updateBalancesOnIncrementTotalOut_r51(p,delta0);
      totalOut[p].n += n;
  }
  function updateDistributeTokensOnInsertRecv_distributeTokens_r33(address p,uint n) private   returns (bool) {
      if(true==tokenSaleActive.b) {
        address s = owner.p;
        if(s==msg.sender) {
          if(p!=address(0) && p!=s) {
            updateTransferOnInsertDistributeTokens_r3(p,n);
            return true;
          }
        }
      }
      return false;
  }
}