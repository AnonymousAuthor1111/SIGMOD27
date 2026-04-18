contract CryptoPunks {
  struct BidValueTuple {
    uint n;
    bool _valid;
  }
  struct AllPunksAssignedTuple {
    bool b;
    bool _valid;
  }
  struct TotalPendingDebitTuple {
    uint n;
    bool _valid;
  }
  struct PunkHasBidTuple {
    bool b;
    bool _valid;
  }
  struct OfferSellerTuple {
    address seller;
    bool _valid;
  }
  struct OfferMinValueTuple {
    uint n;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct PunkIndexToAddressTuple {
    address o;
    bool _valid;
  }
  struct PendingWithdrawalsTuple {
    uint n;
    bool _valid;
  }
  struct TotalPendingCreditTuple {
    uint n;
    bool _valid;
  }
  struct InitialPendingTuple {
    address p;
    uint n;
    bool _valid;
  }
  struct PunksOfferedForSaleTuple {
    bool b;
    bool _valid;
  }
  struct BidBidderTuple {
    address bidder;
    bool _valid;
  }
  mapping(uint=>BidValueTuple) bidValue;
  mapping(address=>TotalPendingCreditTuple) totalPendingCredit;
  AllPunksAssignedTuple allPunksAssigned;
  InitialPendingTuple initialPending;
  mapping(uint=>PunksOfferedForSaleTuple) punksOfferedForSale;
  mapping(address=>TotalPendingDebitTuple) totalPendingDebit;
  mapping(uint=>BidBidderTuple) bidBidder;
  mapping(uint=>PunkHasBidTuple) punkHasBid;
  mapping(uint=>OfferSellerTuple) offerSeller;
  mapping(uint=>OfferMinValueTuple) offerMinValue;
  OwnerTuple owner;
  mapping(uint=>PunkIndexToAddressTuple) punkIndexToAddress;
  mapping(address=>PendingWithdrawalsTuple) pendingWithdrawals;
  event TransferPunkAction(address from,address to,uint punkIndex);
  event EnterBidAction(uint punkIndex,address bidder,uint paid);
  event WithdrawAction(address p,uint amount);
  event AcceptBidAction(address seller,address bidder,uint punkIndex,uint paid);
  event WithdrawBidAction(address bidder,uint punkIndex,uint paid);
  event GetPunkAction(address to,uint punkIndex);
  event PunkNoLongerForSaleAction(address seller,uint punkIndex);
  event OfferPunkForSaleAction(address seller,uint punkIndex,uint minSalePriceInWei);
  event AllInitialOwnersAssignedAction();
  event BuyPunkAction(address buyer,address seller,uint punkIndex,uint paid);
  constructor() public {
    updateOwnerOnInsertConstructor_r5();
    updateAllPunksAssignedOnInsertConstructor_r64();
  }
  function withdraw() public    {
      bool r33 = updateWithdrawActionOnInsertRecv_withdraw_r33();
      if(r33==false) {
        revert("Rule condition failed");
      }
  }
  function offerPunkForSale(uint punkIndex,uint minSalePriceInWei) public    {
      bool r35 = updateOfferPunkForSaleActionOnInsertRecv_offerPunkForSale_r35(punkIndex,minSalePriceInWei);
      if(r35==false) {
        revert("Rule condition failed");
      }
  }
  function transferPunk(address to,uint punkIndex) public    {
      bool r10 = updateTransferPunkActionOnInsertRecv_transferPunk_r10(to,punkIndex);
      if(r10==false) {
        revert("Rule condition failed");
      }
  }
  function getPunk(uint punkIndex) public    {
      bool r53 = updateGetPunkActionOnInsertRecv_getPunk_r53(punkIndex);
      if(r53==false) {
        revert("Rule condition failed");
      }
  }
  function acceptBidForPunk(uint punkIndex,uint minPrice) public    {
      bool r55 = updateAcceptBidActionOnInsertRecv_acceptBidForPunk_r55(punkIndex,minPrice);
      if(r55==false) {
        revert("Rule condition failed");
      }
  }
  function allInitialOwnersAssigned() public    {
      bool r40 = updateAllInitialOwnersAssignedActionOnInsertRecv_allInitialOwnersAssigned_r40();
      if(r40==false) {
        revert("Rule condition failed");
      }
  }
  function withdrawBidForPunk(uint punkIndex) public    {
      bool r49 = updateWithdrawBidActionOnInsertRecv_withdrawBidForPunk_r49(punkIndex);
      if(r49==false) {
        revert("Rule condition failed");
      }
  }
  function buyPunk(uint punkIndex) public  payable  {
      bool r58 = updateBuyPunkActionOnInsertRecv_buyPunk_r58(punkIndex);
      if(r58==false) {
        revert("Rule condition failed");
      }
  }
  function enterBidForPunk(uint punkIndex) public  payable  {
      bool r14 = updateEnterBidActionOnInsertRecv_enterBidForPunk_r14(punkIndex);
      bool r69 = updateEnterBidActionOnInsertRecv_enterBidForPunk_r69(punkIndex);
      if(r14==false && r69==false) {
        revert("Rule condition failed");
      }
  }
  function punkNoLongerForSale(uint punkIndex) public    {
      bool r83 = updatePunkNoLongerForSaleActionOnInsertRecv_punkNoLongerForSale_r83(punkIndex);
      if(r83==false) {
        revert("Rule condition failed");
      }
  }
  function updatePendingWithdrawalsOnInsertTotalPendingDebit_r26(address p,uint d) private    {
      TotalPendingDebitTuple memory toDelete = totalPendingDebit[p];
      if(toDelete._valid==true) {
        updatePendingWithdrawalsOnDeleteTotalPendingDebit_r26(p,toDelete.n);
      }
      uint c = totalPendingCredit[p].n;
      if(p==initialPending.p) {
        uint i = initialPending.n;
        uint s = (i+c)-d;
        pendingWithdrawals[p] = PendingWithdrawalsTuple(s,true);
      }
  }
  function updateBidBidderOnInsertWithdrawBidAction_r2(uint punkIndex) private    {
      bidBidder[punkIndex] = BidBidderTuple(address(0),true);
  }
  function updatePunkIndexToAddressOnInsertGetPunkAction_r47(address to,uint punkIndex) private    {
      punkIndexToAddress[punkIndex] = PunkIndexToAddressTuple(to,true);
  }
  function updateBidValueOnInsertTouchedBid_r22(uint punkIndex) private    {
      bidValue[punkIndex] = BidValueTuple(0,true);
  }
  function updatePunkIndexToAddressOnInsertAcceptBidAction_r12(address to,uint punkIndex) private    {
      punkIndexToAddress[punkIndex] = PunkIndexToAddressTuple(to,true);
  }
  function updateSendOnInsertWithdrawAction_r39(address p,uint amount) private    {
      payable(p).send(amount);
  }
  function updatePendingWithdrawalsOnDeleteTotalPendingCredit_r26(address p,uint c) private    {
      uint d = totalPendingDebit[p].n;
      if(p==initialPending.p) {
        uint i = initialPending.n;
        uint s = (i+c)-d;
        if(s==pendingWithdrawals[p].n) {
          pendingWithdrawals[p] = PendingWithdrawalsTuple(0,false);
        }
      }
  }
  function updateOfferMinValueOnInsertTransferPunkAction_r54(uint punkIndex) private    {
      offerMinValue[punkIndex] = OfferMinValueTuple(0,true);
  }
  function updateOfferMinValueOnInsertPunkNoLongerForSaleAction_r70(uint punkIndex) private    {
      offerMinValue[punkIndex] = OfferMinValueTuple(0,true);
  }
  function updatePunkHasBidOnInsertTouchedBid_r76(uint punkIndex) private    {
      punkHasBid[punkIndex] = PunkHasBidTuple(false,true);
  }
  function updateTouchedBidOnInsertEnterBidAction_r66(uint punkIndex) private    {
      updateBidBidderOnInsertTouchedBid_r1(punkIndex);
      updatePunkHasBidOnInsertTouchedBid_r76(punkIndex);
      updateBidValueOnInsertTouchedBid_r22(punkIndex);
  }
  function updateBidValueOnInsertAcceptBidAction_r4(uint punkIndex) private    {
      bidValue[punkIndex] = BidValueTuple(0,true);
  }
  function updateBuyPunkActionOnInsertRecv_buyPunk_r58(uint punkIndex) private   returns (bool) {
      uint paid = msg.value;
      address buyer = msg.sender;
      if(true==allPunksAssigned.b) {
        address seller = offerSeller[punkIndex].seller;
        uint minValue = offerMinValue[punkIndex].n;
        if(seller==punkIndexToAddress[punkIndex].o) {
          if(true==punksOfferedForSale[punkIndex].b) {
            if(buyer!=address(0) && punkIndex<10000 && paid>=minValue) {
              updateOfferSellerOnInsertBuyPunkAction_r44(punkIndex);
              updateBidValueOnInsertBuyPunkAction_r80(punkIndex);
              updatePunksOfferedForSaleOnInsertBuyPunkAction_r85(punkIndex);
              updateTouchedOfferOnInsertBuyPunkAction_r41(punkIndex);
              updatePunkIndexToAddressOnInsertBuyPunkAction_r37(buyer,punkIndex);
              updatePunkHasBidOnInsertBuyPunkAction_r67(punkIndex);
              updateBidBidderOnInsertBuyPunkAction_r38(punkIndex);
              updateTouchedBidOnInsertBuyPunkAction_r77(punkIndex);
              updatePendingCreditOnInsertBuyPunkAction_r61(seller,paid);
              updateOfferMinValueOnInsertBuyPunkAction_r59(punkIndex);
              emit BuyPunkAction(buyer,seller,punkIndex,paid);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updateBidValueOnInsertWithdrawBidAction_r43(uint punkIndex) private    {
      bidValue[punkIndex] = BidValueTuple(0,true);
  }
  function updatePunksOfferedForSaleOnInsertAcceptBidAction_r65(uint punkIndex) private    {
      punksOfferedForSale[punkIndex] = PunksOfferedForSaleTuple(false,true);
  }
  function updateWithdrawActionOnInsertRecv_withdraw_r33() private   returns (bool) {
      if(true==allPunksAssigned.b) {
        address p = msg.sender;
        uint amount = pendingWithdrawals[p].n;
        if(p!=address(0) && amount>0) {
          updateSendOnInsertWithdrawAction_r39(p,amount);
          updatePendingDebitOnInsertWithdrawAction_r28(p,amount);
          emit WithdrawAction(p,amount);
          return true;
        }
      }
      return false;
  }
  function updatePunkHasBidOnInsertEnterBidAction_r32(uint punkIndex) private    {
      punkHasBid[punkIndex] = PunkHasBidTuple(true,true);
  }
  function updatePunkIndexToAddressOnInsertBuyPunkAction_r37(address to,uint punkIndex) private    {
      punkIndexToAddress[punkIndex] = PunkIndexToAddressTuple(to,true);
  }
  function updatePunkIndexToAddressOnInsertTransferPunkAction_r24(address to,uint punkIndex) private    {
      punkIndexToAddress[punkIndex] = PunkIndexToAddressTuple(to,true);
  }
  function updateTouchedOfferOnInsertTransferPunkAction_r48(uint punkIndex) private    {
      updateOfferSellerOnInsertTouchedOffer_r60(punkIndex);
      updatePunksOfferedForSaleOnInsertTouchedOffer_r52(punkIndex);
      updateOfferMinValueOnInsertTouchedOffer_r56(punkIndex);
  }
  function updatePunkHasBidOnInsertAcceptBidAction_r8(uint punkIndex) private    {
      punkHasBid[punkIndex] = PunkHasBidTuple(false,true);
  }
  function updatePendingWithdrawalsOnIncrementTotalPendingCredit_r26(address p,int c) private    {
      int _delta = int(c);
      uint newValue = updateuintByint(totalPendingCredit[p].n,_delta);
      updatePendingWithdrawalsOnInsertTotalPendingCredit_r26(p,newValue);
  }
  function updateEnterBidActionOnInsertRecv_enterBidForPunk_r69(uint punkIndex) private   returns (bool) {
      address bidder = msg.sender;
      uint paid = msg.value;
      if(true==allPunksAssigned.b) {
        address ownerOfPunk = punkIndexToAddress[punkIndex].o;
        if(false==punkHasBid[punkIndex].b) {
          if(bidder!=address(0) && punkIndex<10000 && ownerOfPunk!=bidder && paid>0) {
            updateTouchedBidOnInsertEnterBidAction_r66(punkIndex);
            updateBidValueOnInsertEnterBidAction_r29(punkIndex,paid);
            updatePunkHasBidOnInsertEnterBidAction_r32(punkIndex);
            updateBidBidderOnInsertEnterBidAction_r23(punkIndex,bidder);
            emit EnterBidAction(punkIndex,bidder,paid);
            return true;
          }
        }
      }
      return false;
  }
  function updateTouchedBidOnInsertGetPunkAction_r50(uint punkIndex) private    {
      updateBidBidderOnInsertTouchedBid_r1(punkIndex);
      updatePunkHasBidOnInsertTouchedBid_r76(punkIndex);
      updateBidValueOnInsertTouchedBid_r22(punkIndex);
  }
  function updateSendOnInsertWithdrawBidAction_r15(address p,uint amount) private    {
      payable(p).send(amount);
  }
  function updateTotalPendingCreditOnInsertPendingCredit_r81(address p,uint n) private    {
      int delta1 = int(n);
      updatePendingWithdrawalsOnIncrementTotalPendingCredit_r26(p,delta1);
      totalPendingCredit[p].n += n;
  }
  function updatePunkHasBidOnInsertBuyPunkAction_r67(uint punkIndex) private    {
      punkHasBid[punkIndex] = PunkHasBidTuple(false,true);
  }
  function updateBidValueOnInsertEnterBidAction_r29(uint punkIndex,uint value) private    {
      bidValue[punkIndex] = BidValueTuple(value,true);
  }
  function updateTouchedOfferOnInsertGetPunkAction_r84(uint punkIndex) private    {
      updateOfferSellerOnInsertTouchedOffer_r60(punkIndex);
      updatePunksOfferedForSaleOnInsertTouchedOffer_r52(punkIndex);
      updateOfferMinValueOnInsertTouchedOffer_r56(punkIndex);
  }
  function updateAllInitialOwnersAssignedActionOnInsertRecv_allInitialOwnersAssigned_r40() private   returns (bool) {
      if(false==allPunksAssigned.b) {
        address s = owner.p;
        if(s==msg.sender) {
          updateAllPunksAssignedOnInsertAllInitialOwnersAssignedAction_r7();
          emit AllInitialOwnersAssignedAction();
          return true;
        }
      }
      return false;
  }
  function updatePendingWithdrawalsOnInsertInitialPending_r26(address p,uint i) private    {
      uint d = totalPendingDebit[p].n;
      uint c = totalPendingCredit[p].n;
      uint s = (i+c)-d;
      pendingWithdrawals[p] = PendingWithdrawalsTuple(s,true);
  }
  function updateOfferMinValueOnInsertTouchedOffer_r56(uint punkIndex) private    {
      offerMinValue[punkIndex] = OfferMinValueTuple(0,true);
  }
  function updatePendingCreditOnInsertBuyPunkAction_r61(address seller,uint paid) private    {
      updateTotalPendingCreditOnInsertPendingCredit_r81(seller,paid);
      updateInitialPendingOnInsertPendingCredit_r51(seller);
  }
  function updateOwnerOnInsertConstructor_r5() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updatePunkNoLongerForSaleActionOnInsertRecv_punkNoLongerForSale_r83(uint punkIndex) private   returns (bool) {
      if(true==allPunksAssigned.b) {
        address seller = msg.sender;
        if(seller==punkIndexToAddress[punkIndex].o) {
          if(seller!=address(0) && punkIndex<10000) {
            updateTouchedOfferOnInsertPunkNoLongerForSaleAction_r75(punkIndex);
            updatePunksOfferedForSaleOnInsertPunkNoLongerForSaleAction_r57(punkIndex);
            updateOfferSellerOnInsertPunkNoLongerForSaleAction_r45(punkIndex);
            updateOfferMinValueOnInsertPunkNoLongerForSaleAction_r70(punkIndex);
            emit PunkNoLongerForSaleAction(seller,punkIndex);
            return true;
          }
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
  function updatePendingDebitOnInsertWithdrawAction_r28(address p,uint amount) private    {
      updateInitialPendingOnInsertPendingDebit_r0(p);
      updateTotalPendingDebitOnInsertPendingDebit_r62(p,amount);
  }
  function updateOfferSellerOnInsertPunkNoLongerForSaleAction_r45(uint punkIndex) private    {
      offerSeller[punkIndex] = OfferSellerTuple(address(0),true);
  }
  function updateOfferPunkForSaleActionOnInsertRecv_offerPunkForSale_r35(uint punkIndex,uint minSalePriceInWei) private   returns (bool) {
      if(true==allPunksAssigned.b) {
        address seller = msg.sender;
        if(seller==punkIndexToAddress[punkIndex].o) {
          if(seller!=address(0) && punkIndex<10000) {
            updateTouchedOfferOnInsertOfferPunkForSaleAction_r6(punkIndex);
            updateOfferSellerOnInsertOfferPunkForSaleAction_r46(seller,punkIndex);
            updateOfferMinValueOnInsertOfferPunkForSaleAction_r36(punkIndex,minSalePriceInWei);
            updatePunksOfferedForSaleOnInsertOfferPunkForSaleAction_r71(punkIndex);
            emit OfferPunkForSaleAction(seller,punkIndex,minSalePriceInWei);
            return true;
          }
        }
      }
      return false;
  }
  function updateOfferMinValueOnInsertAcceptBidAction_r72(uint punkIndex) private    {
      offerMinValue[punkIndex] = OfferMinValueTuple(0,true);
  }
  function updateBidValueOnInsertBuyPunkAction_r80(uint punkIndex) private    {
      bidValue[punkIndex] = BidValueTuple(0,true);
  }
  function updateTotalPendingDebitOnInsertPendingDebit_r62(address p,uint n) private    {
      int delta2 = int(n);
      updatePendingWithdrawalsOnIncrementTotalPendingDebit_r26(p,delta2);
      totalPendingDebit[p].n += n;
  }
  function updateTouchedOfferOnInsertAcceptBidAction_r21(uint punkIndex) private    {
      updateOfferSellerOnInsertTouchedOffer_r60(punkIndex);
      updatePunksOfferedForSaleOnInsertTouchedOffer_r52(punkIndex);
      updateOfferMinValueOnInsertTouchedOffer_r56(punkIndex);
  }
  function updateEnterBidActionOnInsertRecv_enterBidForPunk_r14(uint punkIndex) private   returns (bool) {
      address bidder = msg.sender;
      uint paid = msg.value;
      if(true==allPunksAssigned.b) {
        uint existing = bidValue[punkIndex].n;
        address ownerOfPunk = punkIndexToAddress[punkIndex].o;
        if(true==punkHasBid[punkIndex].b) {
          if(bidder!=address(0) && punkIndex<10000 && ownerOfPunk!=bidder && paid>existing) {
            updateTouchedBidOnInsertEnterBidAction_r66(punkIndex);
            updateBidValueOnInsertEnterBidAction_r29(punkIndex,paid);
            updatePunkHasBidOnInsertEnterBidAction_r32(punkIndex);
            updateBidBidderOnInsertEnterBidAction_r23(punkIndex,bidder);
            emit EnterBidAction(punkIndex,bidder,paid);
            return true;
          }
        }
      }
      return false;
  }
  function updatePunksOfferedForSaleOnInsertTouchedOffer_r52(uint punkIndex) private    {
      punksOfferedForSale[punkIndex] = PunksOfferedForSaleTuple(false,true);
  }
  function updatePendingWithdrawalsOnInsertTotalPendingCredit_r26(address p,uint c) private    {
      TotalPendingCreditTuple memory toDelete = totalPendingCredit[p];
      if(toDelete._valid==true) {
        updatePendingWithdrawalsOnDeleteTotalPendingCredit_r26(p,toDelete.n);
      }
      uint d = totalPendingDebit[p].n;
      if(p==initialPending.p) {
        uint i = initialPending.n;
        uint s = (i+c)-d;
        pendingWithdrawals[p] = PendingWithdrawalsTuple(s,true);
      }
  }
  function updateAcceptBidActionOnInsertRecv_acceptBidForPunk_r55(uint punkIndex,uint minPrice) private   returns (bool) {
      if(true==allPunksAssigned.b) {
        address seller = msg.sender;
        uint paid = bidValue[punkIndex].n;
        address bidder = bidBidder[punkIndex].bidder;
        if(true==punkHasBid[punkIndex].b) {
          if(seller==punkIndexToAddress[punkIndex].o) {
            if(seller!=address(0) && bidder!=address(0) && punkIndex<10000 && paid>=minPrice) {
              updateTouchedOfferOnInsertAcceptBidAction_r21(punkIndex);
              updateOfferMinValueOnInsertAcceptBidAction_r72(punkIndex);
              updateBidBidderOnInsertAcceptBidAction_r86(punkIndex);
              updatePunkHasBidOnInsertAcceptBidAction_r8(punkIndex);
              updateTouchedBidOnInsertAcceptBidAction_r74(punkIndex);
              updateOfferSellerOnInsertAcceptBidAction_r27(punkIndex);
              updatePunkIndexToAddressOnInsertAcceptBidAction_r12(bidder,punkIndex);
              updateBidValueOnInsertAcceptBidAction_r4(punkIndex);
              updatePunksOfferedForSaleOnInsertAcceptBidAction_r65(punkIndex);
              emit AcceptBidAction(seller,bidder,punkIndex,paid);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updatePunkHasBidOnInsertWithdrawBidAction_r34(uint punkIndex) private    {
      punkHasBid[punkIndex] = PunkHasBidTuple(false,true);
  }
  function updateBidBidderOnInsertTouchedBid_r1(uint punkIndex) private    {
      bidBidder[punkIndex] = BidBidderTuple(address(0),true);
  }
  function updateTouchedOfferOnInsertPunkNoLongerForSaleAction_r75(uint punkIndex) private    {
      updateOfferSellerOnInsertTouchedOffer_r60(punkIndex);
      updatePunksOfferedForSaleOnInsertTouchedOffer_r52(punkIndex);
      updateOfferMinValueOnInsertTouchedOffer_r56(punkIndex);
  }
  function updateBidBidderOnInsertEnterBidAction_r23(uint punkIndex,address bidder) private    {
      bidBidder[punkIndex] = BidBidderTuple(bidder,true);
  }
  function updateBidBidderOnInsertBuyPunkAction_r38(uint punkIndex) private    {
      bidBidder[punkIndex] = BidBidderTuple(address(0),true);
  }
  function updateAllPunksAssignedOnInsertAllInitialOwnersAssignedAction_r7() private    {
      allPunksAssigned = AllPunksAssignedTuple(true,true);
  }
  function updatePunksOfferedForSaleOnInsertPunkNoLongerForSaleAction_r57(uint punkIndex) private    {
      punksOfferedForSale[punkIndex] = PunksOfferedForSaleTuple(false,true);
  }
  function updateGetPunkActionOnInsertRecv_getPunk_r53(uint punkIndex) private   returns (bool) {
      if(true==allPunksAssigned.b) {
        address s = msg.sender;
        if(s!=address(0) && punkIndex<10000) {
          updateTouchedOfferOnInsertGetPunkAction_r84(punkIndex);
          updateTouchedBidOnInsertGetPunkAction_r50(punkIndex);
          updatePunkIndexToAddressOnInsertGetPunkAction_r47(s,punkIndex);
          emit GetPunkAction(s,punkIndex);
          return true;
        }
      }
      return false;
  }
  function updateTouchedBidOnInsertAcceptBidAction_r74(uint punkIndex) private    {
      updateBidBidderOnInsertTouchedBid_r1(punkIndex);
      updatePunkHasBidOnInsertTouchedBid_r76(punkIndex);
      updateBidValueOnInsertTouchedBid_r22(punkIndex);
  }
  function updateBidBidderOnInsertAcceptBidAction_r86(uint punkIndex) private    {
      bidBidder[punkIndex] = BidBidderTuple(address(0),true);
  }
  function updateOfferSellerOnInsertOfferPunkForSaleAction_r46(address seller,uint punkIndex) private    {
      offerSeller[punkIndex] = OfferSellerTuple(seller,true);
  }
  function updateOfferMinValueOnInsertBuyPunkAction_r59(uint punkIndex) private    {
      offerMinValue[punkIndex] = OfferMinValueTuple(0,true);
  }
  function updateTransferPunkActionOnInsertRecv_transferPunk_r10(address to,uint punkIndex) private   returns (bool) {
      if(true==allPunksAssigned.b) {
        address from = msg.sender;
        if(from==punkIndexToAddress[punkIndex].o) {
          if(from!=address(0) && to!=address(0) && punkIndex<10000) {
            updatePunkIndexToAddressOnInsertTransferPunkAction_r24(to,punkIndex);
            updateOfferSellerOnInsertTransferPunkAction_r13(punkIndex);
            updateOfferMinValueOnInsertTransferPunkAction_r54(punkIndex);
            updateTouchedOfferOnInsertTransferPunkAction_r48(punkIndex);
            updatePunksOfferedForSaleOnInsertTransferPunkAction_r9(punkIndex);
            emit TransferPunkAction(from,to,punkIndex);
            return true;
          }
        }
      }
      return false;
  }
  function updateAllPunksAssignedOnInsertConstructor_r64() private    {
      allPunksAssigned = AllPunksAssignedTuple(false,true);
  }
  function updateTouchedBidOnInsertWithdrawBidAction_r19(uint punkIndex) private    {
      updateBidBidderOnInsertTouchedBid_r1(punkIndex);
      updatePunkHasBidOnInsertTouchedBid_r76(punkIndex);
      updateBidValueOnInsertTouchedBid_r22(punkIndex);
  }
  function updateOfferSellerOnInsertBuyPunkAction_r44(uint punkIndex) private    {
      offerSeller[punkIndex] = OfferSellerTuple(address(0),true);
  }
  function updateOfferMinValueOnInsertOfferPunkForSaleAction_r36(uint punkIndex,uint minValue) private    {
      offerMinValue[punkIndex] = OfferMinValueTuple(minValue,true);
  }
  function updateOfferSellerOnInsertTransferPunkAction_r13(uint punkIndex) private    {
      offerSeller[punkIndex] = OfferSellerTuple(address(0),true);
  }
  function updatePendingWithdrawalsOnDeleteTotalPendingDebit_r26(address p,uint d) private    {
      uint c = totalPendingCredit[p].n;
      if(p==initialPending.p) {
        uint i = initialPending.n;
        uint s = (i+c)-d;
        if(s==pendingWithdrawals[p].n) {
          pendingWithdrawals[p] = PendingWithdrawalsTuple(0,false);
        }
      }
  }
  function updateInitialPendingOnInsertPendingCredit_r51(address p) private    {
      updatePendingWithdrawalsOnInsertInitialPending_r26(p,uint(0));
      initialPending = InitialPendingTuple(p,0,true);
  }
  function updatePunksOfferedForSaleOnInsertBuyPunkAction_r85(uint punkIndex) private    {
      punksOfferedForSale[punkIndex] = PunksOfferedForSaleTuple(false,true);
  }
  function updateTouchedOfferOnInsertBuyPunkAction_r41(uint punkIndex) private    {
      updateOfferSellerOnInsertTouchedOffer_r60(punkIndex);
      updatePunksOfferedForSaleOnInsertTouchedOffer_r52(punkIndex);
      updateOfferMinValueOnInsertTouchedOffer_r56(punkIndex);
  }
  function updateOfferSellerOnInsertAcceptBidAction_r27(uint punkIndex) private    {
      offerSeller[punkIndex] = OfferSellerTuple(address(0),true);
  }
  function updateTouchedBidOnInsertBuyPunkAction_r77(uint punkIndex) private    {
      updateBidBidderOnInsertTouchedBid_r1(punkIndex);
      updatePunkHasBidOnInsertTouchedBid_r76(punkIndex);
      updateBidValueOnInsertTouchedBid_r22(punkIndex);
  }
  function updatePunksOfferedForSaleOnInsertTransferPunkAction_r9(uint punkIndex) private    {
      punksOfferedForSale[punkIndex] = PunksOfferedForSaleTuple(false,true);
  }
  function updateInitialPendingOnInsertPendingDebit_r0(address p) private    {
      updatePendingWithdrawalsOnInsertInitialPending_r26(p,uint(0));
      initialPending = InitialPendingTuple(p,0,true);
  }
  function updateTouchedOfferOnInsertOfferPunkForSaleAction_r6(uint punkIndex) private    {
      updateOfferSellerOnInsertTouchedOffer_r60(punkIndex);
      updatePunksOfferedForSaleOnInsertTouchedOffer_r52(punkIndex);
      updateOfferMinValueOnInsertTouchedOffer_r56(punkIndex);
  }
  function updateWithdrawBidActionOnInsertRecv_withdrawBidForPunk_r49(uint punkIndex) private   returns (bool) {
      address bidder = msg.sender;
      if(true==allPunksAssigned.b) {
        uint paid = bidValue[punkIndex].n;
        if(bidder==bidBidder[punkIndex].bidder) {
          if(true==punkHasBid[punkIndex].b) {
            if(bidder!=address(0) && punkIndex<10000) {
              updateTouchedBidOnInsertWithdrawBidAction_r19(punkIndex);
              updateBidBidderOnInsertWithdrawBidAction_r2(punkIndex);
              updatePunkHasBidOnInsertWithdrawBidAction_r34(punkIndex);
              updateSendOnInsertWithdrawBidAction_r15(bidder,paid);
              updateBidValueOnInsertWithdrawBidAction_r43(punkIndex);
              emit WithdrawBidAction(bidder,punkIndex,paid);
              return true;
            }
          }
        }
      }
      return false;
  }
  function updatePunksOfferedForSaleOnInsertOfferPunkForSaleAction_r71(uint punkIndex) private    {
      punksOfferedForSale[punkIndex] = PunksOfferedForSaleTuple(true,true);
  }
  function updatePendingWithdrawalsOnIncrementTotalPendingDebit_r26(address p,int d) private    {
      int _delta = int(d);
      uint newValue = updateuintByint(totalPendingDebit[p].n,_delta);
      updatePendingWithdrawalsOnInsertTotalPendingDebit_r26(p,newValue);
  }
  function updateOfferSellerOnInsertTouchedOffer_r60(uint punkIndex) private    {
      offerSeller[punkIndex] = OfferSellerTuple(address(0),true);
  }
}