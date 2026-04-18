contract CrowFunding {
  struct TargetTuple {
    uint t;
    bool _valid;
  }
  struct RaisedTuple {
    uint n;
    bool _valid;
  }
  struct ClosedTuple {
    bool b;
    bool _valid;
  }
  struct CloseTimeTuple {
    uint t;
    bool _valid;
  }
  struct TotalBalanceTuple {
    uint m;
    bool _valid;
  }
  struct BeneficiaryTuple {
    address p;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  RaisedTuple raised;
  ClosedTuple closed;
  CloseTimeTuple closeTime;
  BeneficiaryTuple beneficiary;
  TotalBalanceTuple totalBalance;
  mapping(address=>BalanceOfTuple) balanceOf;
  TargetTuple target;
  event Refund(address p,uint n);
  event Close();
  event Invest(address p,uint n);
  event Withdraw(address p,uint n);
  constructor(uint t,address b,uint ct) public {
    updateTargetOnInsertConstructor_r11(t,b,ct);
    updateTotalBalanceOnInsertConstructor_r2(t,b,ct);
    updateRaisedOnInsertConstructor_r5(t,b,ct);
    updateOwnerOnInsertConstructor_r16(t,b,ct);
    updateCloseTimeOnInsertConstructor_r14(t,b,ct);
    updateClosedOnInsertConstructor_r15(t,b,ct);
    updateBeneficiaryOnInsertConstructor_r9(t,b,ct);
  }
  function getClosed() public view  returns (bool) {
      bool b = closed.b;
      return b;
  }
  function getRaised() public view  returns (uint) {
      uint n = raised.n;
      return n;
  }
  function withdraw() public    {
      bool r13 = updateWithdrawOnInsertRecv_withdraw_r13();
      if(r13==false) {
        revert("Rule condition failed");
      }
  }
  function close() public    {
      bool r10 = updateCloseOnInsertRecv_close_r10();
      bool r17 = updateCloseOnInsertRecv_close_r17();
      if(r10==false && r17==false) {
        revert("Rule condition failed");
      }
  }
  function refund(address p) public    {
      bool r12 = updateRefundOnInsertRecv_refund_r12(p);
      if(r12==false) {
        revert("Rule condition failed");
      }
  }
  function invest() public  payable  {
      bool r4 = updateInvestOnInsertRecv_invest_r4();
      if(r4==false) {
        revert("Rule condition failed");
      }
  }
  function updateInvestOnInsertRecv_invest_r4() private   returns (bool) {
      address p = msg.sender;
      uint t = block.timestamp;
      if(false==closed.b) {
        uint s = raised.n;
        uint ct = closeTime.t;
        uint g = target.t;
        uint n = msg.value;
        if(n>0 && t<=ct && s<g) {
          updateRaisedOnInsertInvest_r18(n);
          updateInvestTotalOnInsertInvest_r8(p,n);
          emit Invest(p,n);
          return true;
        }
      }
      return false;
  }
  function updateTotalBalanceOnInsertConstructor_r2(uint _t0,address _b1,uint _ct2) private    {
      totalBalance = TotalBalanceTuple(0,true);
  }
  function updateCloseOnInsertRecv_close_r17() private   returns (bool) {
      uint ct = closeTime.t;
      uint t = block.timestamp;
      if(false==closed.b) {
        if(t>ct) {
          updateClosedOnInsertClose_r0();
          emit Close();
          return true;
        }
      }
      return false;
  }
  function updateSendOnInsertWithdraw_r3(address p,uint n) private    {
      payable(p).send(n);
  }
  function updateClosedOnInsertConstructor_r15(uint _t0,address _b1,uint _ct2) private    {
      closed = ClosedTuple(false,true);
  }
  function updateSendOnInsertRefund_r1(address p,uint n) private    {
      payable(p).send(n);
  }
  function updateCloseTimeOnInsertConstructor_r14(uint _t0,address _b1,uint ct) private    {
      closeTime = CloseTimeTuple(ct,true);
  }
  function updateInvestTotalOnInsertInvest_r8(address p,uint m) private    {
      int delta0 = int(m);
      updateBalanceOfOnIncrementInvestTotal_r6(p,delta0);
  }
  function updateWithdrawOnInsertRecv_withdraw_r13() private   returns (bool) {
      address b = beneficiary.p;
      uint g = target.t;
      uint r = raised.n;
      uint n = address(this).balance;
      if(true==closed.b) {
        if(r>=g && n>0) {
          updateSendOnInsertWithdraw_r3(b,n);
          emit Withdraw(b,n);
          return true;
        }
      }
      return false;
  }
  function updateRefundTotalOnInsertRefund_r19(address p,uint m) private    {
      int delta0 = int(m);
      updateBalanceOfOnIncrementRefundTotal_r6(p,delta0);
  }
  function updateRaisedOnInsertConstructor_r5(uint _t0,address _b1,uint _ct2) private    {
      raised = RaisedTuple(0,true);
  }
  function updateRaisedOnInsertInvest_r18(uint m) private    {
      raised.n += m;
  }
  function updateBalanceOfOnIncrementRefundTotal_r6(address p,int r) private    {
      int _delta = int(-r);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTargetOnInsertConstructor_r11(uint t,address _b1,uint _ct2) private    {
      target = TargetTuple(t,true);
  }
  function updateCloseOnInsertRecv_close_r10() private   returns (bool) {
      uint g = target.t;
      uint r = raised.n;
      if(false==closed.b) {
        if(r>=g) {
          updateClosedOnInsertClose_r0();
          emit Close();
          return true;
        }
      }
      return false;
  }
  function updateClosedOnInsertClose_r0() private    {
      closed = ClosedTuple(true,true);
  }
  function updateBalanceOfOnIncrementInvestTotal_r6(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateBeneficiaryOnInsertConstructor_r9(uint _t0,address p,uint _ct2) private    {
      beneficiary = BeneficiaryTuple(p,true);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateRefundOnInsertRecv_refund_r12(address p) private   returns (bool) {
      uint g = target.t;
      uint r = raised.n;
      if(true==closed.b) {
        uint n = balanceOf[p].n;
        if(r<g && n>0) {
          updateRefundTotalOnInsertRefund_r19(p,n);
          updateSendOnInsertRefund_r1(p,n);
          emit Refund(p,n);
          return true;
        }
      }
      return false;
  }
  function updateOwnerOnInsertConstructor_r16(uint _t0,address _b1,uint _ct2) private    {
      address p = msg.sender;
      // Empty()
  }
}