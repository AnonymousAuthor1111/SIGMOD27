contract Azuki {
  struct AmountForDevsTuple {
    uint n;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct TotalInitialTuple {
    uint n;
    bool _valid;
  }
  struct PublicPriceTuple {
    uint n;
    bool _valid;
  }
  struct MintlistPriceTuple {
    uint n;
    bool _valid;
  }
  struct IsApprovedForAllTuple {
    bool approved;
    bool _valid;
  }
  struct NumberMintedTuple {
    uint n;
    bool _valid;
  }
  struct TotalTokenInTuple {
    uint n;
    bool _valid;
  }
  struct PublicSaleKeyTuple {
    uint n;
    bool _valid;
  }
  struct GetApprovedTuple {
    address approved;
    bool _valid;
  }
  struct TotalTokenMintTuple {
    uint n;
    bool _valid;
  }
  struct AuctionSaleStartTimeTuple {
    uint t;
    bool _valid;
  }
  struct PublicSaleStartTimeTuple {
    uint t;
    bool _valid;
  }
  struct AllowlistTuple {
    uint n;
    bool _valid;
  }
  struct OwnerOfTuple {
    address o;
    bool _valid;
  }
  struct TotalTokenOutTuple {
    uint n;
    bool _valid;
  }
  struct AmountForAuctionAndDevTuple {
    uint n;
    bool _valid;
  }
  struct MaxPerAddressDuringMintTuple {
    uint n;
    bool _valid;
  }
  mapping(address=>NumberMintedTuple) numberMinted;
  AmountForDevsTuple amountForDevs;
  OwnerTuple owner;
  mapping(address=>TotalInitialTuple) totalInitial;
  mapping(uint=>OwnerOfTuple) ownerOf;
  mapping(address=>TotalTokenOutTuple) totalTokenOut;
  AmountForAuctionAndDevTuple amountForAuctionAndDev;
  PublicPriceTuple publicPrice;
  MintlistPriceTuple mintlistPrice;
  MaxPerAddressDuringMintTuple maxPerAddressDuringMint;
  mapping(address=>mapping(address=>IsApprovedForAllTuple)) isApprovedForAll;
  mapping(address=>TotalTokenInTuple) totalTokenIn;
  PublicSaleKeyTuple publicSaleKey;
  mapping(uint=>GetApprovedTuple) getApproved;
  mapping(address=>TotalTokenMintTuple) totalTokenMint;
  AuctionSaleStartTimeTuple auctionSaleStartTime;
  PublicSaleStartTimeTuple publicSaleStartTime;
  mapping(address=>AllowlistTuple) allowlist;
  event SetAuctionSaleStartTimeAction(uint timestamp);
  event TransferFrom(address from,address to,address operator,uint tokenId);
  event SetPublicSaleKeyAction(uint key);
  event AllowlistMintAction(address to);
  event MintToken(address to,uint tokenId);
  event AuctionMintAction(address to,uint quantity);
  event SeedAllowlistAction(address account,uint slots);
  event PublicSaleMintAction(address to,uint quantity);
  event ApproveAction(address o,address approved,uint tokenId);
  event SetApprovalForAllAction(address o,address operator,bool approved);
  event DevMintAction(address to,uint quantity);
  event EndAuctionAndSetupNonAuctionSaleInfoAction(uint mintlistPriceWei,uint publicPriceWei,uint publicSaleStartTime_);
  constructor(uint maxBatchSize,uint collectionSize_,uint amountForAuctionAndDev_,uint amountForDevs_) public {
    updateCollectionSizeOnInsertConstructor_r29(maxBatchSize,collectionSize_,amountForAuctionAndDev_,amountForDevs_);
    updateAmountForDevsOnInsertConstructor_r16(maxBatchSize,collectionSize_,amountForAuctionAndDev_,amountForDevs_);
    updatePublicSaleKeyOnInsertConstructor_r0(maxBatchSize,collectionSize_,amountForAuctionAndDev_,amountForDevs_);
    updateAuctionSaleStartTimeOnInsertConstructor_r45(maxBatchSize,collectionSize_,amountForAuctionAndDev_,amountForDevs_);
    updateMintlistPriceOnInsertConstructor_r52(maxBatchSize,collectionSize_,amountForAuctionAndDev_,amountForDevs_);
    updateMaxPerAddressDuringMintOnInsertConstructor_r26(maxBatchSize,collectionSize_,amountForAuctionAndDev_,amountForDevs_);
    updatePublicPriceOnInsertConstructor_r12(maxBatchSize,collectionSize_,amountForAuctionAndDev_,amountForDevs_);
    updateOwnerOnInsertConstructor_r43(maxBatchSize,collectionSize_,amountForAuctionAndDev_,amountForDevs_);
    updatePublicSaleStartTimeOnInsertConstructor_r5(maxBatchSize,collectionSize_,amountForAuctionAndDev_,amountForDevs_);
    updateAmountForAuctionAndDevOnInsertConstructor_r28(maxBatchSize,collectionSize_,amountForAuctionAndDev_,amountForDevs_);
  }
  function endAuctionAndSetupNonAuctionSaleInfo(uint mintlistPriceWei,uint publicPriceWei,uint publicSaleStartTime_) public    {
      bool r38 = updateEndAuctionAndSetupNonAuctionSaleInfoActionOnInsertRecv_endAuctionAndSetupNonAuctionSaleInfo_r38(mintlistPriceWei,publicPriceWei,publicSaleStartTime_);
      if(r38==false) {
        revert("Rule condition failed");
      }
  }
  function seedAllowlist(address account,uint slots) public    {
      bool r17 = updateSeedAllowlistActionOnInsertRecv_seedAllowlist_r17(account,slots);
      if(r17==false) {
        revert("Rule condition failed");
      }
  }
  function transferFrom(address from,address to,uint tokenId) public    {
      bool r36 = updateTransferFromOnInsertRecv_transferFrom_r36(from,to,tokenId);
      bool r32 = updateTransferFromOnInsertRecv_transferFrom_r32(from,to,tokenId);
      bool r35 = updateTransferFromOnInsertRecv_transferFrom_r35(from,to,tokenId);
      if(r36==false && r32==false && r35==false) {
        revert("Rule condition failed");
      }
  }
  function getOwnerOf(uint tokenId) public view  returns (address) {
      address o = ownerOf[tokenId].o;
      return o;
  }
  function getMintlistPrice() public view  returns (uint) {
      uint n = mintlistPrice.n;
      return n;
  }
  function getGetApproved(uint tokenId) public view  returns (address) {
      address approved = getApproved[tokenId].approved;
      return approved;
  }
  function getPublicSaleKey() public view  returns (uint) {
      uint n = publicSaleKey.n;
      return n;
  }
  function getAuctionSaleStartTime() public view  returns (uint) {
      uint t = auctionSaleStartTime.t;
      return t;
  }
  function getPublicPrice() public view  returns (uint) {
      uint n = publicPrice.n;
      return n;
  }
  function getPublicSaleStartTime() public view  returns (uint) {
      uint t = publicSaleStartTime.t;
      return t;
  }
  function setAuctionSaleStartTime(uint timestamp) public    {
      bool r4 = updateSetAuctionSaleStartTimeActionOnInsertRecv_setAuctionSaleStartTime_r4(timestamp);
      if(r4==false) {
        revert("Rule condition failed");
      }
  }
  function devMint(uint quantity) public    {
      bool r51 = updateDevMintActionOnInsertRecv_devMint_r51(quantity);
      if(r51==false) {
        revert("Rule condition failed");
      }
  }
  function approve(address approved,uint tokenId) public    {
      bool r11 = updateApproveActionOnInsertRecv_approve_r11(approved,tokenId);
      if(r11==false) {
        revert("Rule condition failed");
      }
  }
  function setPublicSaleKey(uint key) public    {
      bool r40 = updateSetPublicSaleKeyActionOnInsertRecv_setPublicSaleKey_r40(key);
      if(r40==false) {
        revert("Rule condition failed");
      }
  }
  function getIsApprovedForAll(address o,address operator) public view  returns (bool) {
      bool approved = isApprovedForAll[o][operator].approved;
      return approved;
  }
  function allowlistMint() public    {
      bool r6 = updateAllowlistMintActionOnInsertRecv_allowlistMint_r6();
      if(r6==false) {
        revert("Rule condition failed");
      }
  }
  function publicSaleMint(uint quantity,uint callerPublicSaleKey) public    {
      bool r7 = updatePublicSaleMintActionOnInsertRecv_publicSaleMint_r7(quantity,callerPublicSaleKey);
      if(r7==false) {
        revert("Rule condition failed");
      }
  }
  function auctionMint(uint quantity) public    {
      bool r14 = updateAuctionMintActionOnInsertRecv_auctionMint_r14(quantity);
      if(r14==false) {
        revert("Rule condition failed");
      }
  }
  function getNumberMinted(address p) public view  returns (uint) {
      uint n = numberMinted[p].n;
      return n;
  }
  function getBalanceOf(address p) public view  returns (uint) {
      uint n = balanceOf(p);
      return n;
  }
  function mintToken(address to,uint tokenId) public    {
      bool r30 = updateMintTokenOnInsertRecv_mintToken_r30(to,tokenId);
      if(r30==false) {
        revert("Rule condition failed");
      }
  }
  function setApprovalForAll(address operator,bool approved) public    {
      bool r31 = updateSetApprovalForAllActionOnInsertRecv_setApprovalForAll_r31(operator,approved);
      if(r31==false) {
        revert("Rule condition failed");
      }
  }
  function getAllowlist(address p) public view  returns (uint) {
      uint n = allowlist[p].n;
      return n;
  }
  function updateMaxPerAddressDuringMintOnInsertConstructor_r26(uint n,uint _collectionSize_1,uint _amountForAuctionAndDev_2,uint _amountForDevs_3) private    {
      maxPerAddressDuringMint = MaxPerAddressDuringMintTuple(n,true);
  }
  function updateInitialApprovalOnInsertTransferFrom_r47(address _from0,address _to1,address _operator2,uint tokenId) private    {
      updateGetApprovedOnInsertInitialApproval_r18(tokenId,address(0));
  }
  function updateGetApprovedOnInsertInitialApproval_r18(uint tokenId,address _approved1) private    {
      getApproved[tokenId] = GetApprovedTuple(address(0),true);
  }
  function updateTotalInitialOnInsertInitialBalance_r20(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalInitial_r2(p,delta0);
      totalInitial[p].n += n;
  }
  function updateSetAuctionSaleStartTimeActionOnInsertRecv_setAuctionSaleStartTime_r4(uint t) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        updateAuctionSaleStartTimeOnInsertSetAuctionSaleStartTimeAction_r41(t);
        emit SetAuctionSaleStartTimeAction(t);
        return true;
      }
      return false;
  }
  function updatePublicSaleKeyOnInsertSetPublicSaleKeyAction_r10(uint k) private    {
      publicSaleKey = PublicSaleKeyTuple(k,true);
  }
  function updateOwnerOnInsertConstructor_r43(uint _maxBatchSize0,uint _collectionSize_1,uint _amountForAuctionAndDev_2,uint _amountForDevs_3) private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updatePublicSaleKeyOnInsertConstructor_r0(uint _maxBatchSize0,uint _collectionSize_1,uint _amountForAuctionAndDev_2,uint _amountForDevs_3) private    {
      publicSaleKey = PublicSaleKeyTuple(0,true);
  }
  function updateEndAuctionAndSetupNonAuctionSaleInfoActionOnInsertRecv_endAuctionAndSetupNonAuctionSaleInfo_r38(uint mp,uint pp,uint pst) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        updatePublicPriceOnInsertEndAuctionAndSetupNonAuctionSaleInfoAction_r25(mp,pp,pst);
        updatePublicSaleStartTimeOnInsertEndAuctionAndSetupNonAuctionSaleInfoAction_r23(mp,pp,pst);
        updateAuctionSaleStartTimeOnInsertEndAuctionAndSetupNonAuctionSaleInfoAction_r48(mp,pp,pst);
        updateMintlistPriceOnInsertEndAuctionAndSetupNonAuctionSaleInfoAction_r44(mp,pp,pst);
        emit EndAuctionAndSetupNonAuctionSaleInfoAction(mp,pp,pst);
        return true;
      }
      return false;
  }
  function updatePublicSaleStartTimeOnInsertConstructor_r5(uint _maxBatchSize0,uint _collectionSize_1,uint _amountForAuctionAndDev_2,uint _amountForDevs_3) private    {
      publicSaleStartTime = PublicSaleStartTimeTuple(0,true);
  }
  function updateGetApprovedOnInsertApproveAction_r8(address _o0,address approved,uint tokenId) private    {
      getApproved[tokenId] = GetApprovedTuple(approved,true);
  }
  function updateAllowlistMintActionOnInsertRecv_allowlistMint_r6() private   returns (bool) {
      address s = msg.sender;
      uint slots = allowlist[s].n;
      uint price = mintlistPrice.n;
      if(s!=address(0) && price>0 && slots>0) {
        updateTotalAllowlistByOnInsertAllowlistMintAction_r34(s);
        emit AllowlistMintAction(s);
        return true;
      }
      return false;
  }
  function updateTotalTokenMintOnInsertMintToken_r9(address p,uint _tokenId1) private    {
      int delta0 = int(1);
      updateBalanceOfOnIncrementTotalTokenMint_r2(p,delta0);
      totalTokenMint[p].n += 1;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r35(address from,address to,uint tokenId) private   returns (bool) {
      address s = msg.sender;
      if(s==getApproved[tokenId].approved) {
        if(from==ownerOf[tokenId].o) {
          if(from!=address(0) && to!=address(0) && s!=address(0)) {
            updateOwnerOfOnInsertTransferFrom_r15(from,to,s,tokenId);
            updateInitialBalanceOnInsertTransferFrom_r21(from,to,s,tokenId);
            updateInitialBalanceOnInsertTransferFrom_r33(from,to,s,tokenId);
            updateTotalTokenOutOnInsertTransferFrom_r1(from,to,s,tokenId);
            updateTotalTokenInOnInsertTransferFrom_r50(from,to,s,tokenId);
            updateGetApprovedOnInsertTransferFrom_r49(from,to,s,tokenId);
            updateInitialApprovalOnInsertTransferFrom_r47(from,to,s,tokenId);
            emit TransferFrom(from,to,s,tokenId);
            return true;
          }
        }
      }
      return false;
  }
  function balanceOf(address p) private view  returns (uint) {
      uint ti = totalTokenIn[p].n;
      uint o = totalTokenOut[p].n;
      uint m = totalTokenMint[p].n;
      uint i = totalInitial[p].n;
      uint s = ((i+m)+ti)-o;
      return s;
  }
  function updateBalanceOfOnIncrementTotalTokenOut_r2(address p,int o) private    {
      // Empty()
  }
  function updateCollectionSizeOnInsertConstructor_r29(uint _maxBatchSize0,uint n,uint _amountForAuctionAndDev_2,uint _amountForDevs_3) private    {
      // Empty()
  }
  function updateNumberMintedOnIncrementTotalDevBy_r24(address p,int d) private    {
      int _delta = int(d);
      uint newValue = updateuintByint(numberMinted[p].n,_delta);
      numberMinted[p].n = newValue;
  }
  function updateSetPublicSaleKeyActionOnInsertRecv_setPublicSaleKey_r40(uint k) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        updatePublicSaleKeyOnInsertSetPublicSaleKeyAction_r10(k);
        emit SetPublicSaleKeyAction(k);
        return true;
      }
      return false;
  }
  function updateNumberMintedOnIncrementTotalAuctionBy_r24(address p,int a) private    {
      int _delta = int(a);
      uint newValue = updateuintByint(numberMinted[p].n,_delta);
      numberMinted[p].n = newValue;
  }
  function updateBalanceOfOnIncrementTotalTokenIn_r2(address p,int ti) private    {
      // Empty()
  }
  function updateMintTokenOnInsertRecv_mintToken_r30(address to,uint tokenId) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(to!=address(0)) {
          updateTotalTokenMintOnInsertMintToken_r9(to,tokenId);
          updateOwnerOfOnInsertMintToken_r37(to,tokenId);
          updateInitialBalanceOnInsertMintToken_r27(to,tokenId);
          updateInitialApprovalOnInsertMintToken_r22(to,tokenId);
          emit MintToken(to,tokenId);
          return true;
        }
      }
      return false;
  }
  function updateInitialBalanceOnInsertTransferFrom_r33(address p,address _to1,address _operator2,uint _tokenId3) private    {
      updateTotalInitialOnInsertInitialBalance_r20(p,uint(0));
  }
  function updateTotalPublicByOnInsertPublicSaleMintAction_r13(address p,uint n) private    {
      int delta0 = int(n);
      updateNumberMintedOnIncrementTotalPublicBy_r24(p,delta0);
  }
  function updateOwnerOfOnInsertTransferFrom_r15(address _from0,address to,address _operator2,uint tokenId) private    {
      ownerOf[tokenId] = OwnerOfTuple(to,true);
  }
  function updateBalanceOfOnIncrementTotalInitial_r2(address p,int i) private    {
      // Empty()
  }
  function updatePublicPriceOnInsertConstructor_r12(uint _maxBatchSize0,uint _collectionSize_1,uint _amountForAuctionAndDev_2,uint _amountForDevs_3) private    {
      publicPrice = PublicPriceTuple(0,true);
  }
  function updateTransferFromOnInsertRecv_transferFrom_r36(address from,address to,uint tokenId) private   returns (bool) {
      if(from==msg.sender) {
        if(from==ownerOf[tokenId].o) {
          if(from!=address(0) && to!=address(0)) {
            updateTotalTokenOutOnInsertTransferFrom_r1(from,to,from,tokenId);
            updateTotalTokenInOnInsertTransferFrom_r50(from,to,from,tokenId);
            updateGetApprovedOnInsertTransferFrom_r49(from,to,from,tokenId);
            updateOwnerOfOnInsertTransferFrom_r15(from,to,from,tokenId);
            updateInitialBalanceOnInsertTransferFrom_r33(from,to,from,tokenId);
            updateInitialApprovalOnInsertTransferFrom_r47(from,to,from,tokenId);
            updateInitialBalanceOnInsertTransferFrom_r21(from,to,from,tokenId);
            emit TransferFrom(from,to,from,tokenId);
            return true;
          }
        }
      }
      return false;
  }
  function updateNumberMintedOnIncrementTotalAllowlistBy_r24(address p,int l) private    {
      int _delta = int(l);
      uint newValue = updateuintByint(numberMinted[p].n,_delta);
      numberMinted[p].n = newValue;
  }
  function updateTotalDevByOnInsertDevMintAction_r19(address p,uint n) private    {
      int delta0 = int(n);
      updateNumberMintedOnIncrementTotalDevBy_r24(p,delta0);
  }
  function updateAuctionSaleStartTimeOnInsertSetAuctionSaleStartTimeAction_r41(uint t) private    {
      auctionSaleStartTime = AuctionSaleStartTimeTuple(t,true);
  }
  function updatePublicSaleMintActionOnInsertRecv_publicSaleMint_r7(uint q,uint keyIn) private   returns (bool) {
      address s = msg.sender;
      uint maxMint = maxPerAddressDuringMint.n;
      uint minted = numberMinted[s].n;
      uint key = publicSaleKey.n;
      uint price = publicPrice.n;
      uint start = publicSaleStartTime.t;
      if(start>0 && key>0 && key==keyIn && s!=address(0) && price>0 && q>0 && minted+q<=maxMint) {
        updateTotalPublicByOnInsertPublicSaleMintAction_r13(s,q);
        emit PublicSaleMintAction(s,q);
        return true;
      }
      return false;
  }
  function updatePublicPriceOnInsertEndAuctionAndSetupNonAuctionSaleInfoAction_r25(uint _mintlistPriceWei0,uint pp,uint _publicSaleStartTime_2) private    {
      publicPrice = PublicPriceTuple(pp,true);
  }
  function updateMintlistPriceOnInsertConstructor_r52(uint _maxBatchSize0,uint _collectionSize_1,uint _amountForAuctionAndDev_2,uint _amountForDevs_3) private    {
      mintlistPrice = MintlistPriceTuple(0,true);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateApproveActionOnInsertRecv_approve_r11(address approved,uint tokenId) private   returns (bool) {
      address o = msg.sender;
      if(o==ownerOf[tokenId].o) {
        if(o!=address(0) && approved!=o) {
          updateInitialApprovalOnInsertApproveAction_r42(o,approved,tokenId);
          updateGetApprovedOnInsertApproveAction_r8(o,approved,tokenId);
          emit ApproveAction(o,approved,tokenId);
          return true;
        }
      }
      return false;
  }
  function updateGetApprovedOnInsertTransferFrom_r49(address _from0,address _to1,address _operator2,uint tokenId) private    {
      getApproved[tokenId] = GetApprovedTuple(address(0),true);
  }
  function updateTotalTokenOutOnInsertTransferFrom_r1(address p,address _to1,address _operator2,uint _tokenId3) private    {
      int delta0 = int(1);
      updateBalanceOfOnIncrementTotalTokenOut_r2(p,delta0);
      totalTokenOut[p].n += 1;
  }
  function updateInitialBalanceOnInsertTransferFrom_r21(address _from0,address p,address _operator2,uint _tokenId3) private    {
      updateTotalInitialOnInsertInitialBalance_r20(p,uint(0));
  }
  function updateDevMintActionOnInsertRecv_devMint_r51(uint q) private   returns (bool) {
      uint limit = amountForDevs.n;
      address s = owner.p;
      if(s==msg.sender) {
        if(q<=limit && q>0) {
          updateTotalDevByOnInsertDevMintAction_r19(s,q);
          emit DevMintAction(s,q);
          return true;
        }
      }
      return false;
  }
  function updateOwnerOfOnInsertMintToken_r37(address to,uint tokenId) private    {
      ownerOf[tokenId] = OwnerOfTuple(to,true);
  }
  function updateTransferFromOnInsertRecv_transferFrom_r32(address from,address to,uint tokenId) private   returns (bool) {
      address s = msg.sender;
      if(true==isApprovedForAll[from][s].approved) {
        if(from==ownerOf[tokenId].o) {
          if(from!=address(0) && to!=address(0) && s!=address(0)) {
            updateOwnerOfOnInsertTransferFrom_r15(from,to,s,tokenId);
            updateInitialBalanceOnInsertTransferFrom_r21(from,to,s,tokenId);
            updateInitialBalanceOnInsertTransferFrom_r33(from,to,s,tokenId);
            updateTotalTokenOutOnInsertTransferFrom_r1(from,to,s,tokenId);
            updateTotalTokenInOnInsertTransferFrom_r50(from,to,s,tokenId);
            updateGetApprovedOnInsertTransferFrom_r49(from,to,s,tokenId);
            updateInitialApprovalOnInsertTransferFrom_r47(from,to,s,tokenId);
            emit TransferFrom(from,to,s,tokenId);
            return true;
          }
        }
      }
      return false;
  }
  function updatePublicSaleStartTimeOnInsertEndAuctionAndSetupNonAuctionSaleInfoAction_r23(uint _mintlistPriceWei0,uint _publicPriceWei1,uint pst) private    {
      publicSaleStartTime = PublicSaleStartTimeTuple(pst,true);
  }
  function updateSeedAllowlistActionOnInsertRecv_seedAllowlist_r17(address a,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(a!=address(0)) {
          updateAllowlistOnInsertSeedAllowlistAction_r39(a,n);
          emit SeedAllowlistAction(a,n);
          return true;
        }
      }
      return false;
  }
  function updateAmountForDevsOnInsertConstructor_r16(uint _maxBatchSize0,uint _collectionSize_1,uint _amountForAuctionAndDev_2,uint n) private    {
      amountForDevs = AmountForDevsTuple(n,true);
  }
  function updateAuctionMintActionOnInsertRecv_auctionMint_r14(uint q) private   returns (bool) {
      address s = msg.sender;
      uint maxMint = maxPerAddressDuringMint.n;
      uint limit = amountForAuctionAndDev.n;
      uint ast = auctionSaleStartTime.t;
      uint minted = numberMinted[s].n;
      if(ast>0 && q>0 && minted+q<=maxMint && s!=address(0) && q<=limit) {
        updateTotalAuctionByOnInsertAuctionMintAction_r3(s,q);
        emit AuctionMintAction(s,q);
        return true;
      }
      return false;
  }
  function updateMintlistPriceOnInsertEndAuctionAndSetupNonAuctionSaleInfoAction_r44(uint mp,uint _publicPriceWei1,uint _publicSaleStartTime_2) private    {
      mintlistPrice = MintlistPriceTuple(mp,true);
  }
  function updateTotalAllowlistByOnInsertAllowlistMintAction_r34(address p) private    {
      int delta0 = int(1);
      updateNumberMintedOnIncrementTotalAllowlistBy_r24(p,delta0);
  }
  function updateTotalAuctionByOnInsertAuctionMintAction_r3(address p,uint n) private    {
      int delta0 = int(n);
      updateNumberMintedOnIncrementTotalAuctionBy_r24(p,delta0);
  }
  function updateAmountForAuctionAndDevOnInsertConstructor_r28(uint _maxBatchSize0,uint _collectionSize_1,uint n,uint _amountForDevs_3) private    {
      amountForAuctionAndDev = AmountForAuctionAndDevTuple(n,true);
  }
  function updateBalanceOfOnIncrementTotalTokenMint_r2(address p,int m) private    {
      // Empty()
  }
  function updateAuctionSaleStartTimeOnInsertEndAuctionAndSetupNonAuctionSaleInfoAction_r48(uint _mintlistPriceWei0,uint _publicPriceWei1,uint _publicSaleStartTime_2) private    {
      auctionSaleStartTime = AuctionSaleStartTimeTuple(0,true);
  }
  function updateIsApprovedForAllOnInsertSetApprovalForAllAction_r46(address o,address operator,bool approved) private    {
      isApprovedForAll[o][operator] = IsApprovedForAllTuple(approved,true);
  }
  function updateInitialApprovalOnInsertApproveAction_r42(address _o0,address _approved1,uint tokenId) private    {
      updateGetApprovedOnInsertInitialApproval_r18(tokenId,address(0));
  }
  function updateAuctionSaleStartTimeOnInsertConstructor_r45(uint _maxBatchSize0,uint _collectionSize_1,uint _amountForAuctionAndDev_2,uint _amountForDevs_3) private    {
      auctionSaleStartTime = AuctionSaleStartTimeTuple(0,true);
  }
  function updateAllowlistOnInsertSeedAllowlistAction_r39(address p,uint n) private    {
      allowlist[p].n += n;
  }
  function updateSetApprovalForAllActionOnInsertRecv_setApprovalForAll_r31(address operator,bool approved) private   returns (bool) {
      address o = msg.sender;
      if(o!=address(0) && operator!=address(0) && operator!=o) {
        updateIsApprovedForAllOnInsertSetApprovalForAllAction_r46(o,operator,approved);
        emit SetApprovalForAllAction(o,operator,approved);
        return true;
      }
      return false;
  }
  function updateInitialBalanceOnInsertMintToken_r27(address p,uint _tokenId1) private    {
      updateTotalInitialOnInsertInitialBalance_r20(p,uint(0));
  }
  function updateNumberMintedOnIncrementTotalPublicBy_r24(address p,int pb) private    {
      int _delta = int(pb);
      uint newValue = updateuintByint(numberMinted[p].n,_delta);
      numberMinted[p].n = newValue;
  }
  function updateTotalTokenInOnInsertTransferFrom_r50(address _from0,address p,address _operator2,uint _tokenId3) private    {
      int delta0 = int(1);
      updateBalanceOfOnIncrementTotalTokenIn_r2(p,delta0);
      totalTokenIn[p].n += 1;
  }
  function updateInitialApprovalOnInsertMintToken_r22(address _to0,uint tokenId) private    {
      updateGetApprovedOnInsertInitialApproval_r18(tokenId,address(0));
  }
}