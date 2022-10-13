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
      promise.resolve("")
    }, errorCallback = {
      promise.reject(it)
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
      promise.reject(e)
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
      promise.reject(e)
    }
  }

  // CDP service functions
  @ReactMethod
  fun startCdpServiceAsync(fcUser: ReadableMap?, promise: Promise) {
    val userIdType = fcUser?.getString("userIdType")
    val userId = fcUser?.getString("userId")
    if (userIdType != null && userId != null) {
      val fcUserObj = FCUser(userIdType, userId)
      try {
        FunnelConnectSDK.cdp().setUser(fcUserObj)
        promise.resolve("")
      }
      catch (e: Exception) {
        promise.reject(e)
      }
    }
    else {
      promise.reject(Throwable("Invalid user info"))
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
      promise.reject(e)
    }
  }

  @ReactMethod
  fun setUserAsync(fcUser: ReadableMap, promise: Promise) {
    val userIdType = fcUser.getString("userIdType")
    val userId = fcUser.getString("userId")
    if (userIdType != null && userId != null) {
      val fcUserObj = FCUser(userIdType, userId)
      try {
        FunnelConnectSDK.cdp().setUser(fcUserObj, dataCallback = {
          promise.resolve(it)
        }, errorCallback = {
          promise.reject(it)
        })
      }
      catch (e: Exception) {
        promise.reject(e)
      }
    }
    else {
      promise.reject(Throwable("Invalid user object"))
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
      promise.reject(e)
    }
  }

  @ReactMethod
  fun updatePermissions(permissions: ReadableMap, notificationsVersion: Int) {
    val permissionsMap = PermissionsMap()
    permissions.toHashMap().mapValues { it.value.toString().toBoolean() }.forEach {
      permissionsMap.addPermission(it.key, it.value)
    }
    if (!permissionsMap.isEmpty())
      FunnelConnectSDK.cdp().updatePermissions(permissionsMap, notificationsVersion)
  }

  @ReactMethod
  fun updatePermissionsAsync(permissions: ReadableMap, notificationsVersion: Int, promise: Promise) {
    val permissionsMap = PermissionsMap()
    permissions.toHashMap().mapValues { (it.value).toString().toBoolean() }.forEach {
      permissionsMap.addPermission(it.key, it.value)
    }
    if (!permissionsMap.isEmpty())
      try {
        FunnelConnectSDK.cdp().updatePermissions(permissionsMap, notificationsVersion)
        promise.resolve(null)
      }
      catch (e: Exception) {
        promise.reject(e)
      }
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
        promise.reject(it)
      })
    }
    catch (e: Exception) {
      promise.reject(e)
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
        promise.reject(it)
      })
    }
    catch (e: Exception) {
      promise.reject(e)
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
        promise.reject(it)
      })
    }
    catch (e: Exception) {
      promise.reject(e)
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
      promise.reject(e)
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
      promise.reject(e)
    }
  }

  @ReactMethod
  fun isConsentAcceptedAsync(promise: Promise) {
    try {
      val trustPid = FunnelConnectSDK.trustPid()
      promise.resolve(trustPid.isConsentAccepted())
    }
    catch (e: Exception) {
      promise.reject(e)
    }
  }
}
