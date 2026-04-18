contract Uni {
  struct InValTuple {
    address p;
    uint n;
    bool _valid;
  }
  struct TotalInitialTuple {
    uint n;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct InitialBalanceTuple {
    address p;
    uint n;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  struct TotalInTuple {
    uint n;
    bool _valid;
  }
  struct OutValTuple {
    address p;
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
  InValTuple inVal;
  mapping(address=>TotalInitialTuple) totalInitial;
  TotalSupplyTuple totalSupply;
  mapping(address=>DelegatesTuple) delegates;
  InitialBalanceTuple initialBalance;
  mapping(address=>BalanceOfTuple) balanceOf;
  mapping(address=>TotalInTuple) totalIn;
  OutValTuple outVal;
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
  function getBalanceOf(address p) public view  returns (uint) {
      uint n = balanceOf[p].n;
      return n;
  }
  function transfer(address to,uint amount) public    {
      bool r11 = updateTransferOnInsertRecv_transfer_r11(to,amount);
      if(r11==false) {
        revert("Rule condition failed");
      }
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
  function updateTotalInOnInsertInVal_r17(address p,uint n) private    {
      int delta1 = int(n);
      updateBalanceOfOnIncrementTotalIn_r2(p,delta1);
      totalIn[p].n += n;
  }
  function updateDelegatesOnInsertDelegateSet_r3(address p,address d) private    {
      updateVotesOnInsertDelegates_r7(p,d);
      delegates[p] = DelegatesTuple(d,true);
  }
  function updateInValOnInsertInitialBalance_r14(address p) private    {
      updateTotalInOnInsertInVal_r17(p,uint(0));
      inVal = InValTuple(p,0,true);
  }
  function updateInitialBalanceOnInsertTransfer_r16(address p) private    {
      updateOutValOnInsertInitialBalance_r9(p);
      updateTotalInitialOnInsertInitialBalance_r8(p,uint(0));
      updateInValOnInsertInitialBalance_r14(p);
      initialBalance = InitialBalanceTuple(p,0,true);
  }
  function updateTransferOnInsertRecv_transfer_r11(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint m = balanceOf[s].n;
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
  function updateTotalOutOnInsertOutVal_r20(address p,uint n) private    {
      int delta2 = int(n);
      updateBalanceOfOnIncrementTotalOut_r2(p,delta2);
      totalOut[p].n += n;
  }
  function updateBalanceOfOnInsertTotalInitial_r2(address p,uint i) private    {
      TotalInitialTuple memory toDelete = totalInitial[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalInitial_r2(p,toDelete.n);
      }
      uint t = totalIn[p].n;
      uint o = totalOut[p].n;
      uint s = (i+t)-o;
      balanceOf[p] = BalanceOfTuple(s,true);
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
  function updateTotalInitialOnInsertInitialBalance_r8(address p,uint n) private    {
      int delta1 = int(n);
      updateBalanceOfOnIncrementTotalInitial_r2(p,delta1);
      totalInitial[p].n += n;
  }
  function updateVotesOnDeleteDelegates_r7(address _p0,address d) private    {
      votes[d].n -= 1;
  }
  function updateBalanceOfOnInsertTotalIn_r2(address p,uint t) private    {
      TotalInTuple memory toDelete = totalIn[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalIn_r2(p,toDelete.n);
      }
      uint o = totalOut[p].n;
      uint i = totalInitial[p].n;
      uint s = (i+t)-o;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateBalanceOfOnDeleteTotalInitial_r2(address p,uint i) private    {
      uint t = totalIn[p].n;
      uint o = totalOut[p].n;
      uint s = (i+t)-o;
      if(s==balanceOf[p].n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateInValOnInsertTransfer_r13(address p,uint n) private    {
      updateTotalInOnInsertInVal_r17(p,n);
      inVal = InValTuple(p,n,true);
  }
  function updateInitialBalanceOnInsertTransfer_r12(address p) private    {
      updateOutValOnInsertInitialBalance_r9(p);
      updateTotalInitialOnInsertInitialBalance_r8(p,uint(0));
      updateInValOnInsertInitialBalance_r14(p);
      initialBalance = InitialBalanceTuple(p,0,true);
  }
  function updateInitialBalanceOnInsertDelegateSet_r6(address p) private    {
      updateOutValOnInsertInitialBalance_r9(p);
      updateTotalInitialOnInsertInitialBalance_r8(p,uint(0));
      updateInValOnInsertInitialBalance_r14(p);
      initialBalance = InitialBalanceTuple(p,0,true);
  }
  function updateBalanceOfOnIncrementTotalInitial_r2(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(totalInitial[p].n,_delta);
      updateBalanceOfOnInsertTotalInitial_r2(p,newValue);
  }
  function updateTotalSupplyOnInsertConstructor_r19(uint n) private    {
      totalSupply = TotalSupplyTuple(n,true);
  }
  function updateInitialBalanceOnInsertDelegateSet_r0(address p) private    {
      updateOutValOnInsertInitialBalance_r9(p);
      updateTotalInitialOnInsertInitialBalance_r8(p,uint(0));
      updateInValOnInsertInitialBalance_r14(p);
      initialBalance = InitialBalanceTuple(p,0,true);
  }
  function updateBalanceOfOnDeleteTotalIn_r2(address p,uint t) private    {
      uint o = totalOut[p].n;
      uint i = totalInitial[p].n;
      uint s = (i+t)-o;
      if(s==balanceOf[p].n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateBalanceOfOnDeleteTotalOut_r2(address p,uint o) private    {
      uint t = totalIn[p].n;
      uint i = totalInitial[p].n;
      uint s = (i+t)-o;
      if(s==balanceOf[p].n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateBalanceOfOnInsertTotalOut_r2(address p,uint o) private    {
      TotalOutTuple memory toDelete = totalOut[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalOut_r2(p,toDelete.n);
      }
      uint t = totalIn[p].n;
      uint i = totalInitial[p].n;
      uint s = (i+t)-o;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateBalanceOfOnIncrementTotalOut_r2(address p,int o) private    {
      int _delta = int(o);
      uint newValue = updateuintByint(totalOut[p].n,_delta);
      updateBalanceOfOnInsertTotalOut_r2(p,newValue);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateVotesOnInsertDelegates_r7(address _p0,address d) private    {
      DelegatesTuple memory toDelete = delegates[_p0];
      if(toDelete._valid==true) {
        updateVotesOnDeleteDelegates_r7(_p0,toDelete.d);
      }
      votes[d].n += 1;
  }
  function updateBalanceOfOnIncrementTotalIn_r2(address p,int t) private    {
      int _delta = int(t);
      uint newValue = updateuintByint(totalIn[p].n,_delta);
      updateBalanceOfOnInsertTotalIn_r2(p,newValue);
  }
  function updateInitialBalanceOnInsertConstructor_r18(address p,uint n) private    {
      updateOutValOnInsertInitialBalance_r9(p);
      updateInValOnInsertInitialBalance_r14(p);
      updateTotalInitialOnInsertInitialBalance_r8(p,n);
      initialBalance = InitialBalanceTuple(p,n,true);
  }
  function updateOutValOnInsertTransfer_r4(address p,uint n) private    {
      updateTotalOutOnInsertOutVal_r20(p,n);
      outVal = OutValTuple(p,n,true);
  }
  function updateOutValOnInsertInitialBalance_r9(address p) private    {
      updateTotalOutOnInsertOutVal_r20(p,uint(0));
      outVal = OutValTuple(p,0,true);
  }
}