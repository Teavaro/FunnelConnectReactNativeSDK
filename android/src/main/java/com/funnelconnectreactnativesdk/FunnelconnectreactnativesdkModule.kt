package com.funnelconnectreactnativesdk

import android.app.Application
import android.util.Log
import com.facebook.react.bridge.*
import com.teavaro.funnelConnect.core.initializer.FunnelConnectSDK
import com.teavaro.funnelConnect.data.models.dataClasses.FCOptions

class FunnelconnectreactnativesdkModule(private val reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return "Funnelconnectreactnativesdk"
  }

  // Top level functions
  @ReactMethod
  fun initializeSDK(sdkToken: String, fcOptions: ReadableMap = WritableNativeMap()) {
    val application = reactContext.applicationContext as Application
    Log.v("RNTag Application", "application != null")
    val enableLogging = fcOptions.getBoolean("enableLogging")
    Log.v("RNTag fcOptions", enableLogging.toString())
    val fcOptionsObj = FCOptions(enableLogging)
    Log.v("RNTag fcOptions obj", fcOptionsObj.toString())
    FunnelConnectSDK.initialize(application, "BXDX2QY]37Yo^LH}Y4oDmNo6", fcOptionsObj)
    Log.v("RNTag SDK Initialized", "")
  }

  @ReactMethod
  fun onInitialize(promise: Promise) {
    // TODO:- to change to the actual function call when merging this change to the SDK master branch
    promise.resolve({})
    // promise.reject()
  }

  @ReactMethod
  fun isInitialized(promise: Promise) {
    // TODO:- to change to the actual function call when merging this change to the SDK master branch
    promise.resolve(true)
  }

  @ReactMethod
  fun clearCookies() {
    FunnelConnectSDK.clearCookies()
  }

  @ReactMethod
  fun clearData() {
    FunnelConnectSDK.clearData()
  }


  // CDP service functions
  @ReactMethod
  fun startCdpService(fcUser: ReadableMap?) {
    // TODO: Convert fcUser to nullable FCUser
    FunnelConnectSDK.cdp().startService(fcUser)
  }

  @ReactMethod
  fun startCdpService(fcUser: ReadableMap?, promise: Promise) {
    // TODO: Convert fcUser to nullable FCUser
    FunnelConnectSDK.cdp().startService(fcUser, dataCallback = {
      promise.resolve(it)
    }, errorCallback = {
      promise.reject(it)
    })
  }
  // TODO: Remove on update above and in setUser
  // type FCUser = {
  //   userIdType: string;
  //   userId: string;
  // };

  @ReactMethod
  fun getUmid(promise: Promise) {
    promise.resolve(FunnelConnectSDK.cdp().getUmid())
  }

  @ReactMethod
  fun getUserId(promise: Promise) {
    promise.resolve(FunnelConnectSDK.cdp().getUserId())
  }

  @ReactMethod
  fun setUser(fcUser: ReadableMap) {
    // TODO: Convert fcUser to FCUser
    FunnelConnectSDK.cdp().setUser(fcUser)
  }

  @ReactMethod
  fun getPermissions(promise: Promise) {
    val permissions = FunnelConnectSDK.cdp().getPermissions()
    val permissionsMap = WritableNativeMap()
    // TODO: Convert permissionsMap to ReadableMap
    permissionsMap.putString("omAccepted", permissions.omAccepted.toString())
    permissionsMap.putString("optAccepted", permissions.optAccepted.toString())
    permissionsMap.putString("nbaAccepted", permissions.nbaAccepted.toString())
    promise.resolve(permissionsMap)
  }

  @ReactMethod
  fun updatePermissions(permissions: ReadableMap, notificationsVersion: Int) {
    // TODO: Convert permissions to PermissionsMap
    FunnelConnectSDK.cdp().updatePermissions(permissions, notificationsVersion)
  }

  @ReactMethod
  fun logEvent(key: String, value: String) {
    FunnelConnectSDK.cdp().logEvent(key, value)
  }

  @ReactMethod
  fun logEvents(events: ReadableArray) {
   // FunnelConnectSDK.cdp().logEvents(events)
    println("RN Events $events")
  }

  @ReactMethod
  fun logEvents(events: ReadableArray, promise: Promise) {
    println("RN Events $events")
    promise.resolve("true")
  }

  // TrustPid service functions
  @ReactMethod
  fun startTrustPidService(isStub: Boolean) {
    FunnelConnectSDK.trustPid().startService(isStub)
  }

  @ReactMethod
  fun startTrustPidService(isStub: Boolean, promise: Promise) {
    FunnelConnectSDK.trustPid().startService(isStub, dataCallback = {
      val idcDataMap = WritableNativeMap()
      idcDataMap.putString("atid", it.atid)
      idcDataMap.putString("mtid", it.mtid)
      promise.resolve(idcDataMap)
    }, errorCallback = {
      promise.reject(it)
    })
  }

  @ReactMethod
  fun acceptConsent() {
    FunnelConnectSDK.trustPid().acceptConsent()
  }

  @ReactMethod
  fun rejectConsent() {
    FunnelConnectSDK.trustPid().rejectConsent()
  }

  @ReactMethod
  fun isConsentAccepted(promise: Promise) {
    promise.resolve(FunnelConnectSDK.trustPid().isConsentAccepted())
  }
}
