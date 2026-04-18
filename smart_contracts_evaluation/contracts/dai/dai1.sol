contract Dai {
  struct WardsTuple {
    bool b;
    bool _valid;
  }
  struct AllowanceTuple {
    uint n;
    bool _valid;
  }
  mapping(address=>mapping(address=>AllowanceTuple)) allowance;
  mapping(address=>WardsTuple) wards;
  event Deny(address guy);
  event BurnSelf(address usr,uint wad);
  event Rely(address guy);
  event PullAction(address src,address dst,address spender,uint wad);
  event MoveAction(address src,address dst,address spender,uint wad);
  event Approve(address owner,address spender,uint wad);
  event Mint(address usr,uint wad);
  event BurnFrom(address usr,address spender,uint wad);
  event PushAction(address src,address dst,uint wad);
  event Transfer(address src,address dst,uint wad);
  event TransferFrom(address src,address dst,address spender,uint wad);
  constructor(uint chainId) public {
    updateWardsOnInsertConstructor_r7();
  }
  function push(address usr,uint wad) public    {
      bool r1 = updatePushActionOnInsertRecv_push_r1(usr,wad);
      if(r1==false) {
        revert("Rule condition failed");
      }
  }
  function pull(address usr,uint wad) public    {
      bool r6 = updatePullActionOnInsertRecv_pull_r6(usr,wad);
      if(r6==false) {
        revert("Rule condition failed");
      }
  }
  function burn(address usr,uint wad) public    {
      bool r5 = updateBurnSelfOnInsertRecv_burn_r5(usr,wad);
      bool r13 = updateBurnFromOnInsertRecv_burn_r13(usr,wad);
      if(r5==false && r13==false) {
        revert("Rule condition failed");
      }
  }
  function deny(address guy) public    {
      bool r12 = updateDenyOnInsertRecv_deny_r12(guy);
      if(r12==false) {
        revert("Rule condition failed");
      }
  }
  function approve(address spender,uint wad) public    {
      bool r10 = updateApproveOnInsertRecv_approve_r10(spender,wad);
      if(r10==false) {
        revert("Rule condition failed");
      }
  }
  function move(address src,address dst,uint wad) public    {
      bool r4 = updateMoveActionOnInsertRecv_move_r4(src,dst,wad);
      if(r4==false) {
        revert("Rule condition failed");
      }
  }
  function transfer(address dst,uint wad) public    {
      bool r9 = updateTransferOnInsertRecv_transfer_r9(dst,wad);
      if(r9==false) {
        revert("Rule condition failed");
      }
  }
  function rely(address guy) public    {
      bool r14 = updateRelyOnInsertRecv_rely_r14(guy);
      if(r14==false) {
        revert("Rule condition failed");
      }
  }
  function mint(address usr,uint wad) public    {
      bool r2 = updateMintOnInsertRecv_mint_r2(usr,wad);
      if(r2==false) {
        revert("Rule condition failed");
      }
  }
  function transferFrom(address src,address dst,uint wad) public    {
      bool r8 = updateTransferFromOnInsertRecv_transferFrom_r8(src,dst,wad);
      if(r8==false) {
        revert("Rule condition failed");
      }
  }
  function updateTransferOnInsertRecv_transfer_r9(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      if(s!=address(0) && r!=address(0)) {
        emit Transfer(s,r,n);
        return true;
      }
      return false;
  }
  function updateBurnFromOnInsertRecv_burn_r13(address u,uint n) private   returns (bool) {
      address s = msg.sender;
      uint k = allowance[u][s].n;
      if(u!=s && u!=address(0) && k>=n) {
        emit BurnFrom(u,s,n);
        return true;
      }
      return false;
  }
  function updateWardsOnInsertDeny_r3(address g) private    {
      wards[g] = WardsTuple(false,true);
  }
  function updateMintOnInsertRecv_mint_r2(address p,uint n) private   returns (bool) {
      address s = msg.sender;
      if(true==wards[s].b) {
        if(p!=address(0)) {
          emit Mint(p,n);
          return true;
        }
      }
      return false;
  }
  function updateMoveActionOnInsertRecv_move_r4(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint k = allowance[o][s].n;
      if(o!=address(0) && r!=address(0) && k>=n) {
        emit MoveAction(o,r,s,n);
        return true;
      }
      return false;
  }
  function updateWardsOnInsertRely_r11(address g) private    {
      wards[g] = WardsTuple(true,true);
  }
  function updateRelyOnInsertRecv_rely_r14(address g) private   returns (bool) {
      address s = msg.sender;
      if(true==wards[s].b) {
        if(g!=address(0)) {
          updateWardsOnInsertRely_r11(g);
          emit Rely(g);
          return true;
        }
      }
      return false;
  }
  function updateApproveOnInsertRecv_approve_r10(address s,uint n) private   returns (bool) {
      address o = msg.sender;
      if(o!=address(0) && s!=address(0)) {
        updateAllowanceOnInsertApprove_r0(o,s,n);
        emit Approve(o,s,n);
        return true;
      }
      return false;
  }
  function updateTransferFromOnInsertRecv_transferFrom_r8(address o,address r,uint n) private   returns (bool) {
      address s = msg.sender;
      uint k = allowance[o][s].n;
      if(o!=address(0) && r!=address(0) && k>=n) {
        emit TransferFrom(o,r,s,n);
        return true;
      }
      return false;
  }
  function updateDenyOnInsertRecv_deny_r12(address g) private   returns (bool) {
      address s = msg.sender;
      if(true==wards[s].b) {
        if(g!=address(0)) {
          updateWardsOnInsertDeny_r3(g);
          emit Deny(g);
          return true;
        }
      }
      return false;
  }
  function updateWardsOnInsertConstructor_r7() private    {
      address s = msg.sender;
      wards[s] = WardsTuple(true,true);
  }
  function updatePushActionOnInsertRecv_push_r1(address r,uint n) private   returns (bool) {
      address s = msg.sender;
      if(s!=address(0) && r!=address(0)) {
        emit PushAction(s,r,n);
        return true;
      }
      return false;
  }
  function updateAllowanceOnInsertApprove_r0(address o,address s,uint n) private    {
      allowance[o][s] = AllowanceTuple(n,true);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updatePullActionOnInsertRecv_pull_r6(address o,uint n) private   returns (bool) {
      address s = msg.sender;
      uint k = allowance[o][s].n;
      if(o!=address(0) && k>=n) {
        emit PullAction(o,s,s,n);
        return true;
      }
      return false;
  }
  function updateBurnSelfOnInsertRecv_burn_r5(address u,uint n) private   returns (bool) {
      address s = msg.sender;
      if(u==s && u!=address(0)) {
        emit BurnSelf(u,n);
        return true;
      }
      return false;
  }
}