contract Erc1155 {
  struct TotalSupplyByIdTuple {
    uint n;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct TotalInTuple {
    uint n;
    bool _valid;
  }
  struct InitialBalanceTuple {
    address p;
    uint id;
    uint n;
    bool _valid;
  }
  struct BurnTotalByIdTuple {
    uint n;
    bool _valid;
  }
  struct TotalBurnTuple {
    uint n;
    bool _valid;
  }
  struct TotalOutTuple {
    uint n;
    bool _valid;
  }
  struct TotalInitialTuple {
    uint n;
    bool _valid;
  }
  struct BalanceOfTuple {
    uint n;
    bool _valid;
  }
  struct IssueTotalByIdTuple {
    uint n;
    bool _valid;
  }
  struct TotalMintTuple {
    uint n;
    bool _valid;
  }
  struct IsApprovedForAllTuple {
    bool approved;
    bool _valid;
  }
  mapping(uint=>TotalSupplyByIdTuple) totalSupplyById;
  OwnerTuple owner;
  mapping(address=>mapping(uint=>BalanceOfTuple)) balanceOf;
  mapping(address=>mapping(uint=>TotalInTuple)) totalIn;
  mapping(address=>mapping(address=>IsApprovedForAllTuple)) isApprovedForAll;
  InitialBalanceTuple initialBalance;
  mapping(uint=>BurnTotalByIdTuple) burnTotalById;
  mapping(address=>mapping(uint=>TotalBurnTuple)) totalBurn;
  mapping(address=>mapping(uint=>TotalOutTuple)) totalOut;
  mapping(address=>mapping(uint=>TotalInitialTuple)) totalInitial;
  mapping(uint=>IssueTotalByIdTuple) issueTotalById;
  mapping(address=>mapping(uint=>TotalMintTuple)) totalMint;
  event Mint(address to,uint id,uint value);
  event Burn(address from,address operator,uint id,uint value);
  event SetApprovalForAllAction(address owner,address operator,bool approved);
  event TransferSingle(address from,address to,address operator,uint id,uint value);
  constructor() public {
    updateOwnerOnInsertConstructor_r20();
  }
  function mint(address to,uint id,uint value) public    {
      bool r16 = updateMintOnInsertRecv_mint_r16(to,id,value);
      if(r16==false) {
        revert("Rule condition failed");
      }
  }
  function setApprovalForAll(address operator,bool approved) public    {
      bool r13 = updateSetApprovalForAllActionOnInsertRecv_setApprovalForAll_r13(operator,approved);
      if(r13==false) {
        revert("Rule condition failed");
      }
  }
  function transferFrom(address from,address to,uint id,uint value) public    {
      bool r14 = updateTransferSingleOnInsertRecv_transferFrom_r14(from,to,id,value);
      bool r5 = updateTransferSingleOnInsertRecv_transferFrom_r5(from,to,id,value);
      if(r14==false && r5==false) {
        revert("Rule condition failed");
      }
  }
  function getIsApprovedForAll(address owner,address operator) public view  returns (bool) {
      bool approved = isApprovedForAll[owner][operator].approved;
      return approved;
  }
  function burn(address from,uint id,uint value) public    {
      bool r6 = updateBurnOnInsertRecv_burn_r6(from,id,value);
      bool r1 = updateBurnOnInsertRecv_burn_r1(from,id,value);
      if(r6==false && r1==false) {
        revert("Rule condition failed");
      }
  }
  function getTotalSupplyById(uint id) public view  returns (uint) {
      uint n = totalSupplyById[id].n;
      return n;
  }
  function getBalanceOf(address p,uint id) public view  returns (uint) {
      uint n = balanceOf[p][id].n;
      return n;
  }
  function updateInitialBalanceOnInsertBurn_r9(address p,uint id) private    {
      updateTotalInitialOnInsertInitialBalance_r11(p,id,uint(0));
      initialBalance = InitialBalanceTuple(p,id,0,true);
  }
  function updateInitialBalanceOnInsertMint_r18(address p,uint id) private    {
      updateTotalInitialOnInsertInitialBalance_r11(p,id,uint(0));
      initialBalance = InitialBalanceTuple(p,id,0,true);
  }
  function updateBalanceOfOnDeleteTotalBurn_r8(address p,uint id,uint b) private    {
      uint m = totalMint[p][id].n;
      uint ti = totalIn[p][id].n;
      uint to = totalOut[p][id].n;
      uint i = totalInitial[p][id].n;
      uint s = (((i+m)+ti)-b)-to;
      if(s==balanceOf[p][id].n) {
        balanceOf[p][id] = BalanceOfTuple(0,false);
      }
  }
  function updateInitialBalanceOnInsertTransferSingle_r19(address p,uint id) private    {
      updateTotalInitialOnInsertInitialBalance_r11(p,id,uint(0));
      initialBalance = InitialBalanceTuple(p,id,0,true);
  }
  function updateTotalBurnOnInsertBurn_r21(address p,uint id,uint n) private    {
      int delta2 = int(n);
      updateBalanceOfOnIncrementTotalBurn_r8(p,id,delta2);
      totalBurn[p][id].n += n;
  }
  function updateTotalInOnInsertTransferSingle_r0(address p,uint id,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalIn_r8(p,id,delta0);
      totalIn[p][id].n += n;
  }
  function updateBurnOnInsertRecv_burn_r6(address f,uint id,uint n) private   returns (bool) {
      if(f==msg.sender) {
        uint m = balanceOf[f][id].n;
        if(f!=address(0) && n>0 && m>=n) {
          updateBurnTotalByIdOnInsertBurn_r10(id,n);
          updateInitialBalanceOnInsertBurn_r9(f,id);
          updateTotalBurnOnInsertBurn_r21(f,id,n);
          emit Burn(f,f,id,n);
          return true;
        }
      }
      return false;
  }
  function updateOwnerOnInsertConstructor_r20() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateBalanceOfOnInsertTotalIn_r8(address p,uint id,uint ti) private    {
      TotalInTuple memory toDelete = totalIn[p][id];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalIn_r8(p,id,toDelete.n);
      }
      uint m = totalMint[p][id].n;
      uint to = totalOut[p][id].n;
      uint b = totalBurn[p][id].n;
      uint i = totalInitial[p][id].n;
      uint s = (((i+m)+ti)-b)-to;
      balanceOf[p][id] = BalanceOfTuple(s,true);
  }
  function updateBalanceOfOnInsertTotalInitial_r8(address p,uint id,uint i) private    {
      TotalInitialTuple memory toDelete = totalInitial[p][id];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalInitial_r8(p,id,toDelete.n);
      }
      uint m = totalMint[p][id].n;
      uint ti = totalIn[p][id].n;
      uint to = totalOut[p][id].n;
      uint b = totalBurn[p][id].n;
      uint s = (((i+m)+ti)-b)-to;
      balanceOf[p][id] = BalanceOfTuple(s,true);
  }
  function updateInitialBalanceOnInsertTransferSingle_r3(address p,uint id) private    {
      updateTotalInitialOnInsertInitialBalance_r11(p,id,uint(0));
      initialBalance = InitialBalanceTuple(p,id,0,true);
  }
  function updateBurnOnInsertRecv_burn_r1(address f,uint id,uint n) private   returns (bool) {
      address s = msg.sender;
      uint m = balanceOf[f][id].n;
      if(true==isApprovedForAll[f][s].approved) {
        if(f!=address(0) && s!=address(0) && n>0 && m>=n) {
          updateBurnTotalByIdOnInsertBurn_r10(id,n);
          updateInitialBalanceOnInsertBurn_r9(f,id);
          updateTotalBurnOnInsertBurn_r21(f,id,n);
          emit Burn(f,s,id,n);
          return true;
        }
      }
      return false;
  }
  function updateTotalSupplyByIdOnDeleteBurnTotalById_r15(uint id,uint b) private    {
      uint i = issueTotalById[id].n;
      uint n = i-b;
      if(n==totalSupplyById[id].n) {
        totalSupplyById[id] = TotalSupplyByIdTuple(0,false);
      }
  }
  function updateSetApprovalForAllActionOnInsertRecv_setApprovalForAll_r13(address s,bool b) private   returns (bool) {
      address o = msg.sender;
      if(o!=address(0) && s!=address(0) && o!=s) {
        updateIsApprovedForAllOnInsertSetApprovalForAllAction_r2(o,s,b);
        emit SetApprovalForAllAction(o,s,b);
        return true;
      }
      return false;
  }
  function updateTotalInitialOnInsertInitialBalance_r11(address p,uint id,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalInitial_r8(p,id,delta0);
      totalInitial[p][id].n += n;
  }
  function updateBalanceOfOnIncrementTotalBurn_r8(address p,uint id,int b) private    {
      int _delta = int(b);
      uint newValue = updateuintByint(totalBurn[p][id].n,_delta);
      updateBalanceOfOnInsertTotalBurn_r8(p,id,newValue);
  }
  function updateTotalSupplyByIdOnIncrementIssueTotalById_r15(uint id,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(issueTotalById[id].n,_delta);
      updateTotalSupplyByIdOnInsertIssueTotalById_r15(id,newValue);
  }
  function updateTotalSupplyByIdOnInsertBurnTotalById_r15(uint id,uint b) private    {
      BurnTotalByIdTuple memory toDelete = burnTotalById[id];
      if(toDelete._valid==true) {
        updateTotalSupplyByIdOnDeleteBurnTotalById_r15(id,toDelete.n);
      }
      uint i = issueTotalById[id].n;
      uint n = i-b;
      totalSupplyById[id] = TotalSupplyByIdTuple(n,true);
  }
  function updateBalanceOfOnIncrementTotalMint_r8(address p,uint id,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalMint[p][id].n,_delta);
      updateBalanceOfOnInsertTotalMint_r8(p,id,newValue);
  }
  function updateBalanceOfOnIncrementTotalOut_r8(address p,uint id,int to) private    {
      int _delta = int(to);
      uint newValue = updateuintByint(totalOut[p][id].n,_delta);
      updateBalanceOfOnInsertTotalOut_r8(p,id,newValue);
  }
  function updateBalanceOfOnDeleteTotalOut_r8(address p,uint id,uint to) private    {
      uint m = totalMint[p][id].n;
      uint ti = totalIn[p][id].n;
      uint b = totalBurn[p][id].n;
      uint i = totalInitial[p][id].n;
      uint s = (((i+m)+ti)-b)-to;
      if(s==balanceOf[p][id].n) {
        balanceOf[p][id] = BalanceOfTuple(0,false);
      }
  }
  function updateBalanceOfOnDeleteTotalMint_r8(address p,uint id,uint m) private    {
      uint ti = totalIn[p][id].n;
      uint to = totalOut[p][id].n;
      uint b = totalBurn[p][id].n;
      uint i = totalInitial[p][id].n;
      uint s = (((i+m)+ti)-b)-to;
      if(s==balanceOf[p][id].n) {
        balanceOf[p][id] = BalanceOfTuple(0,false);
      }
  }
  function updateTransferSingleOnInsertRecv_transferFrom_r5(address f,address t,uint id,uint n) private   returns (bool) {
      address s = msg.sender;
      uint m = balanceOf[f][id].n;
      if(true==isApprovedForAll[f][s].approved) {
        if(m>=n && n>0 && s!=address(0) && f!=address(0) && t!=address(0)) {
          updateTotalOutOnInsertTransferSingle_r17(f,id,n);
          updateTotalInOnInsertTransferSingle_r0(t,id,n);
          updateInitialBalanceOnInsertTransferSingle_r19(f,id);
          updateInitialBalanceOnInsertTransferSingle_r3(t,id);
          emit TransferSingle(f,t,s,id,n);
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
  function updateBalanceOfOnInsertTotalBurn_r8(address p,uint id,uint b) private    {
      TotalBurnTuple memory toDelete = totalBurn[p][id];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalBurn_r8(p,id,toDelete.n);
      }
      uint m = totalMint[p][id].n;
      uint ti = totalIn[p][id].n;
      uint to = totalOut[p][id].n;
      uint i = totalInitial[p][id].n;
      uint s = (((i+m)+ti)-b)-to;
      balanceOf[p][id] = BalanceOfTuple(s,true);
  }
  function updateBalanceOfOnInsertTotalOut_r8(address p,uint id,uint to) private    {
      TotalOutTuple memory toDelete = totalOut[p][id];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalOut_r8(p,id,toDelete.n);
      }
      uint m = totalMint[p][id].n;
      uint ti = totalIn[p][id].n;
      uint b = totalBurn[p][id].n;
      uint i = totalInitial[p][id].n;
      uint s = (((i+m)+ti)-b)-to;
      balanceOf[p][id] = BalanceOfTuple(s,true);
  }
  function updateIsApprovedForAllOnInsertSetApprovalForAllAction_r2(address o,address s,bool b) private    {
      isApprovedForAll[o][s] = IsApprovedForAllTuple(b,true);
  }
  function updateBalanceOfOnDeleteTotalIn_r8(address p,uint id,uint ti) private    {
      uint m = totalMint[p][id].n;
      uint to = totalOut[p][id].n;
      uint b = totalBurn[p][id].n;
      uint i = totalInitial[p][id].n;
      uint s = (((i+m)+ti)-b)-to;
      if(s==balanceOf[p][id].n) {
        balanceOf[p][id] = BalanceOfTuple(0,false);
      }
  }
  function updateTotalSupplyByIdOnIncrementBurnTotalById_r15(uint id,int b) private    {
      int _delta = int(b);
      uint newValue = updateuintByint(burnTotalById[id].n,_delta);
      updateTotalSupplyByIdOnInsertBurnTotalById_r15(id,newValue);
  }
  function updateTransferSingleOnInsertRecv_transferFrom_r14(address f,address t,uint id,uint n) private   returns (bool) {
      if(f==msg.sender) {
        uint m = balanceOf[f][id].n;
        if(f!=address(0) && t!=address(0) && n>0 && m>=n) {
          updateTotalOutOnInsertTransferSingle_r17(f,id,n);
          updateTotalInOnInsertTransferSingle_r0(t,id,n);
          updateInitialBalanceOnInsertTransferSingle_r19(f,id);
          updateInitialBalanceOnInsertTransferSingle_r3(t,id);
          emit TransferSingle(f,t,f,id,n);
          return true;
        }
      }
      return false;
  }
  function updateIssueTotalByIdOnInsertMint_r4(uint id,uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyByIdOnIncrementIssueTotalById_r15(id,delta0);
      issueTotalById[id].n += n;
  }
  function updateBalanceOfOnIncrementTotalInitial_r8(address p,uint id,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(totalInitial[p][id].n,_delta);
      updateBalanceOfOnInsertTotalInitial_r8(p,id,newValue);
  }
  function updateTotalSupplyByIdOnDeleteIssueTotalById_r15(uint id,uint i) private    {
      uint b = burnTotalById[id].n;
      uint n = i-b;
      if(n==totalSupplyById[id].n) {
        totalSupplyById[id] = TotalSupplyByIdTuple(0,false);
      }
  }
  function updateTotalMintOnInsertMint_r7(address p,uint id,uint n) private    {
      int delta1 = int(n);
      updateBalanceOfOnIncrementTotalMint_r8(p,id,delta1);
      totalMint[p][id].n += n;
  }
  function updateBalanceOfOnDeleteTotalInitial_r8(address p,uint id,uint i) private    {
      uint m = totalMint[p][id].n;
      uint ti = totalIn[p][id].n;
      uint to = totalOut[p][id].n;
      uint b = totalBurn[p][id].n;
      uint s = (((i+m)+ti)-b)-to;
      if(s==balanceOf[p][id].n) {
        balanceOf[p][id] = BalanceOfTuple(0,false);
      }
  }
  function updateBalanceOfOnIncrementTotalIn_r8(address p,uint id,int ti) private    {
      int _delta = int(ti);
      uint newValue = updateuintByint(totalIn[p][id].n,_delta);
      updateBalanceOfOnInsertTotalIn_r8(p,id,newValue);
  }
  function updateMintOnInsertRecv_mint_r16(address t,uint id,uint n) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        if(t!=address(0) && n>0) {
          updateIssueTotalByIdOnInsertMint_r4(id,n);
          updateInitialBalanceOnInsertMint_r18(t,id);
          updateTotalMintOnInsertMint_r7(t,id,n);
          emit Mint(t,id,n);
          return true;
        }
      }
      return false;
  }
  function updateBurnTotalByIdOnInsertBurn_r10(uint id,uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyByIdOnIncrementBurnTotalById_r15(id,delta0);
      burnTotalById[id].n += n;
  }
  function updateTotalOutOnInsertTransferSingle_r17(address p,uint id,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalOut_r8(p,id,delta0);
      totalOut[p][id].n += n;
  }
  function updateBalanceOfOnInsertTotalMint_r8(address p,uint id,uint m) private    {
      TotalMintTuple memory toDelete = totalMint[p][id];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalMint_r8(p,id,toDelete.n);
      }
      uint ti = totalIn[p][id].n;
      uint to = totalOut[p][id].n;
      uint b = totalBurn[p][id].n;
      uint i = totalInitial[p][id].n;
      uint s = (((i+m)+ti)-b)-to;
      balanceOf[p][id] = BalanceOfTuple(s,true);
  }
  function updateTotalSupplyByIdOnInsertIssueTotalById_r15(uint id,uint i) private    {
      IssueTotalByIdTuple memory toDelete = issueTotalById[id];
      if(toDelete._valid==true) {
        updateTotalSupplyByIdOnDeleteIssueTotalById_r15(id,toDelete.n);
      }
      uint b = burnTotalById[id].n;
      uint n = i-b;
      totalSupplyById[id] = TotalSupplyByIdTuple(n,true);
  }
}