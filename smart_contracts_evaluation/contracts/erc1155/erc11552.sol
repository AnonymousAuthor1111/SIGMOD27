contract Erc1155 {
  struct TotalSupplyByIdTuple {
    uint n;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct TotalBalancesByIdTuple {
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
  mapping(uint=>TotalSupplyByIdTuple) totalSupplyById;
  OwnerTuple owner;
  mapping(address=>mapping(uint=>BalanceOfTuple)) balanceOf;
  mapping(address=>mapping(address=>IsApprovedForAllTuple)) isApprovedForAll;
  mapping(uint=>TotalBalancesByIdTuple) totalBalancesById;
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
  function updateTotalInOnInsertTransferSingle_r0(address p,uint id,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalIn_r8(p,id,delta0);
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
  function updateInitialBalanceOnInsertBurn_r9(address p,uint id) private    {
      updateTotalInitialOnInsertInitialBalance_r11(p,id,uint(0));
  }
  function updateBalanceOfOnIncrementTotalIn_r8(address p,uint id,int ti) private    {
      int _delta = int(ti);
      uint newValue = updateuintByint(balanceOf[p][id].n,_delta);
      balanceOf[p][id].n = newValue;
  }
  function updateIssueTotalByIdOnInsertMint_r4(uint id,uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyByIdOnIncrementIssueTotalById_r15(id,delta0);
  }
  function updateBalanceOfOnIncrementTotalInitial_r8(address p,uint id,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(balanceOf[p][id].n,_delta);
      balanceOf[p][id].n = newValue;
  }
  function updateInitialBalanceOnInsertMint_r18(address p,uint id) private    {
      updateTotalInitialOnInsertInitialBalance_r11(p,id,uint(0));
  }
  function updateBurnTotalByIdOnInsertBurn_r10(uint id,uint n) private    {
      int delta0 = int(n);
      updateTotalSupplyByIdOnIncrementBurnTotalById_r15(id,delta0);
  }
  function updateBalanceOfOnIncrementTotalBurn_r8(address p,uint id,int b) private    {
      int _delta = int(-b);
      uint newValue = updateuintByint(balanceOf[p][id].n,_delta);
      balanceOf[p][id].n = newValue;
  }
  function updateTotalInitialOnInsertInitialBalance_r11(address p,uint id,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalInitial_r8(p,id,delta0);
  }
  function updateBalanceOfOnIncrementTotalOut_r8(address p,uint id,int to) private    {
      int _delta = int(-to);
      uint newValue = updateuintByint(balanceOf[p][id].n,_delta);
      balanceOf[p][id].n = newValue;
  }
  function updateTotalMintOnInsertMint_r7(address p,uint id,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalMint_r8(p,id,delta0);
  }
  function updateTotalBurnOnInsertBurn_r21(address p,uint id,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalBurn_r8(p,id,delta0);
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
  function updateTotalOutOnInsertTransferSingle_r17(address p,uint id,uint n) private    {
      int delta0 = int(n);
      updateBalanceOfOnIncrementTotalOut_r8(p,id,delta0);
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
  function updateBalanceOfOnIncrementTotalMint_r8(address p,uint id,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(balanceOf[p][id].n,_delta);
      balanceOf[p][id].n = newValue;
  }
  function updateIsApprovedForAllOnInsertSetApprovalForAllAction_r2(address o,address s,bool b) private    {
      isApprovedForAll[o][s] = IsApprovedForAllTuple(b,true);
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
  function updateInitialBalanceOnInsertTransferSingle_r3(address p,uint id) private    {
      updateTotalInitialOnInsertInitialBalance_r11(p,id,uint(0));
  }
  function updateTotalSupplyByIdOnIncrementBurnTotalById_r15(uint id,int b) private    {
      int _delta = int(-b);
      uint newValue = updateuintByint(totalSupplyById[id].n,_delta);
      totalSupplyById[id].n = newValue;
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
  function updateTotalSupplyByIdOnIncrementIssueTotalById_r15(uint id,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(totalSupplyById[id].n,_delta);
      totalSupplyById[id].n = newValue;
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
  function updateInitialBalanceOnInsertTransferSingle_r19(address p,uint id) private    {
      updateTotalInitialOnInsertInitialBalance_r11(p,id,uint(0));
  }
}