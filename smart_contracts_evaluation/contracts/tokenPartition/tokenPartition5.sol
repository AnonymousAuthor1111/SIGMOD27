contract TokenPartition {
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct TotalBurnTuple {
    uint n;
    bool _valid;
  }
  struct IssueTotalByPartitionTuple {
    uint n;
    bool _valid;
  }
  struct TotalSupplyTuple {
    uint n;
    bool _valid;
  }
  struct TotalBalancesByPartitionTuple {
    uint m;
    bool _valid;
  }
  struct TotalInTuple {
    uint n;
    bool _valid;
  }
  struct TotalMintTuple {
    uint n;
    bool _valid;
  }
  struct RedeemTotalByPartitionTuple {
    uint n;
    bool _valid;
  }
  struct TotalOutTuple {
    uint n;
    bool _valid;
  }
  mapping(address=>mapping(uint=>TotalOutTuple)) totalOut;
  OwnerTuple owner;
  mapping(address=>mapping(uint=>TotalBurnTuple)) totalBurn;
  mapping(uint=>IssueTotalByPartitionTuple) issueTotalByPartition;
  TotalSupplyTuple totalSupply;
  mapping(uint=>TotalBalancesByPartitionTuple) totalBalancesByPartition;
  mapping(address=>mapping(uint=>TotalInTuple)) totalIn;
  mapping(address=>mapping(uint=>TotalMintTuple)) totalMint;
  mapping(uint=>RedeemTotalByPartitionTuple) redeemTotalByPartition;
  event TransferByPartition(address from,address to,uint q,uint amount);
  event IssueByPartition(address p,uint q,uint amount);
  event RedeemByPartition(address p,uint q,uint amount);
  constructor() public {
    updateTotalSupplyOnInsertConstructor_r3();
    updateOwnerOnInsertConstructor_r12();
  }
  function redeemByPartition(address p,uint q,uint amount) public    {
      bool r10 = updateRedeemByPartitionOnInsertRecv_redeemByPartition_r10(p,q,amount);
      if(r10==false) {
        revert("Rule condition failed");
      }
  }
  function issueByPartition(address p,uint q,uint amount) public    {
      bool r1 = updateIssueByPartitionOnInsertRecv_issueByPartition_r1(p,q,amount);
      if(r1==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply.n;
      return n;
  }
  function getBalanceOfByPartition(address p,uint q) public view  returns (uint) {
      uint n = balanceOfByPartition(p,q);
      return n;
  }
  function getTotalSupplyByPartition(uint q) public view  returns (uint) {
      uint n = totalSupplyByPartition(q);
      return n;
  }
  function transferByPartition(address from,address to,uint q,uint amount) public    {
      bool r9 = updateTransferByPartitionOnInsertRecv_transferByPartition_r9(from,to,q,amount);
      if(r9==false) {
        revert("Rule condition failed");
      }
  }
  function updateBalanceOfByPartitionOnIncrementTotalOut_r14(address p,uint q,int o) private    {
      // Empty()
  }
  function updateRedeemTotalByPartitionOnInsertRedeemByPartition_r15(uint q,uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyByPartitionOnIncrementRedeemTotalByPartition_r4(q,delta0);
      redeemTotalByPartition[q].n += n;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateTotalInOnInsertTransferByPartition_r17(address p,uint q,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfByPartitionOnIncrementTotalIn_r14(p,q,delta0);
      totalIn[p][q].n += n;
  }
  function updateTotalSupplyOnInsertConstructor_r3() private    {
      totalSupply = TotalSupplyTuple(0,true);
  }
  function updateTotalBurnOnInsertRedeemByPartition_r16(address p,uint q,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfByPartitionOnIncrementTotalBurn_r14(p,q,delta0);
      totalBurn[p][q].n += n;
  }
  function updateRedeemByPartitionOnInsertRecv_redeemByPartition_r10(address p,uint q,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        uint m = balanceOfByPartition(p,q);
        if(p!=address(0) && n<=m) {
          updateAllBurnOnInsertRedeemByPartition_r11(n);
          updateTotalBurnOnInsertRedeemByPartition_r16(p,q,n);
          updateRedeemTotalByPartitionOnInsertRedeemByPartition_r15(q,n);
          emit RedeemByPartition(p,q,n);
          return true;
        }
      }
      return false;
  }
  function updateTotalOutOnInsertTransferByPartition_r6(address p,uint q,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfByPartitionOnIncrementTotalOut_r14(p,q,delta0);
      totalOut[p][q].n += n;
  }
  function updateTotalSupplyOnIncrementAllMint_r7(int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateBalanceOfByPartitionOnIncrementTotalBurn_r14(address p,uint q,int m) private    {
      // Empty()
  }
  function updateTransferByPartitionOnInsertRecv_transferByPartition_r9(address s,address r,uint q,uint n) private   returns (bool) {
      uint m = balanceOfByPartition(s,q);
      if(n<=m) {
        updateTotalInOnInsertTransferByPartition_r17(r,q,n);
        updateTotalOutOnInsertTransferByPartition_r6(s,q,n);
        emit TransferByPartition(s,r,q,n);
        return true;
      }
      return false;
  }
  function updateBalanceOfByPartitionOnIncrementTotalIn_r14(address p,uint q,int i) private    {
      // Empty()
  }
  function totalSupplyByPartition(uint q) private view  returns (uint) {
      uint r = redeemTotalByPartition[q].n;
      uint i = issueTotalByPartition[q].n;
      uint n = i-r;
      return n;
  }
  function updateTotalSupplyOnIncrementAllBurn_r7(int b) private    {
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupply.n,_delta);
      totalSupply.n = newValue;
  }
  function updateIssueTotalByPartitionOnInsertIssueByPartition_r5(uint q,uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyByPartitionOnIncrementIssueTotalByPartition_r4(q,delta0);
      issueTotalByPartition[q].n += n;
  }
  function updateAllBurnOnInsertRedeemByPartition_r11(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllBurn_r7(delta0);
  }
  function updateBalanceOfByPartitionOnIncrementTotalMint_r14(address p,uint q,int n) private    {
      // Empty()
  }
  function updateTotalSupplyByPartitionOnIncrementIssueTotalByPartition_r4(uint q,int i) private    {
      // Empty()
  }
  function updateAllMintOnInsertIssueByPartition_r0(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllMint_r7(delta0);
  }
  function updateIssueByPartitionOnInsertRecv_issueByPartition_r1(address p,uint q,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(p!=address(0)) {
          updateIssueTotalByPartitionOnInsertIssueByPartition_r5(q,n);
          updateTotalMintOnInsertIssueByPartition_r8(p,q,n);
          updateAllMintOnInsertIssueByPartition_r0(n);
          emit IssueByPartition(p,q,n);
          return true;
        }
      }
      return false;
  }
  function updateTotalSupplyByPartitionOnIncrementRedeemTotalByPartition_r4(uint q,int r) private    {
      // Empty()
  }
  function updateOwnerOnInsertConstructor_r12() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function balanceOfByPartition(address p,uint q) private view  returns (uint) {
      uint i = totalIn[p][q].n;
      uint o = totalOut[p][q].n;
      uint m = totalBurn[p][q].n;
      uint n = totalMint[p][q].n;
      uint s = ((n+i)-m)-o;
      return s;
  }
  function updateTotalMintOnInsertIssueByPartition_r8(address p,uint q,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfByPartitionOnIncrementTotalMint_r14(p,q,delta0);
      totalMint[p][q].n += n;
  }
}