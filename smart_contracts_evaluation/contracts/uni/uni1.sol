contract Uni {
  struct TotalInitialTuple {
    uint n;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct DelegateActionCountTuple {
    uint c;
    bool _valid;
  }
  struct TotalInTuple {
    uint n;
    bool _valid;
  }
  struct VotesTuple {
    uint n;
    bool _valid;
  }
  struct TotalOutTuple {
    uint n;
    bool _valid;
  }
  struct DelegatesTuple {
    address d;
    bool _valid;
  }
  mapping(address=>TotalInTuple) totalIn;
  mapping(address=>TotalInitialTuple) totalInitial;
  TotalSupplyTuple totalSupply;
  mapping(address=>DelegatesTuple) delegates;
  mapping(address=>DelegateActionCountTuple) delegateActionCount;
  mapping(address=>VotesTuple) votes;
  mapping(address=>TotalOutTuple) totalOut;
  event DelegateSet(address delegator,address delegatee);
  event Transfer(address from,address to,uint amount);
  constructor(address holder,uint supply) public {
    updateTotalSupplyOnInsertConstructor_r19(supply);
    updateInitialBalanceOnInsertConstructor_r18(holder,supply);
  }
  function delegate(address delegatee) public    {
      bool r1 = updateDelegateSetOnInsertRecv_delegate_r1(delegatee);
      if(r1==false) {
        revert("Rule condition failed");
      }
  }
  function delegateBySig(address delegator,address delegatee) public    {
      bool r15 = updateDelegateSetOnInsertRecv_delegateBySig_r15(delegator,delegatee);
      if(r15==false) {
        revert("Rule condition failed");
      }
  }
  function transfer(address to,uint amount) public    {
      bool r11 = updateTransferOnInsertRecv_transfer_r11(to,amount);
      if(r11==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      uint n = balanceOf(p);
      return n;
  }
  function getVotes(address d) public view  returns (uint) {
      uint n = votes[d].n;
      return n;
  }
  function getDelegates(address p) public view  returns (address) {
      address d = delegates[p].d;
      return d;
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function updateTotalInitialOnInsertInitialBalance_r8(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalInitial_r2(p,delta0);
      totalInitial[p].n += n;
  }
  function updateOutValOnInsertTransfer_r4(address p,uint n) private    {
      updateTotalOutOnInsertOutVal_r20(p,n);
  }
  function updateBalanceOfOnIncrementTotalInitial_r2(address p,int i) private    {
      // Empty()
  }
  function updateTotalInOnInsertInVal_r17(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalIn_r2(p,delta0);
      totalIn[p].n += n;
  }
  function updateOutValOnInsertInitialBalance_r9(address p) private    {
      updateTotalOutOnInsertOutVal_r20(p,uint(0));
  }
  function updateDelegateSetOnInsertRecv_delegate_r1(address d) private   returns (bool) {
      address p = msg.sender;
      if(p!=address(0) && d!=address(0)) {
        updateInitialBalanceOnInsertDelegateSet_r6(p);
        updateInitialBalanceOnInsertDelegateSet_r0(d);
        updateDelegatesOnInsertDelegateSet_r3(p,d);
        emit DelegateSet(p,d);
        return true;
      }
      return false;
  }
  function updateDelegateSetOnInsertRecv_delegateBySig_r15(address p,address d) private   returns (bool) {
      if(p!=address(0) && d!=address(0)) {
        updateInitialBalanceOnInsertDelegateSet_r6(p);
        updateInitialBalanceOnInsertDelegateSet_r0(d);
        updateDelegatesOnInsertDelegateSet_r3(p,d);
        emit DelegateSet(p,d);
        return true;
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalOut_r2(address p,int o) private    {
      // Empty()
  }
  function balanceOf(address p) private view  returns (uint) {
      uint t = totalIn[p].n;
      uint o = totalOut[p].n;
      uint i = totalInitial[p].n;
      uint s = (i+t)-o;
      return s;
  }
  function updateTotalSupplyOnInsertConstructor_r19(uint n) private    {
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateInitialBalanceOnInsertConstructor_r18(address p,uint n) private    {
      updateOutValOnInsertInitialBalance_r9(p);
      updateInValOnInsertInitialBalance_r14(p);
      updateTotalInitialOnInsertInitialBalance_r8(p,n);
  }
  function updateDelegatesOnInsertDelegateSet_r3(address p,address d) private    {
      updateVotesOnInsertDelegates_r7(p,d);
      delegates[p] = DelegatesTuple(d,true);
  }
  function updateTransferOnInsertRecv_transfer_r11(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint m = balanceOf(s);
      if(s!=address(0) && r!=address(0) && n>0 && m>=n) {
        updateInitialBalanceOnInsertTransfer_r16(r);
        updateInValOnInsertTransfer_r13(r,n);
        updateOutValOnInsertTransfer_r4(s,n);
        updateInitialBalanceOnInsertTransfer_r12(s);
        emit Transfer(s,r,n);
        return true;
      }
      return false;
  }
  function updateInitialBalanceOnInsertTransfer_r12(address p) private    {
      updateOutValOnInsertInitialBalance_r9(p);
      updateTotalInitialOnInsertInitialBalance_r8(p,uint(0));
      updateInValOnInsertInitialBalance_r14(p);
  }
  function updateInitialBalanceOnInsertDelegateSet_r6(address p) private    {
      updateOutValOnInsertInitialBalance_r9(p);
      updateTotalInitialOnInsertInitialBalance_r8(p,uint(0));
      updateInValOnInsertInitialBalance_r14(p);
  }
  function updateInValOnInsertTransfer_r13(address p,uint n) private    {
      updateTotalInOnInsertInVal_r17(p,n);
  }
  function updateInitialBalanceOnInsertTransfer_r16(address p) private    {
      updateOutValOnInsertInitialBalance_r9(p);
      updateTotalInitialOnInsertInitialBalance_r8(p,uint(0));
      updateInValOnInsertInitialBalance_r14(p);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateBalanceOfOnIncrementTotalIn_r2(address p,int t) private    {
      // Empty()
  }
  function updateVotesOnInsertDelegates_r7(address _p0,address d) private    {
      DelegatesTuple memory toDelete = delegates[_p0];
      if(toDelete._valid==true) {
        updateVotesOnDeleteDelegates_r7(_p0,toDelete.d);
      }
      votes[d].n += 1;
  }
  function updateTotalOutOnInsertOutVal_r20(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalOut_r2(p,delta0);
      totalOut[p].n += n;
  }
  function updateInitialBalanceOnInsertDelegateSet_r0(address p) private    {
      updateOutValOnInsertInitialBalance_r9(p);
      updateTotalInitialOnInsertInitialBalance_r8(p,uint(0));
      updateInValOnInsertInitialBalance_r14(p);
  }
  function updateInValOnInsertInitialBalance_r14(address p) private    {
      updateTotalInOnInsertInVal_r17(p,uint(0));
  }
  function updateVotesOnDeleteDelegates_r7(address _p0,address d) private    {
      votes[d].n -= 1;
  }
}