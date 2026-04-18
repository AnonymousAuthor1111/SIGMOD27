contract OwnedUpgradeabilityProxy {
  struct ProxyOwnerTuple {
    address p;
    bool _valid;
  }
  struct PendingProxyOwnerTuple {
    address p;
    bool _valid;
  }
  struct ImplementationTuple {
    address p;
    bool _valid;
  }
  ImplementationTuple implementation;
  ProxyOwnerTuple proxyOwner;
  PendingProxyOwnerTuple pendingProxyOwner;
  event ClaimProxyOwnership(address newOwner);
  event UpgradeTo(address oldImpl,address newImpl);
  event TransferProxyOwnership(address newOwner);
  constructor() public {
    updatePendingProxyOwnerOnInsertConstructor_r2();
    updateProxyOwnerOnInsertConstructor_r4();
  }
  function getPendingProxyOwner() public view  returns (address) {
      address p = pendingProxyOwner.p;
      return p;
  }
  function claimProxyOwnership() public    {
      bool r5 = updateClaimProxyOwnershipOnInsertRecv_claimProxyOwnership_r5();
      if(r5==false) {
        revert("Rule condition failed");
      }
  }
  function transferProxyOwnership(address newOwner) public    {
      bool r7 = updateTransferProxyOwnershipOnInsertRecv_transferProxyOwnership_r7(newOwner);
      if(r7==false) {
        revert("Rule condition failed");
      }
  }
  function getProxyOwner() public view  returns (address) {
      address p = proxyOwner.p;
      return p;
  }
  function upgradeTo(address newImpl) public    {
      bool r0 = updateUpgradeToOnInsertRecv_upgradeTo_r0(newImpl);
      if(r0==false) {
        revert("Rule condition failed");
      }
  }
  function getImplementation() public view  returns (address) {
      address p = implementation.p;
      return p;
  }
  function updatePendingProxyOwnerOnInsertConstructor_r2() private    {
      pendingProxyOwner = PendingProxyOwnerTuple(address(0),true);
  }
  function updateProxyOwnerOnInsertClaimProxyOwnership_r9(address a) private    {
      proxyOwner = ProxyOwnerTuple(a,true);
  }
  function updateTransferProxyOwnershipOnInsertRecv_transferProxyOwnership_r7(address a) private   returns (bool) {
      address s = proxyOwner.p;
      if(s==msg.sender) {
        if(a!=address(0)) {
          updatePendingProxyOwnerOnInsertTransferProxyOwnership_r1(a);
          emit TransferProxyOwnership(a);
          return true;
        }
      }
      return false;
  }
  function updatePendingProxyOwnerOnInsertTransferProxyOwnership_r1(address a) private    {
      pendingProxyOwner = PendingProxyOwnerTuple(a,true);
  }
  function updateUpgradeToOnInsertRecv_upgradeTo_r0(address i) private   returns (bool) {
      address old = implementation.p;
      address s = proxyOwner.p;
      if(s==msg.sender) {
        if(old!=i) {
          updateImplementationOnInsertUpgradeTo_r3(old,i);
          emit UpgradeTo(old,i);
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
  function updateProxyOwnerOnInsertConstructor_r4() private    {
      address s = msg.sender;
      proxyOwner = ProxyOwnerTuple(s,true);
  }
  function updatePendingProxyOwnerOnInsertClaimProxyOwnership_r8(address _newOwner0) private    {
      pendingProxyOwner = PendingProxyOwnerTuple(address(0),true);
  }
  function updateImplementationOnInsertUpgradeTo_r3(address _oldImpl0,address i) private    {
      implementation = ImplementationTuple(i,true);
  }
  function updateClaimProxyOwnershipOnInsertRecv_claimProxyOwnership_r5() private   returns (bool) {
      address p = pendingProxyOwner.p;
      address s = pendingProxyOwner.p;
      if(s==msg.sender) {
        if(s!=address(0)) {
          updateProxyOwnerOnInsertClaimProxyOwnership_r9(p);
          updatePendingProxyOwnerOnInsertClaimProxyOwnership_r8(p);
          emit ClaimProxyOwnership(p);
          return true;
        }
      }
      return false;
  }
}