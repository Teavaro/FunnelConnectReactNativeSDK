package com.funnelconnectreactnativesdk

import android.app.Application
import com.facebook.react.bridge.*
import com.teavaro.funnelConnect.core.initializer.FunnelConnectSDK
import com.teavaro.funnelConnect.data.models.dataClasses.FCOptions
import com.teavaro.funnelConnect.data.models.dataClasses.FCUser
import com.teavaro.funnelConnect.utils.platformTypes.permissionsMap.PermissionsMap

class FunnelconnectreactnativesdkModule(private val reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return "FunnelConnectSDK"
  }

  // Top level functions
  @ReactMethod
  fun initializeSDK(sdkToken: String, fcOptions: ReadableMap = WritableNativeMap()) {
    val application = reactContext.applicationContext as Application
    val enableLogging = fcOptions.getBoolean("enableLogging")
    val fcOptionsObj = FCOptions(enableLogging)
    FunnelConnectSDK.initialize(application, sdkToken, fcOptionsObj)
  }

  @ReactMethod
  fun onInitializeAsync(promise: Promise) {
    FunnelConnectSDK.onInitialize(successCallback = {
      promise.resolve(null)
    }, errorCallback = {
      promise.reject("onInitializeAsync", it.returnOrExtractExceptionIfTeavaroRestClientException())
    })
  }

  @ReactMethod
  fun isInitializedAsync(promise: Promise) {
    promise.resolve(FunnelConnectSDK.isInitialized())
  }

  @ReactMethod
  fun clearCookies() {
    FunnelConnectSDK.clearCookies()
  }

  @ReactMethod
  fun clearCookiesAsync(promise: Promise) {
    try {
      FunnelConnectSDK.clearCookies()
      promise.resolve(null)
    }
    catch (e: Exception) {
      promise.reject("clearCookiesAsync", e.returnOrExtractExceptionIfTeavaroRestClientException())
    }
  }

  @ReactMethod
  fun clearData() {
    FunnelConnectSDK.clearData()
  }

  @ReactMethod
  fun clearDataAsync(promise: Promise) {
    try {
      FunnelConnectSDK.clearData()
      promise.resolve(null)
    }
    catch (e: Exception) {
      promise.reject("clearDataAsync", e.returnOrExtractExceptionIfTeavaroRestClientException())
    }
  }

  // CDP service functions
  @ReactMethod
  fun startCdpServiceAsync(fcUser: ReadableMap?, promise: Promise) {
    this.doIfValidUserInfoOrFail("startCdpServiceAsync", fcUser, promise) { fcUserObj ->
      try {
        FunnelConnectSDK.cdp().startService(fcUserObj, dataCallback = {
          promise.resolve(it)
        }, errorCallback = {
          promise.reject("startCdpServiceAsync", it.returnOrExtractExceptionIfTeavaroRestClientException())
        })
      }
      catch (e: Exception) {
        promise.reject("startCdpServiceAsync", e.returnOrExtractExceptionIfTeavaroRestClientException())
      }
    }
  }

  @ReactMethod
  fun startCdpServiceWithNotificationsVersionAsync(fcUser: ReadableMap?, notificationsName: String, notificationsVersion: Int, promise: Promise) {
    this.doIfValidUserInfoOrFail("startCdpServiceWithNotificationVersionAsync", fcUser, promise) { fcUserObj ->
      try {
        FunnelConnectSDK.cdp().startService(fcUserObj, notificationsVersion, dataCallback = {
          promise.resolve(it)
        }, errorCallback = {
          promise.reject("startCdpServiceWithNotificationVersionAsync", it.returnOrExtractExceptionIfTeavaroRestClientException())
        })
      }
      catch (e: Exception) {
        promise.reject("startCdpServiceWithNotificationVersionAsync", e.returnOrExtractExceptionIfTeavaroRestClientException())
      }
    }
  }

  @ReactMethod
  fun getUmidAsync(promise: Promise) {
    promise.resolve(FunnelConnectSDK.cdp().getUmid())
  }

  @ReactMethod
  fun getUserIdAsync(promise: Promise) {
    try {
      promise.resolve(FunnelConnectSDK.cdp().getUserId())
    }
    catch (e: Exception) {
      promise.reject("getUserIdAsync", e.returnOrExtractExceptionIfTeavaroRestClientException())
    }
  }

  @ReactMethod
  fun setUserAsync(fcUser: ReadableMap, promise: Promise) {
    this.doIfValidUserInfoOrFail("setUserAsync", fcUser, promise) { fcUserObj ->
      try {
        FunnelConnectSDK.cdp().setUser(fcUserObj, dataCallback = {
          promise.resolve(it)
        }, errorCallback = {
          promise.reject("setUserAsync", it.returnOrExtractExceptionIfTeavaroRestClientException())
        })
      }
      catch (e: Exception) {
        promise.reject("setUserAsync", e.returnOrExtractExceptionIfTeavaroRestClientException())
      }
    }
  }

  @ReactMethod
  fun getPermissionsAsync(promise: Promise) {
    val permissionsMap = WritableNativeMap()
    try {
      val permissions = FunnelConnectSDK.cdp().getPermissions()
      permissions.getAllKeys().forEach {
        permissionsMap.putBoolean(it, permissions.getPermission(it))
      }
      promise.resolve(permissionsMap)
    }
    catch (e: Exception) {
      promise.reject("getPermissionsAsync", e.returnOrExtractExceptionIfTeavaroRestClientException())
    }
  }

  @ReactMethod
  fun updatePermissions(permissions: ReadableMap, notificationsName: String, notificationsVersion: Int) {
    this.doIfEmptyPermissionsOrNot(permissions, permissionsAction = {
      FunnelConnectSDK.cdp().updatePermissions(it, notificationsVersion)
    })
  }

  @ReactMethod
  fun updatePermissionsAsync(permissions: ReadableMap, notificationsName: String, notificationsVersion: Int, promise: Promise) {
    this.doIfEmptyPermissionsOrNot(permissions, permissionsAction = {
      try {
        FunnelConnectSDK.cdp().updatePermissions(it, notificationsVersion)
        promise.resolve(null)
      }
      catch (e: Exception) {
        promise.reject("updatePermissionsAsync", e.returnOrExtractExceptionIfTeavaroRestClientException())
      }
    }, emptyPermissionsAction = {
      promise.reject("updatePermissionsAsync", Throwable("Empty Permissions!"))
    })
  }

  @ReactMethod
  fun logEvent(key: String, value: String) {
    FunnelConnectSDK.cdp().logEvent(key, value)
  }

  @ReactMethod
  fun logEventAsync(key: String, value: String, promise: Promise) {
    try {
      FunnelConnectSDK.cdp().logEvent(key, value, successCallback = {
        promise.resolve(null)
      }, errorCallback = {
        promise.reject("logEventAsync", it.returnOrExtractExceptionIfTeavaroRestClientException())
      })
    }
    catch (e: Exception) {
      promise.reject("logEventAsync", e.returnOrExtractExceptionIfTeavaroRestClientException())
    }
  }

  @ReactMethod
  fun logEvents(events: ReadableMap) {
    val eventsMap = events.toHashMap().toMap().mapValues { it.value.toString() }
    FunnelConnectSDK.cdp().logEvents(eventsMap)
  }

  @ReactMethod
  fun logEventsAsync(events: ReadableMap, promise: Promise) {
    val eventsMap = events.toHashMap().toMap().mapValues { it.value.toString() }
    try {
      FunnelConnectSDK.cdp().logEvents(eventsMap, successCallback = {
        promise.resolve(null)
      }, errorCallback = {
        promise.reject("logEventsAsync", it.returnOrExtractExceptionIfTeavaroRestClientException())
      })
    }
    catch (e: Exception) {
      promise.reject("logEventsAsync", e.returnOrExtractExceptionIfTeavaroRestClientException())
    }
  }

  // TrustPid service functions
  @ReactMethod
  fun startTrustPidService(isStub: Boolean) {
    FunnelConnectSDK.trustPid().startService(isStub)
  }

  @ReactMethod
  fun startTrustPidServiceAsync(isStub: Boolean, promise: Promise) {
    try {
      FunnelConnectSDK.trustPid().startService(isStub, dataCallback = {
        val idcDataMap = WritableNativeMap()
        idcDataMap.putString("atid", it.atid)
        idcDataMap.putString("mtid", it.mtid)
        promise.resolve(idcDataMap)
      }, errorCallback = {
        promise.reject("startTrustPidServiceAsync", it.returnOrExtractExceptionIfTeavaroRestClientException())
      })
    }
    catch (e: Exception) {
      promise.reject("startTrustPidServiceAsync", e.returnOrExtractExceptionIfTeavaroRestClientException())
    }
  }

  @ReactMethod
  fun acceptConsent() {
    FunnelConnectSDK.trustPid().acceptConsent()
  }

  @ReactMethod
  fun acceptConsentAsync(promise: Promise) {
    try {
      FunnelConnectSDK.trustPid().acceptConsent()
      promise.resolve(null)
    }
    catch (e: Exception) {
      promise.reject("acceptConsentAsync", e.returnOrExtractExceptionIfTeavaroRestClientException())
    }
  }

  @ReactMethod
  fun rejectConsent() {
    FunnelConnectSDK.trustPid().rejectConsent()
  }

  @ReactMethod
  fun rejectConsentAsync(promise: Promise) {
    try {
      FunnelConnectSDK.trustPid().rejectConsent()
      promise.resolve(null)
    }
    catch (e: Exception) {
      promise.reject("rejectConsentAsync", e.returnOrExtractExceptionIfTeavaroRestClientException())
    }
  }

  @ReactMethod
  fun isConsentAcceptedAsync(promise: Promise) {
    try {
      val trustPid = FunnelConnectSDK.trustPid()
      promise.resolve(trustPid.isConsentAccepted())
    }
    catch (e: Exception) {
      promise.reject("isConsentAcceptedAsync", e.returnOrExtractExceptionIfTeavaroRestClientException())
    }
  }

  private fun doIfValidUserInfoOrFail(functionName: String, fcUser: ReadableMap?, promise: Promise, action: (FCUser) -> Unit) {
    val userIdType = fcUser?.getString("userIdType")
    val userId = fcUser?.getString("userId")
    if (userIdType != null && userId != null) {
      action(FCUser(userIdType, userId))
    }
    else {
      promise.reject(functionName, Throwable("Invalid user info"))
    }
  }

  private fun permissionsMapFromReadableMap(permissions: ReadableMap): PermissionsMap {
    val permissionsMap = PermissionsMap()
    permissions.toHashMap().mapValues { it.value.toString().toBoolean() }.forEach {
      permissionsMap.addPermission(it.key, it.value)
    }
    return permissionsMap
  }

  private fun doIfEmptyPermissionsOrNot(permissions: ReadableMap, permissionsAction: (PermissionsMap) -> Unit, emptyPermissionsAction: () -> Unit = {}) {
    val permissionsMap = this.permissionsMapFromReadableMap(permissions)
    if (permissionsMap.isEmpty()) emptyPermissionsAction() else permissionsAction(permissionsMap)
  }
}
