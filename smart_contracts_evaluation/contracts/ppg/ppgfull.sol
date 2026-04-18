contract Ppg {
  struct PRICETuple {
    uint n;
    bool _valid;
  }
  struct OwnerTuple {
    address p;
    bool _valid;
  }
  struct TotalMintedByTuple {
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
  struct TotalInitialTuple {
    uint n;
    bool _valid;
  }
  struct CreatorAddressTuple {
    address p;
    bool _valid;
  }
  struct MAX_BY_MINTTuple {
    uint n;
    bool _valid;
  }
  struct DevAddressTuple {
    address p;
    bool _valid;
  }
  struct BaseURIMarkerTuple {
    uint n;
    bool _valid;
  }
  struct PausedTuple {
    bool b;
    bool _valid;
  }
  PRICETuple PRICE;
  OwnerTuple owner;
  mapping(address=>TotalMintedByTuple) totalMintedBy;
  InitialBalanceTuple initialBalance;
  mapping(address=>BalanceOfTuple) balanceOf;
  mapping(address=>TotalInitialTuple) totalInitial;
  CreatorAddressTuple creatorAddress;
  MAX_BY_MINTTuple MAX_BY_MINT;
  DevAddressTuple devAddress;
  BaseURIMarkerTuple baseURIMarker;
  PausedTuple paused;
  event SetBaseURIAction(uint baseURI);
  event WithdrawDev(address to,uint amount);
  event WithdrawCreator(address to,uint amount);
  event PauseAction(bool val);
  event MintAction(address to,uint minted,uint paid);
  constructor(uint baseURI,address creator,address dev) public {
    updateCreatorAddressOnInsertConstructor_r9(creator);
    updateDevAddressOnInsertConstructor_r7(dev);
    updateMAX_BY_MINTOnInsertConstructor_r15();
    updateBaseURIMarkerOnInsertConstructor_r6(baseURI);
    updatePRICEOnInsertConstructor_r4();
    updateOwnerOnInsertConstructor_r14();
    updatePausedOnInsertConstructor_r12();
    updateMAX_ELEMENTSOnInsertConstructor_r8();
  }
  function pause(bool val) public    {
      bool r5 = updatePauseActionOnInsertRecv_pause_r5(val);
      if(r5==false) {
        revert("Rule condition failed");
      }
  }
  function getPaused() public view  returns (bool) {
      bool b = paused.b;
      return b;
  }
  function getBalanceOf(address p) public view  returns (uint) {
      uint n = balanceOf[p].n;
      return n;
  }
  function getBaseURIMarker() public view  returns (uint) {
      uint n = baseURIMarker.n;
      return n;
  }
  function withdrawAll() public    {
      bool r10 = updateWithdrawCreatorOnInsertRecv_withdrawAll_r10();
      bool r18 = updateWithdrawDevOnInsertRecv_withdrawAll_r18();
      if(r10==false && r18==false) {
        revert("Rule condition failed");
      }
  }
  function setBaseURI(uint baseURI) public    {
      bool r19 = updateSetBaseURIActionOnInsertRecv_setBaseURI_r19(baseURI);
      if(r19==false) {
        revert("Rule condition failed");
      }
  }
  function mint(address to,uint count) public  payable  {
      bool r13 = updateMintActionOnInsertRecv_mint_r13(to,count);
      bool r20 = updateMintActionOnInsertRecv_mint_r20(to,count);
      if(r13==false && r20==false) {
        revert("Rule condition failed");
      }
  }
  function updateBalanceOfOnInsertTotalInitial_r0(address p,uint i) private    {
      TotalInitialTuple memory toDelete = totalInitial[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalInitial_r0(p,toDelete.n);
      }
      uint m = totalMintedBy[p].n;
      uint s = i+m;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateWithdrawDevOnInsertRecv_withdrawAll_r18() private   returns (bool) {
      address d = devAddress.p;
      address s = owner.p;
      if(s==msg.sender) {
        updateSendOnInsertWithdrawDev_r11(d,uint(35));
        emit WithdrawDev(d,35);
        return true;
      }
      return false;
  }
  function updateBalanceOfOnIncrementTotalMintedBy_r0(address p,int m) private    {
      int _delta = int(m);
      uint newValue = updateuintByint(totalMintedBy[p].n,_delta);
      updateBalanceOfOnInsertTotalMintedBy_r0(p,newValue);
  }
  function updateCreatorAddressOnInsertConstructor_r9(address c) private    {
      creatorAddress = CreatorAddressTuple(c,true);
  }
  function updateBalanceOfOnIncrementTotalInitial_r0(address p,int i) private    {
      int _delta = int(i);
      uint newValue = updateuintByint(totalInitial[p].n,_delta);
      updateBalanceOfOnInsertTotalInitial_r0(p,newValue);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateTotalMintedByOnInsertMintAction_r2(address p,uint n) private    {
      int delta2 = int(n);
      updateBalanceOfOnIncrementTotalMintedBy_r0(p,delta2);
      totalMintedBy[p].n += n;
  }
  function updatePausedOnInsertPauseAction_r16(bool v) private    {
      paused = PausedTuple(v,true);
  }
  function updateOwnerOnInsertConstructor_r14() private    {
      address s = msg.sender;
      owner = OwnerTuple(s,true);
  }
  function updateWithdrawCreatorOnInsertRecv_withdrawAll_r10() private   returns (bool) {
      address c = creatorAddress.p;
      address s = owner.p;
      if(s==msg.sender) {
        updateSendOnInsertWithdrawCreator_r21(c,uint(65));
        emit WithdrawCreator(c,65);
        return true;
      }
      return false;
  }
  function updateTotalInitialOnInsertInitialBalance_r1(address p,uint n) private    {
      int delta2 = int(n);
      updateBalanceOfOnIncrementTotalInitial_r0(p,delta2);
      totalInitial[p].n += n;
  }
  function updateBaseURIMarkerOnInsertSetBaseURIAction_r17(uint b) private    {
      baseURIMarker = BaseURIMarkerTuple(b,true);
  }
  function updateBaseURIMarkerOnInsertConstructor_r6(uint b) private    {
      baseURIMarker = BaseURIMarkerTuple(b,true);
  }
  function updateMAX_ELEMENTSOnInsertConstructor_r8() private    {
      // Empty()
  }
  function updateMintActionOnInsertRecv_mint_r13(address to,uint n) private   returns (bool) {
      address s = msg.sender;
      uint p = PRICE.n;
      uint mm = MAX_BY_MINT.n;
      uint v = msg.value;
      if(s==owner.p) {
        if(n<=mm && v>=p*n) {
          updateTotalMintedByOnInsertMintAction_r2(to,n);
          updateInitialBalanceOnInsertMintAction_r3(to);
          emit MintAction(to,n,v);
          return true;
        }
      }
      return false;
  }
  function updateBalanceOfOnDeleteTotalInitial_r0(address p,uint i) private    {
      uint m = totalMintedBy[p].n;
      uint s = i+m;
      if(s==balanceOf[p].n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateSendOnInsertWithdrawDev_r11(address p,uint n) private    {
      payable(p).send(n);
  }
  function updateDevAddressOnInsertConstructor_r7(address d) private    {
      devAddress = DevAddressTuple(d,true);
  }
  function updatePauseActionOnInsertRecv_pause_r5(bool v) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        updatePausedOnInsertPauseAction_r16(v);
        emit PauseAction(v);
        return true;
      }
      return false;
  }
  function updatePausedOnInsertConstructor_r12() private    {
      paused = PausedTuple(true,true);
  }
  function updatePRICEOnInsertConstructor_r4() private    {
      PRICE = PRICETuple(30000000000000000,true);
  }
  function updateBalanceOfOnInsertTotalMintedBy_r0(address p,uint m) private    {
      TotalMintedByTuple memory toDelete = totalMintedBy[p];
      if(toDelete._valid==true) {
        updateBalanceOfOnDeleteTotalMintedBy_r0(p,toDelete.n);
      }
      uint i = totalInitial[p].n;
      uint s = i+m;
      balanceOf[p] = BalanceOfTuple(s,true);
  }
  function updateSetBaseURIActionOnInsertRecv_setBaseURI_r19(uint b) private   returns (bool) {
      address s = owner.p;
      if(s==msg.sender) {
        updateBaseURIMarkerOnInsertSetBaseURIAction_r17(b);
        emit SetBaseURIAction(b);
        return true;
      }
      return false;
  }
  function updateMintActionOnInsertRecv_mint_r20(address to,uint n) private   returns (bool) {
      if(false==paused.b) {
        uint mm = MAX_BY_MINT.n;
        address s = msg.sender;
        uint p = PRICE.n;
        uint v = msg.value;
        address o = owner.p;
        if(s!=o && n<=mm && v>=p*n) {
          updateTotalMintedByOnInsertMintAction_r2(to,n);
          updateInitialBalanceOnInsertMintAction_r3(to);
          emit MintAction(to,n,v);
          return true;
        }
      }
      return false;
  }
  function updateInitialBalanceOnInsertMintAction_r3(address p) private    {
      updateTotalInitialOnInsertInitialBalance_r1(p,uint(0));
      initialBalance = InitialBalanceTuple(p,0,true);
  }
  function updateBalanceOfOnDeleteTotalMintedBy_r0(address p,uint m) private    {
      uint i = totalInitial[p].n;
      uint s = i+m;
      if(s==balanceOf[p].n) {
        balanceOf[p] = BalanceOfTuple(0,false);
      }
  }
  function updateSendOnInsertWithdrawCreator_r21(address p,uint n) private    {
      payable(p).send(n);
  }
  function updateMAX_BY_MINTOnInsertConstructor_r15() private    {
      MAX_BY_MINT = MAX_BY_MINTTuple(20,true);
  }
}