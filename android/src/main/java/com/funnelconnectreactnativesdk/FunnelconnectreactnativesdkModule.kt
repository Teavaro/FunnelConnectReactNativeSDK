package com.funnelconnectreactnativesdk

import com.facebook.react.bridge.*

class FunnelconnectreactnativesdkModule(private val reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return "Funnelconnectreactnativesdk"
  }

  @ReactMethod
  fun printNativeLog() {
    println("Native log printed...")
  }

  @ReactMethod
  fun getStaticString(promise: Promise) {
    promise.resolve("Test of static string from native module")
  }

  @ReactMethod
  fun resolveMultiplicationPromise(a: Int, b: Int, promise: Promise) {
    promise.resolve(a * b)
  }

  @ReactMethod
  fun resolveUserDataPromise(a: Int, b: Int, promise: Promise) {
    val newUser = UserData("a@b.com", "FirstName", "myAddress")
    promise.resolve(newUser)
  }

  @ReactMethod
  fun resolveUserMapPromise(a: Int, b: Int, promise: Promise) {
    val newUser = UserData("a@b.com", "FirstName", "myAddress")
    val userMap = WritableNativeMap()
    userMap.putString("id", newUser.id)
    userMap.putString("name", newUser.name)
    userMap.putString("address", newUser.address)
    promise.resolve(userMap)
  }

  @ReactMethod
  fun getTestInterface(): TestInterface {
    return TestInterfaceImpl()
  }

  @ReactMethod
  fun callCallback(name: String, location: String, callback: Callback) {
    callback.invoke(name, location)
  }

  @ReactMethod
  fun callProvidedCallback(parameter: String, callback: Callback) {
    callback.invoke(parameter + "test output string extension")
  }

  @ReactMethod
  fun callUserDataProvidedCallback(parameter: String, callback: Callback) {
    val newUser = UserData("a@b.com", "FirstName", "myAddress")
    callback.invoke(newUser)
  }

  // const cdp = {
  //   startService: (
  //     userId: String? = null,
  //     dataCallBack: DataCallBack? = null,
  //     errorCallback: ErroCallBack? = null
  //   ) => {},
  //   getUmid: () => {},
  //   updatePermissions: (om: Boolean, opt: Boolean, nba: Boolean) => {},
  //   getPermissions: () => {},
  //   logEvent: (key: String, value: String) => {},
  //   logEvents: (events: Map<String, String>) => {},
//   FunnelConnectSDK.cdp().startService(userId: String, dataCallBack: DataCallBack? = null, errorCallback: ErroCallBack? = null)
// FunnelConnectSDK.cdp().setUserId(userId: String)
// FunnelConnectSDK.cdp().getUserId()
  // };

  // const trustPid = {
  //   acceptConsent: () => {},
  //   startService: (
  //     isStub: Boolean = false,
  //     dataCallback: IdcDataCallback? = null,
  //     errorCallback: ErrorCallback? = null
  //   ) => {},
  //   isConsentAccepted: () => {},
  //   rejectConsent: () => {},
  // };
}

data class UserData(val id: String, val name: String, val address: String)

interface TestInterface {
  fun getUmid(): String?
  fun updatePermissions(omPermissionAccepted: Boolean, optPermissionAccepted: Boolean, nbaPermissionAccepted: Boolean)
  fun logEvent(key: String, value: String)
}

class TestInterfaceImpl: TestInterface {

  override fun getUmid(): String? {
    return "Dummy UMID"
  }

  override fun updatePermissions(
    omPermissionAccepted: Boolean,
    optPermissionAccepted: Boolean,
    nbaPermissionAccepted: Boolean
  ) {
    println("React Native: Updated Permissions: OM: $omPermissionAccepted OPT: $optPermissionAccepted NBA: $nbaPermissionAccepted")
  }

  override fun logEvent(key: String, value: String) {
    println("React Native: Logged An Event")
  }
}
