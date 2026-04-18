contract Erc721 {
  struct TotalInTuple {
    uint n;
    bool _valid;
  }
  struct TotalOutTuple {
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
  struct IsApprovedForAllTuple {
    bool approved;
    bool _valid;
  }
  struct GetApprovedTuple {
    address approved;
    bool _valid;
  }
  struct TotalBurnTuple {
    uint n;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct InitialApprovalTuple {
    uint tokenId;
    address approved;
    bool _valid;
  }
  struct TotalMintTuple {
    uint n;
    bool _valid;
  }
  struct TotalInitialTuple {
    uint n;
    bool _valid;
  }
  struct OwnerOfTuple {
    address o;
    bool _valid;
  }
  mapping(address=>TotalInTuple) totalIn;
  mapping(address=>TotalOutTuple) totalOut;
  OwnerTuple owner;
  InitialApprovalTuple initialApproval;
  mapping(uint=>OwnerOfTuple) ownerOf;
  InitialBalanceTuple initialBalance;
  mapping(address=>BalanceOfTuple) balanceOf;
  mapping(address=>mapping(address=>IsApprovedForAllTuple)) isApprovedForAll;
  mapping(uint=>GetApprovedTuple) getApproved;
  mapping(address=>TotalBurnTuple) totalBurn;
  mapping(address=>TotalMintTuple) totalMint;
  mapping(address=>TotalInitialTuple) totalInitial;
  event TransferFrom(address from,address to,address operator,uint tokenId);
  event Burn(address from,address operator,uint tokenId);
  event Mint(address to,uint tokenId);
  event ApproveAction(address o,address approved,uint tokenId);
  event SetApprovalForAllAction(address o,address operator,bool approved);
  constructor() public {
    updateOwnerOnInsertConstructor_r10();
  }
  function mint(address to,uint tokenId) public    {
      bool r6 = updateMintOnInsertRecv_mint_r6(to,tokenId);
      if(r6==false) {
        revert("Rule condition failed");
      }
  }
  function burn(uint tokenId) public    {
      bool r20 = updateBurnOnInsertRecv_burn_r20(tokenId);
      bool r3 = updateBurnOnInsertRecv_burn_r3(tokenId);
      if(r20==false && r3==false) {
        revert("Rule condition failed");
      }
  }
  function approve(address approved,uint tokenId) public    {
      bool r13 = updateApproveActionOnInsertRecv_approve_r13(approved,tokenId);
      if(r13==false) {
        revert("Rule condition failed");
      }
  }
  function getBalanceOf(address p) public view  returns (uint) {
      uint n = balanceOf[p].n;
      return n;
  }
  function getIsApprovedForAll(address o,address operator) public view  returns (bool) {
      bool approved = isApprovedForAll[o][operator].approved;
      return approved;
  }
  function getOwnerOf(uint tokenId) public view  returns (address) {
      address o = ownerOf[tokenId].o;
      return o;
  }
  function setApprovalForAll(address operator,bool approved) public    {
      bool r8 = updateSetApprovalForAllActionOnInsertRecv_setApprovalForAll_r8(operator,approved);
      if(r8==false) {
        revert("Rule condition failed");
      }
  }
  function getGetApproved(uint tokenId) public view  returns (address) {
      address approved = getApproved[tokenId].approved;
      return approved;
  }
  function transferFrom(address from,address to,uint tokenId) public    {
      bool r26 = updateTransferFromOnInsertRecv_transferFrom_r26(from,to,tokenId);
      bool r23 = updateTransferFromOnInsertRecv_transferFrom_r23(from,to,tokenId);
      bool r27 = updateTransferFromOnInsertRecv_transferFrom_r27(from,to,tokenId);
      if(r26==false && r23==false && r27==false) {
        revert("Rule condition failed");
      }
  }
  function updateInitialApprovalOnInsertMint_r4(uint tokenId) private    {
      updateGetApprovedOnInsertInitialApproval_r22(tokenId);
      initialApproval = InitialApprovalTuple(tokenId,address(0),true);
  }
  function updateGetApprovedOnInsertApproveAction_r9(address approved,uint tokenId) private    {
      getApproved[tokenId] = GetApprovedTuple(approved,true);
  }
  function updateInitialBalanceOnInsertMint_r17(address p) private    {
      updateTotalInitialOnInsertInitialBalance_r21(p,uint(0));
      initialBalance = InitialBalanceTuple(p,0,true);
  }
  function updateSetApprovalForAllActionOnInsertRecv_setApprovalForAll_r8(address operator,bool approved) private   returns (bool) {
      address o = msg.sender;
      if(o!=address(0) && operator!=address(0) && operator!=o) {
        updateIsApprovedForAllOnInsertSetApprovalForAllAction_r28(o,operator,approved);
        emit SetApprovalForAllAction(o,operator,approved);
        return true;
      }
      return false;
  }
  function updateInitialApprovalOnInsertTransferFrom_r29(uint tokenId) private    {
      updateGetApprovedOnInsertInitialApproval_r22(tokenId);
      initialApproval = InitialApprovalTuple(tokenId,address(0),true);
  }
  function updateBalanceOfOnIncrementTotalMint_r18(address p,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalMint[p].n,_delta);
      updateBalanceOfOnInsertTotalMint_r18(p,newValue);
  }
  function updateBalanceOfOnIncrementTotalInitial_r18(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(totalInitial[p].n,_delta);
      updateBalanceOfOnInsertTotalInitial_r18(p,newValue);
  }
  function updateBalanceOfOnIncrementTotalIn_r18(address p,int ti) private    {
      int _delta = int(ti);
      uint newValue = updateuintByint(totalIn[p].n,_delta);
      updateBalanceOfOnInsertTotalIn_r18(p,newValue);
  }
  function updateApproveActionOnInsertRecv_approve_r13(address approved,uint tokenId) private   returns (bool) {
      address o = msg.sender;
      if(o==ownerOf[tokenId].o) {
        if(o!=address(0) && approved!=o) {
          updateInitialApprovalOnInsertApproveAction_r11(tokenId);
          updateGetApprovedOnInsertApproveAction_r9(approved,tokenId);
          emit ApproveAction(o,approved,tokenId);
          return true;
        }
      }
      return false;
  }
  function updateOwnerOfOnInsertMint_r0(address to,uint tokenId) private    {
      ownerOf[tokenId] = OwnerOfTuple(to,true);
  }
  function updateTotalOutOnInsertTransferFrom_r31(address p,address _to1,address _operator2,uint _tokenId3) private    {
      int delta0 = int(1);
      updateBalanceOfOnIncrementTotalOut_r18(p,delta0);
      totalOut[p].n += 1;
  }
  function updateBalanceOfOnInsertTotalBurn_r18(address p,uint b) private    {
      TotalBurnTuple memory toDelete = totalBurn[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalBurn_r18(p,toDelete.n);
      }
      uint m = totalMint[p].n;
      uint ti = totalIn[p].n;
      uint i = totalInitial[p].n;
      uint o = totalOut[p].n;
      uint s = (((i+m)+ti)-b)-o;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateMintOnInsertRecv_mint_r6(address to,uint tokenId) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(to!=address(0)) {
          updateOwnerOfOnInsertMint_r0(to,tokenId);
          updateInitialBalanceOnInsertMint_r17(to);
          updateInitialApprovalOnInsertMint_r4(tokenId);
          updateTotalMintOnInsertMint_r30(to,tokenId);
          emit Mint(to,tokenId);
          return true;
        }
      }
      return false;
  }
  function updateOwnerOfOnInsertBurn_r1(uint tokenId) private    {
      ownerOf[tokenId] = OwnerOfTuple(address(0),true);
  }
  function updateInitialBalanceOnInsertBurn_r25(address p) private    {
      updateTotalInitialOnInsertInitialBalance_r21(p,uint(0));
      initialBalance = InitialBalanceTuple(p,0,true);
  }
  function updateOwnerOnInsertConstructor_r10() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateBalanceOfOnInsertTotalOut_r18(address p,uint o) private    {
      TotalOutTuple memory toDelete = totalOut[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalOut_r18(p,toDelete.n);
      }
      uint b = totalBurn[p].n;
      uint m = totalMint[p].n;
      uint ti = totalIn[p].n;
      uint i = totalInitial[p].n;
      uint s = (((i+m)+ti)-b)-o;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateBalanceOfOnInsertTotalIn_r18(address p,uint ti) private    {
      TotalInTuple memory toDelete = totalIn[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalIn_r18(p,toDelete.n);
      }
      uint b = totalBurn[p].n;
      uint m = totalMint[p].n;
      uint i = totalInitial[p].n;
      uint o = totalOut[p].n;
      uint s = (((i+m)+ti)-b)-o;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateBalanceOfOnIncrementTotalBurn_r18(address p,int b) private    {
      int _delta = int(b);
      uint newValue = updateuintByint(totalBurn[p].n,_delta);
      updateBalanceOfOnInsertTotalBurn_r18(p,newValue);
  }
  function updateBalanceOfOnDeleteTotalIn_r18(address p,uint ti) private    {
      uint b = totalBurn[p].n;
      uint m = totalMint[p].n;
      uint i = totalInitial[p].n;
      uint o = totalOut[p].n;
      uint s = (((i+m)+ti)-b)-o;
      if(s==balanceOf[p].n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateGetApprovedOnInsertInitialApproval_r22(uint tokenId) private    {
      getApproved[tokenId] = GetApprovedTuple(address(0),true);
  }
  function updateBurnOnInsertRecv_burn_r20(uint tokenId) private   returns (bool) {
      address s = msg.sender;
      if(s==getApproved[tokenId].approved) {
        address from = ownerOf[tokenId].o;
        if(from!=address(0) && s!=address(0)) {
          updateInitialApprovalOnInsertBurn_r7(tokenId);
          updateGetApprovedOnInsertBurn_r16(tokenId);
          updateInitialBalanceOnInsertBurn_r25(from);
          updateOwnerOfOnInsertBurn_r1(tokenId);
          updateTotalBurnOnInsertBurn_r14(from,s,tokenId);
          emit Burn(from,s,tokenId);
          return true;
        }
      }
      return false;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r27(address from,address to,uint tokenId) private   returns (bool) {
      if(from==msg.sender) {
        if(from==ownerOf[tokenId].o) {
          if(from!=address(0) && to!=address(0)) {
            updateOwnerOfOnInsertTransferFrom_r19(to,tokenId);
            updateInitialBalanceOnInsertTransferFrom_r24(from);
            updateTotalInOnInsertTransferFrom_r5(from,to,from,tokenId);
            updateInitialBalanceOnInsertTransferFrom_r2(to);
            updateInitialApprovalOnInsertTransferFrom_r29(tokenId);
            updateGetApprovedOnInsertTransferFrom_r12(tokenId);
            updateTotalOutOnInsertTransferFrom_r31(from,to,from,tokenId);
            emit TransferFrom(from,to,from,tokenId);
            return true;
          }
        }
      }
      return false;
  }
  function updateInitialApprovalOnInsertBurn_r7(uint tokenId) private    {
      updateGetApprovedOnInsertInitialApproval_r22(tokenId);
      initialApproval = InitialApprovalTuple(tokenId,address(0),true);
  }
  function updateOwnerOfOnInsertTransferFrom_r19(address to,uint tokenId) private    {
      ownerOf[tokenId] = OwnerOfTuple(to,true);
  }
  function updateBalanceOfOnDeleteTotalOut_r18(address p,uint o) private    {
      uint b = totalBurn[p].n;
      uint m = totalMint[p].n;
      uint ti = totalIn[p].n;
      uint i = totalInitial[p].n;
      uint s = (((i+m)+ti)-b)-o;
      if(s==balanceOf[p].n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateBalanceOfOnIncrementTotalOut_r18(address p,int o) private    {
      int _delta = int(o);
      uint newValue = updateuintByint(totalOut[p].n,_delta);
      updateBalanceOfOnInsertTotalOut_r18(p,newValue);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateBalanceOfOnDeleteTotalBurn_r18(address p,uint b) private    {
      uint m = totalMint[p].n;
      uint ti = totalIn[p].n;
      uint i = totalInitial[p].n;
      uint o = totalOut[p].n;
      uint s = (((i+m)+ti)-b)-o;
      if(s==balanceOf[p].n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateTotalInOnInsertTransferFrom_r5(address _from0,address p,address _operator2,uint _tokenId3) private    {
      int delta1 = int(1);
      updateBalanceOfOnIncrementTotalIn_r18(p,delta1);
      totalIn[p].n += 1;
  }
  function updateIsApprovedForAllOnInsertSetApprovalForAllAction_r28(address o,address operator,bool approved) private    {
      isApprovedForAll[o][operator] = IsApprovedForAllTuple(approved,true);
  }
  function updateInitialApprovalOnInsertApproveAction_r11(uint tokenId) private    {
      updateGetApprovedOnInsertInitialApproval_r22(tokenId);
      initialApproval = InitialApprovalTuple(tokenId,address(0),true);
  }
  function updateGetApprovedOnInsertTransferFrom_r12(uint tokenId) private    {
      getApproved[tokenId] = GetApprovedTuple(address(0),true);
  }
  function updateBalanceOfOnDeleteTotalMint_r18(address p,uint m) private    {
      uint b = totalBurn[p].n;
      uint ti = totalIn[p].n;
      uint i = totalInitial[p].n;
      uint o = totalOut[p].n;
      uint s = (((i+m)+ti)-b)-o;
      if(s==balanceOf[p].n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateInitialBalanceOnInsertTransferFrom_r24(address p) private    {
      updateTotalInitialOnInsertInitialBalance_r21(p,uint(0));
      initialBalance = InitialBalanceTuple(p,0,true);
  }
  function updateInitialBalanceOnInsertTransferFrom_r2(address p) private    {
      updateTotalInitialOnInsertInitialBalance_r21(p,uint(0));
      initialBalance = InitialBalanceTuple(p,0,true);
  }
  function updateBalanceOfOnInsertTotalMint_r18(address p,uint m) private    {
      TotalMintTuple memory toDelete = totalMint[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalMint_r18(p,toDelete.n);
      }
      uint b = totalBurn[p].n;
      uint ti = totalIn[p].n;
      uint i = totalInitial[p].n;
      uint o = totalOut[p].n;
      uint s = (((i+m)+ti)-b)-o;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateBurnOnInsertRecv_burn_r3(uint tokenId) private   returns (bool) {
      address from = msg.sender;
      if(from==ownerOf[tokenId].o) {
        if(from!=address(0)) {
          updateInitialApprovalOnInsertBurn_r7(tokenId);
          updateGetApprovedOnInsertBurn_r16(tokenId);
          updateInitialBalanceOnInsertBurn_r25(from);
          updateTotalBurnOnInsertBurn_r14(from,from,tokenId);
          updateOwnerOfOnInsertBurn_r1(tokenId);
          emit Burn(from,from,tokenId);
          return true;
        }
      }
      return false;
  }
  function updateBalanceOfOnDeleteTotalInitial_r18(address p,uint i) private    {
      uint b = totalBurn[p].n;
      uint m = totalMint[p].n;
      uint ti = totalIn[p].n;
      uint o = totalOut[p].n;
      uint s = (((i+m)+ti)-b)-o;
      if(s==balanceOf[p].n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateTransferFromOnInsertRecv_transferFrom_r26(address from,address to,uint tokenId) private   returns (bool) {
      address s = msg.sender;
      if(s==getApproved[tokenId].approved) {
        if(from==ownerOf[tokenId].o) {
          if(from!=address(0) && to!=address(0) && s!=address(0)) {
            updateGetApprovedOnInsertTransferFrom_r12(tokenId);
            updateOwnerOfOnInsertTransferFrom_r19(to,tokenId);
            updateTotalOutOnInsertTransferFrom_r31(from,to,s,tokenId);
            updateInitialBalanceOnInsertTransferFrom_r24(from);
            updateTotalInOnInsertTransferFrom_r5(from,to,s,tokenId);
            updateInitialBalanceOnInsertTransferFrom_r2(to);
            updateInitialApprovalOnInsertTransferFrom_r29(tokenId);
            emit TransferFrom(from,to,s,tokenId);
            return true;
          }
        }
      }
      return false;
  }
  function updateBalanceOfOnInsertTotalInitial_r18(address p,uint i) private    {
      TotalInitialTuple memory toDelete = totalInitial[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalInitial_r18(p,toDelete.n);
      }
      uint b = totalBurn[p].n;
      uint m = totalMint[p].n;
      uint ti = totalIn[p].n;
      uint o = totalOut[p].n;
      uint s = (((i+m)+ti)-b)-o;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateTotalInitialOnInsertInitialBalance_r21(address p,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalInitial_r18(p,delta0);
      totalInitial[p].n += n;
  }
  function updateTotalBurnOnInsertBurn_r14(address p,address _operator1,uint _tokenId2) private    {
      int delta1 = int(1);
      updateBalanceOfOnIncrementTotalBurn_r18(p,delta1);
      totalBurn[p].n += 1;
  }
  function updateGetApprovedOnInsertBurn_r16(uint tokenId) private    {
      getApproved[tokenId] = GetApprovedTuple(address(0),true);
  }
  function updateTransferFromOnInsertRecv_transferFrom_r23(address from,address to,uint tokenId) private   returns (bool) {
      address s = msg.sender;
      if(true==isApprovedForAll[from][s].approved) {
        if(from==ownerOf[tokenId].o) {
          if(from!=address(0) && to!=address(0) && s!=address(0)) {
            updateGetApprovedOnInsertTransferFrom_r12(tokenId);
            updateOwnerOfOnInsertTransferFrom_r19(to,tokenId);
            updateTotalOutOnInsertTransferFrom_r31(from,to,s,tokenId);
            updateInitialBalanceOnInsertTransferFrom_r24(from);
            updateTotalInOnInsertTransferFrom_r5(from,to,s,tokenId);
            updateInitialBalanceOnInsertTransferFrom_r2(to);
            updateInitialApprovalOnInsertTransferFrom_r29(tokenId);
            emit TransferFrom(from,to,s,tokenId);
            return true;
          }
        }
      }
      return false;
  }
  function updateTotalMintOnInsertMint_r30(address p,uint _tokenId1) private    {
      int delta0 = int(1);
      updateBalanceOfOnIncrementTotalMint_r18(p,delta0);
      totalMint[p].n += 1;
  }
}