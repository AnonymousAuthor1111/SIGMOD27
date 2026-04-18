contract PaymentSplitter {
  struct TotalReleasedTuple {
    uint n;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct SharesTuple {
    uint n;
    bool _valid;
  }
  struct ReleasedTuple {
    uint n;
    bool _valid;
  }
  struct SetupPhaseTuple {
    bool b;
    bool _valid;
  }
  struct TotalSharesTuple {
    uint n;
    bool _valid;
  }
  TotalReleasedTuple totalReleased;
  OwnerTuple owner;
  mapping(address=>SharesTuple) shares;
  mapping(address=>ReleasedTuple) released;
  SetupPhaseTuple setupPhase;
  TotalSharesTuple totalShares;
  event Release(address p,uint n);
  event AddAfterSetup();
  event AddPayee(address p,uint n);
  event FinalizeSetup();
  constructor() public {
    updateOwnerOnInsertConstructor_r8();
    updateSetupPhaseOnInsertConstructor_r1();
    updateTotalSharesOnInsertConstructor_r6();
    updateTotalReleasedOnInsertConstructor_r14();
  }
  function getTotalShares() public view  returns (uint) {
      uint n = totalShares.n;
      return n;
  }
  function getReleased(address p) public view  returns (uint) {
      uint n = released[p].n;
      return n;
  }
  function getTotalReleased() public view  returns (uint) {
      uint n = totalReleased.n;
      return n;
  }
  function addPayee(address p,uint n) public    {
      bool r4 = updateAddPayeeOnInsertRecv_addPayee_r4(p,n);
      if(r4==false) {
        revert("Rule condition failed");
      }
  }
  function release(address p) public    {
      bool r16 = updateReleaseOnInsertRecv_release_r16(p);
      if(r16==false) {
        revert("Rule condition failed");
      }
  }
  function getShares(address p) public view  returns (uint) {
      uint n = shares[p].n;
      return n;
  }
  function finalizeSetup() public    {
      bool r10 = updateFinalizeSetupOnInsertRecv_finalizeSetup_r10();
      if(r10==false) {
        revert("Rule condition failed");
      }
  }
  function updateTotalReleasedOnInsertRelease_r12(uint n) private    {
      totalReleased.n += n;
  }
  function updateOwnerOnInsertConstructor_r8() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateSetupPhaseOnInsertFinalizeSetup_r0() private    {
      setupPhase = SetupPhaseTuple(false,true);
  }
  function updateTotalReleaseOfOnInsertRelease_r15(address p,uint n) private    {
      int delta0 = int(n);
      updateReleasedOnIncrementTotalReleaseOf_r7(p,delta0);
  }
  function updateTotalSharesOnInsertAddPayee_r9(uint n) private    {
      totalShares.n += n;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateSharesOnInsertAddPayee_r13(address p,uint n) private    {
      shares[p].n += n;
  }
  function updateSendOnInsertRelease_r5(address p,uint n) private    {
      payable(p).send(n);
  }
  function updateReleasedOnInsertAddPayee_r3(address p,uint _n1) private    {
      released[p] = ReleasedTuple(0,true);
  }
  function updateSetupPhaseOnInsertConstructor_r1() private    {
      setupPhase = SetupPhaseTuple(true,true);
  }
  function updateAddPayeeOnInsertRecv_addPayee_r4(address p,uint n) private   returns (bool) {
      address s = msg.sender;
      if(true==setupPhase.b) {
        if(s==owner.p) {
          uint m = shares[p].n;
          if(p!=address(0) && n>0 && m==0) {
            updateSharesOnInsertAddPayee_r13(p,n);
            updateTotalSharesOnInsertAddPayee_r9(n);
            updateReleasedOnInsertAddPayee_r3(p,n);
            emit AddPayee(p,n);
            return true;
          }
        }
      }
      return false;
  }
  function updateReleaseOnInsertRecv_release_r16(address p) private   returns (bool) {
      uint ts = totalShares.n;
      uint b = address(this).balance;
      uint tr = totalReleased.n;
      if(false==setupPhase.b) {
        uint rel = released[p].n;
        uint sh = shares[p].n;
        uint n = (((b+tr)*sh)/ts)-rel;
        if(sh>0 && n>=0) {
          updateSendOnInsertRelease_r5(p,n);
          updateTotalReleaseOfOnInsertRelease_r15(p,n);
          updateTotalReleasedOnInsertRelease_r12(n);
          emit Release(p,n);
          return true;
        }
      }
      return false;
  }
  function updateFinalizeSetupOnInsertRecv_finalizeSetup_r10() private   returns (bool) {
      address s = msg.sender;
      uint ts = totalShares.n;
      if(true==setupPhase.b) {
        if(s==owner.p) {
          if(ts>0) {
            updateSetupPhaseOnInsertFinalizeSetup_r0();
            emit FinalizeSetup();
            return true;
          }
        }
      }
      return false;
  }
  function updateTotalSharesOnInsertConstructor_r6() private    {
      totalShares = TotalSharesTuple(0,true);
  }
  function updateReleasedOnIncrementTotalReleaseOf_r7(address p,int s) private    {
      int _delta = int(s);
      uint newValue = updateuintByint(released[p].n,_delta);
      released[p].n = newValue;
  }
  function updateTotalReleasedOnInsertConstructor_r14() private    {
      totalReleased = TotalReleasedTuple(0,true);
  }
}