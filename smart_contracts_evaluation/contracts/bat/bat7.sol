contract Bat {
  struct FundingEndBlockTuple {
    uint n;
    bool _valid;
  }
  struct IsFinalizedTuple {
    bool b;
    bool _valid;
  }
  struct DecreaseTotalTuple {
    uint m;
    bool _valid;
  }
  struct BatFundAmtTuple {
    uint n;
    bool _valid;
  }
  struct AllowanceTotalTuple {
    uint m;
    bool _valid;
  }
  struct BatFundDepositTuple {
    address p;
    bool _valid;
  }
  struct TokenExchangeRateTuple {
    uint r;
    bool _valid;
  }
  struct TotalEthRaisedTuple {
    uint n;
    bool _valid;
  }
  struct FundingStartBlockTuple {
    uint n;
    bool _valid;
  }
  struct AllMintTuple {
    uint n;
    bool _valid;
  }
  struct EthFundDepositTuple {
    address p;
    bool _valid;
  }
  struct TotalBalancesTuple {
    uint m;
    bool _valid;
  }
  struct TokenCreationCapTuple {
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
  struct AllBurnTuple {
    uint n;
    bool _valid;
  }
  struct TokenCreationMinTuple {
    uint n;
    bool _valid;
  }
  FundingEndBlockTuple fundingEndBlock;
  IsFinalizedTuple isFinalized;
  mapping(address=>mapping(address=>DecreaseTotalTuple)) decreaseTotal;
  BatFundAmtTuple batFundAmt;
  AllMintTuple allMint;
  mapping(address=>mapping(address=>AllowanceTotalTuple)) allowanceTotal;
  EthFundDepositTuple ethFundDeposit;
  BatFundDepositTuple batFundDeposit;
  mapping(address=>mapping(address=>SpentTotalTuple)) spentTotal;
  TokenCreationMinTuple tokenCreationMin;
  TokenExchangeRateTuple tokenExchangeRate;
  TotalEthRaisedTuple totalEthRaised;
  FundingStartBlockTuple fundingStartBlock;
  TotalBalancesTuple totalBalances;
  TokenCreationCapTuple tokenCreationCap;
  mapping(address=>BalanceOfTuple) balanceOf;
  AllBurnTuple allBurn;
  event Finalize();
  event Refund(address p,uint batVal);
  event CreateTokens(address p,uint ethAmt);
  event DecreaseAllowance(address p,address s,uint n);
  event IncreaseAllowance(address p,address s,uint n);
  event Transfer(address from,address to,uint amount);
  constructor(address ethFund,address batFund,uint startBlock,uint endBlock) public {
    updateBatFundDepositOnInsertConstructor_r13(ethFund,batFund,startBlock,endBlock);
    updateTokenCreationCapOnInsertConstructor_r7(ethFund,batFund,startBlock,endBlock);
    updateFundingStartBlockOnInsertConstructor_r2(ethFund,batFund,startBlock,endBlock);
    updateMintOnInsertConstructor_r38(ethFund,batFund,startBlock,endBlock);
    updateTokenCreationMinOnInsertConstructor_r17(ethFund,batFund,startBlock,endBlock);
    updateIsFinalizedOnInsertConstructor_r32(ethFund,batFund,startBlock,endBlock);
    updateTokenExchangeRateOnInsertConstructor_r5(ethFund,batFund,startBlock,endBlock);
    updateTotalBalancesOnInsertConstructor_r29(ethFund,batFund,startBlock,endBlock);
    updateTotalEthRaisedOnInsertConstructor_r34(ethFund,batFund,startBlock,endBlock);
    updateBatFundAmtOnInsertConstructor_r27(ethFund,batFund,startBlock,endBlock);
    updateEthFundDepositOnInsertConstructor_r39(ethFund,batFund,startBlock,endBlock);
    updateFundingEndBlockOnInsertConstructor_r40(ethFund,batFund,startBlock,endBlock);
  }
  function transfer(address to,uint amount) public    {
      bool r18 = updateTransferOnInsertRecv_transfer_r18(to,amount);
      if(r18==false) {
        revert("Rule condition failed");
      }
  }
  function refund() public    {
      bool r24 = updateRefundOnInsertRecv_refund_r24();
      if(r24==false) {
        revert("Rule condition failed");
      }
  }
  function finalize() public    {
      bool r25 = updateFinalizeOnInsertRecv_finalize_r25();
      if(r25==false) {
        revert("Rule condition failed");
      }
  }
  function approve(address s,uint n) public    {
      bool r14 = updateIncreaseAllowanceOnInsertRecv_approve_r14(s,n);
      bool r11 = updateDecreaseAllowanceOnInsertRecv_approve_r11(s,n);
      if(r14==false && r11==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      uint n = balanceOf[p].n;
      return n;
  }
  function getAllowance(address p,address s) public view  returns (uint) {
      uint n = allowance(p,s);
      return n;
  }
  function transferFrom(address from,address to,uint amount) public    {
      bool r19 = updateTransferFromOnInsertRecv_transferFrom_r19(from,to,amount);
      if(r19==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupply() public view  returns (uint) {
      uint n = totalSupply();
      return n;
  }
  function createTokens() public  payable  {
      bool r12 = updateCreateTokensOnInsertRecv_createTokens_r12();
      if(r12==false) {
        revert("Rule condition failed");
      }
  }
  function getIsFinalized() public view  returns (bool) {
      bool b = isFinalized.b;
      return b;
  }
  function updateTotalInOnInsertTransfer_r41(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalIn_r6(p,delta0);
  }
  function updateTokenCreationMinOnInsertConstructor_r17(address _ethFund0,address _batFund1,uint _startBlock2,uint _endBlock3) private    {
      uint n = 675000000;
      tokenCreationMin = TokenCreationMinTuple(n,true);
  }
  function updateIsFinalizedOnInsertConstructor_r32(address _ethFund0,address _batFund1,uint _startBlock2,uint _endBlock3) private    {
      isFinalized = IsFinalizedTuple(false,true);
  }
  function updateTransferOnInsertRecv_transfer_r18(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint m = balanceOf[s].n;
      if(n<=m && n>0) {
        updateTotalOutOnInsertTransfer_r30(s,n);
        updateTotalInOnInsertTransfer_r41(r,n);
        emit Transfer(s,r,n);
        return true;
      }
      return false;
  }
  function updateIncreaseAllowanceOnInsertRecv_approve_r14(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance(o,s);
      if(n>m) {
        uint d = n-m;
        updateAllowanceTotalOnInsertIncreaseAllowance_r9(o,s,d);
        emit IncreaseAllowance(o,s,d);
        return true;
      }
      return false;
  }
  function updateSendOnIncrementTotalEthRaised_r33(int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(totalEthRaised.n,_delta);
      updateSendOnInsertTotalEthRaised_r33(newValue);
  }
  function updateCanFinalizeOnInsertTotalSupply_r1(uint ts) private    {
      uint cap = tokenCreationCap.n;
      if(ts==cap) {
        // Empty()
      }
  }
  function updateSendOnInsertFinalize_r33() private    {
      uint n = totalEthRaised.n;
      address p = ethFundDeposit.p;
      payable(p).send(n);
  }
  function updateBalanceOfOnIncrementTotalIn_r6(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateAllMintOnInsertMint_r3(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllMint_r22(delta0);
      allMint.n += n;
  }
  function updateTokenCreationCapOnInsertConstructor_r7(address _ethFund0,address _batFund1,uint _startBlock2,uint _endBlock3) private    {
      uint n = 1500000000;
      tokenCreationCap = TokenCreationCapTuple(n,true);
  }
  function updateDecreaseTotalOnInsertDecreaseAllowance_r23(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementDecreaseTotal_r16(o,s,delta0);
      decreaseTotal[o][s].m += n;
  }
  function updateAllowanceTotalOnInsertIncreaseAllowance_r9(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementAllowanceTotal_r16(o,s,delta0);
      allowanceTotal[o][s].m += n;
  }
  function updateEthFundDepositOnInsertConstructor_r39(address e,address _batFund1,uint _startBlock2,uint _endBlock3) private    {
      ethFundDeposit = EthFundDepositTuple(e,true);
  }
  function updateRefundOnInsertRecv_refund_r24() private   returns (bool) {
      address b = batFundDeposit.p;
      uint e = fundingEndBlock.n;
      address p = msg.sender;
      uint t = block.timestamp;
      uint min = tokenCreationMin.n;
      if(false==isFinalized.b) {
        uint ts = totalSupply();
        uint batVal = balanceOf[p].n;
        if(t>e && ts<min && p!=b && batVal>0) {
          updateBurnOnInsertRefund_r36(p,batVal);
          updateSendOnInsertRefund_r37(p,batVal);
          emit Refund(p,batVal);
          return true;
        }
      }
      return false;
  }
  function updateMintOnInsertConstructor_r38(address _ethFund0,address b,uint _startBlock2,uint _endBlock3) private    {
      uint n = batFundAmt.n;
      updateAllMintOnInsertMint_r3(n);
      updateTotalMintOnInsertMint_r21(b,n);
  }
  function totalSupply() private view  returns (uint) {
      uint b = allBurn.n;
      uint m = allMint.n;
      uint n = m-b;
      return n;
  }
  function updateTotalSupplyOnIncrementAllBurn_r22(int b) private    {
      int delta0 = int(-b);
      updateCanFinalizeOnIncrementTotalSupply_r1(delta0);
  }
  function updateTotalEthRaisedOnInsertConstructor_r34(address _ethFund0,address _batFund1,uint _startBlock2,uint _endBlock3) private    {
      updateSendOnInsertTotalEthRaised_r33(uint(0));
      totalEthRaised = TotalEthRaisedTuple(0,true);
  }
  function updateTotalOutOnInsertTransfer_r30(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalOut_r6(p,delta0);
  }
  function updateAllowanceOnIncrementSpentTotal_r16(address o,address s,int l) private    {
      // Empty()
  }
  function allowance(address o,address s) private view  returns (uint) {
      uint d = decreaseTotal[o][s].m;
      uint l = spentTotal[o][s].m;
      uint m = allowanceTotal[o][s].m;
      uint n = (m-l)-d;
      return n;
  }
  function updateAllBurnOnInsertBurn_r8(uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyOnIncrementAllBurn_r22(delta0);
      allBurn.n += n;
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateDecreaseAllowanceOnInsertRecv_approve_r11(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      uint m = allowance(o,s);
      if(n<m) {
        uint d = m-n;
        updateDecreaseTotalOnInsertDecreaseAllowance_r23(o,s,d);
        emit DecreaseAllowance(o,s,d);
        return true;
      }
      return false;
  }
  function updateMintOnInsertCreateTokens_r15(address p,uint v) private    {
      uint r = tokenExchangeRate.r;
      uint n = v*r;
      updateAllMintOnInsertMint_r3(n);
      updateTotalMintOnInsertMint_r21(p,n);
  }
  function updateAllowanceOnIncrementAllowanceTotal_r16(address o,address s,int m) private    {
      // Empty()
  }
  function updateTransferOnInsertTransferFrom_r10(address o,address r,address _spender2,uint n) private    {
      updateTotalOutOnInsertTransfer_r30(o,n);
      updateTotalInOnInsertTransfer_r41(r,n);
      emit Transfer(o,r,n);
  }
  function updateFundingEndBlockOnInsertConstructor_r40(address _ethFund0,address _batFund1,uint _startBlock2,uint e) private    {
      fundingEndBlock = FundingEndBlockTuple(e,true);
  }
  function updateBatFundAmtOnInsertConstructor_r27(address _ethFund0,address _batFund1,uint _startBlock2,uint _endBlock3) private    {
      uint n = 500000000;
      batFundAmt = BatFundAmtTuple(n,true);
  }
  function updateTotalBalancesOnInsertConstructor_r29(address _ethFund0,address _batFund1,uint _startBlock2,uint _endBlock3) private    {
      totalBalances = TotalBalancesTuple(0,true);
  }
  function updateTokenExchangeRateOnInsertConstructor_r5(address _ethFund0,address _batFund1,uint _startBlock2,uint _endBlock3) private    {
      uint n = 6400;
      tokenExchangeRate = TokenExchangeRateTuple(n,true);
  }
  function updateIsFinalizedOnInsertFinalize_r0() private    {
      isFinalized = IsFinalizedTuple(true,true);
  }
  function updateBalanceOfOnIncrementTotalBurn_r6(address p,int m) private    {
      int _delta = int(-m);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateBurnOnInsertRefund_r36(address p,uint n) private    {
      updateAllBurnOnInsertBurn_r8(n);
      updateTotalBurnOnInsertBurn_r20(p,n);
  }
  function updateBalanceOfOnIncrementTotalMint_r6(address p,int n) private    {
      int _delta = int(n);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateSendOnInsertTotalEthRaised_r33(uint n) private    {
      address p = ethFundDeposit.p;
      payable(p).send(n);
  }
  function updateFundingStartBlockOnInsertConstructor_r2(address _ethFund0,address _batFund1,uint s,uint _endBlock3) private    {
      fundingStartBlock = FundingStartBlockTuple(s,true);
  }
  function updateTotalBurnOnInsertBurn_r20(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalBurn_r6(p,delta0);
  }
  function updateFinalizeOnInsertRecv_finalize_r25() private   returns (bool) {
      address s = ethFundDeposit.p;
      if(s==msg.sender) {
        uint min = tokenCreationMin.n;
        if(false==isFinalized.b) {
          uint ts = totalSupply();
          if(ts>=min && canFinalize()) {
            updateIsFinalizedOnInsertFinalize_r0();
            updateSendOnInsertFinalize_r33();
            emit Finalize();
            return true;
          }
        }
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalOut_r6(address p,int o) private    {
      int _delta = int(-o);
      uint newValue = updateuintByint(balanceOf[p].n,_delta);
      balanceOf[p].n = newValue;
  }
  function updateTotalMintOnInsertMint_r21(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalMint_r6(p,delta0);
  }
  function canFinalize() private view  returns (bool) {
      uint e = fundingEndBlock.n;
      uint t = block.timestamp;
      if(t>e) {
        return true;
      }
      uint cap = tokenCreationCap.n;
      uint ts = totalSupply();
      if(ts==cap) {
        return true;
      }
      return false;
  }
  function updateAllowanceOnIncrementDecreaseTotal_r16(address o,address s,int d) private    {
      // Empty()
  }
  function updateSendOnInsertRefund_r37(address p,uint batVal) private    {
      uint r = tokenExchangeRate.r;
      uint ethVal = batVal/r;
      payable(p).send(ethVal);
  }
  function updateSpentTotalOnInsertTransferFrom_r35(address o,address s,uint n) private    {
      int delta0 = int(n);
      updateAllowanceOnIncrementSpentTotal_r16(o,s,delta0);
      spentTotal[o][s].m += n;
  }
  function updateCanFinalizeOnIncrementTotalSupply_r1(int ts) private    {
      int _delta = int(ts);
      uint newValue = updateuintByint(totalSupply(),_delta);
      updateCanFinalizeOnInsertTotalSupply_r1(newValue);
  }
  function updateTransferFromOnInsertRecv_transferFrom_r19(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint m = balanceOf[o].n;
      uint k = allowance(o,s);
      if(n>0 && m>=n && k>=n) {
        updateSpentTotalOnInsertTransferFrom_r35(o,s,n);
        updateTransferOnInsertTransferFrom_r10(o,r,s,n);
        return true;
      }
      return false;
  }
  function updateBatFundDepositOnInsertConstructor_r13(address _ethFund0,address b,uint _startBlock2,uint _endBlock3) private    {
      batFundDeposit = BatFundDepositTuple(b,true);
  }
  function updateCreateTokensOnInsertRecv_createTokens_r12() private   returns (bool) {
      uint ts = totalSupply();
      uint r = tokenExchangeRate.r;
      address p = msg.sender;
      uint t = block.timestamp;
      uint cap = tokenCreationCap.n;
      uint e = fundingEndBlock.n;
      if(false==isFinalized.b) {
        uint s = fundingStartBlock.n;
        uint v = msg.value;
        if(v>0 && t>=s && t<=e && (v*r)+ts<=cap) {
          updateMintOnInsertCreateTokens_r15(p,v);
          updateTotalEthRaisedOnInsertCreateTokens_r4(v);
          emit CreateTokens(p,v);
          return true;
        }
      }
      return false;
  }
  function updateTotalEthRaisedOnInsertCreateTokens_r4(uint v) private    {
      int delta1 = int(v);
      updateSendOnIncrementTotalEthRaised_r33(delta1);
      totalEthRaised.n += v;
  }
  function updateTotalSupplyOnIncrementAllMint_r22(int m) private    {
      int delta0 = int(m);
      updateCanFinalizeOnIncrementTotalSupply_r1(delta0);
  }
}