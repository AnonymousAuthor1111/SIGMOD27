contract FiatTokenProxy {
  struct AdminTuple {
    address p;
    bool _valid;
  }
  struct ImplementationTuple {
    address p;
    bool _valid;
  }
  ImplementationTuple implementation;
  AdminTuple admin;
  event UpgradeToAndCall(address newImpl);
  event ChangeAdmin(address oldAdmin,address newAdmin);
  event UpgradeTo(address newImpl);
  constructor(address impl) public {
    updateAdminOnInsertConstructor_r6(impl);
    updateImplementationOnInsertConstructor_r5(impl);
  }
  function upgradeToAndCall(address newImpl) public    {
      bool r7 = updateUpgradeToAndCallOnInsertRecv_upgradeToAndCall_r7(newImpl);
      if(r7==false) {
        revert("Rule condition failed");
      }
  }
  function getImplementation() public view  returns (address) {
      address p = implementation.p;
      return p;
  }
  function changeAdmin(address newAdmin) public    {
      bool r9 = updateChangeAdminOnInsertRecv_changeAdmin_r9(newAdmin);
      if(r9==false) {
        revert("Rule condition failed");
      }
  }
  function getAdmin() public view  returns (address) {
      address p = admin.p;
      return p;
  }
  function upgradeTo(address newImpl) public    {
      bool r8 = updateUpgradeToOnInsertRecv_upgradeTo_r8(newImpl);
      if(r8==false) {
        revert("Rule condition failed");
      }
  }
  function updateUpgradeToOnInsertRecv_upgradeTo_r8(address i) private   returns (bool) {
      address s = admin.p;
      if(s==msg.sender) {
        if(i!=address(0)) {
          updateImplementationOnInsertUpgradeTo_r0(i);
          emit UpgradeTo(i);
          return true;
        }
      }
      return false;
  }
  function updateImplementationOnInsertUpgradeTo_r0(address i) private    {
      implementation = ImplementationTuple(i,true);
  }
  function updateUpgradeToAndCallOnInsertRecv_upgradeToAndCall_r7(address i) private   returns (bool) {
      address s = admin.p;
      if(s==msg.sender) {
        if(i!=address(0)) {
          updateImplementationOnInsertUpgradeToAndCall_r2(i);
          emit UpgradeToAndCall(i);
          return true;
        }
      }
      return false;
  }
  function updateAdminOnInsertConstructor_r6(address _impl0) private    {
      address s = msg.sender;
      admin = AdminTuple(s,true);
  }
  function updateuintByint(uint x,int delta) private   returns (uint) {
      int convertedX = int(x);
      int value = convertedX+delta;
      uint convertedValue = uint(value);
      return convertedValue;
  }
  function updateImplementationOnInsertConstructor_r5(address i) private    {
      if(i!=address(0)) {
        implementation = ImplementationTuple(i,true);
      }
  }
  function updateAdminOnInsertChangeAdmin_r4(address _oldAdmin0,address a) private    {
      admin = AdminTuple(a,true);
  }
  function updateChangeAdminOnInsertRecv_changeAdmin_r9(address a) private   returns (bool) {
      address old = admin.p;
      address s = admin.p;
      if(s==msg.sender) {
        if(a!=address(0)) {
          updateAdminOnInsertChangeAdmin_r4(old,a);
          emit ChangeAdmin(old,a);
          return true;
        }
      }
      return false;
  }
  function updateImplementationOnInsertUpgradeToAndCall_r2(address i) private    {
      implementation = ImplementationTuple(i,true);
  }
}