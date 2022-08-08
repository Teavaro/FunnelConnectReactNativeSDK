package com.funnelconnectreactnativesdk

import com.facebook.react.bridge.*
import com.teavaro.funnelConnect.core.initializer.FunnelConnectSDK

class FunnelconnectreactnativesdkModule(private val reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return "RNFunnelConnectSDK"
  }

  // Top level functions
  @ReactMethod
  fun clearCookies() {
    FunnelConnectSDK.clearCookies()
  }

  @ReactMethod
  fun clearData(promise: Promise) {
    FunnelConnectSDK.clearData()
  }

  // CDP service functions
  @ReactMethod
  fun startCdpService(userId: String?) {
    FunnelConnectSDK.cdp().startService(userId)
  }

  @ReactMethod
  fun startCdpService(userId: String?, promise: Promise) {
    FunnelConnectSDK.cdp().startService(userId, dataCallback = {
      promise.resolve(it)
    }, errorCallback = {
      promise.reject(it)
    })
  }

  @ReactMethod
  fun getUmid(promise: Promise) {
    promise.resolve(FunnelConnectSDK.cdp().getUmid())
  }

  @ReactMethod
  fun getUserId(promise: Promise) {
    promise.resolve(FunnelConnectSDK.cdp().getUserId())
  }

  @ReactMethod
  fun setUserId(userId: String) {
    FunnelConnectSDK.cdp().setUserId(userId)
  }

  @ReactMethod
  fun getPermissions(promise: Promise) {
    val permissions = FunnelConnectSDK.cdp().getPermissions()
    val permissionsMap = WritableNativeMap()
    permissionsMap.putString("omAccepted", permissions.omAccepted.toString())
    permissionsMap.putString("optAccepted", permissions.optAccepted.toString())
    permissionsMap.putString("nbaAccepted", permissions.nbaAccepted.toString())
    promise.resolve(permissionsMap)
  }

  @ReactMethod
  fun updatePermissions(omAccepted: Boolean, optAccepted: Boolean, nbaAccepted: Boolean) {
    FunnelConnectSDK.cdp().updatePermissions(omAccepted, optAccepted, nbaAccepted)
  }

  @ReactMethod
  fun logEvent(key: String, value: String) {
    FunnelConnectSDK.cdp().logEvent(key, value)
  }

  @ReactMethod
  fun logEvents(events: Map<String, String>) {
    FunnelConnectSDK.cdp().logEvents(events)
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
