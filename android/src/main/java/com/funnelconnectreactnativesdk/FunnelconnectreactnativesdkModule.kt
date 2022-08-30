package com.funnelconnectreactnativesdk

import android.app.Application
import android.util.Log
import com.facebook.react.bridge.*
import com.teavaro.funnelConnect.core.initializer.FunnelConnectSDK
import com.teavaro.funnelConnect.data.models.dataClasses.FCOptions
import com.teavaro.funnelConnect.data.models.dataClasses.FCUser
import com.teavaro.funnelConnect.utils.PermissionsMap

class FunnelconnectreactnativesdkModule(private val reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return "FunnelConnectReactNativeSDK"
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
    FunnelConnectSDK.onInitialize(successCallback = {
      promise.resolve({})
    }, errorCallback = {
      promise.reject(it)
    })
  }

  @ReactMethod
  fun isInitialized(promise: Promise) {
    promise.resolve(FunnelConnectSDK.isInitialized())
  }

  @ReactMethod
  fun clearCookies() {
    FunnelConnectSDK.clearCookies()
  }

  @ReactMethod
  fun clearCookies(promise: Promise) {
    FunnelConnectSDK.clearCookies()
    promise.resolve({})
  }

  @ReactMethod
  fun clearData() {
    FunnelConnectSDK.clearData()
  }

  @ReactMethod
  fun clearData(promise: Promise) {
    FunnelConnectSDK.clearData()
    promise.resolve({})
  }

  // CDP service functions
  @ReactMethod
  fun startCdpService(fcUser: ReadableMap?, promise: Promise) {
    val userIdType = fcUser?.getString("userIdType")
    val userId = fcUser?.getString("userId")
    if (userIdType != null && userId != null) {
      val fcUserObj = FCUser(userIdType, userId)
      FunnelConnectSDK.cdp().setUser(fcUserObj)
      promise.resolve({})
    }
    else {
      promise.reject(Throwable("Invalid user object"))
    }
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
  fun setUser(fcUser: ReadableMap, promise: Promise) {
    val userIdType = fcUser.getString("userIdType")
    val userId = fcUser.getString("userId")
    if (userIdType != null && userId != null) {
      val fcUserObj = FCUser(userIdType, userId)
      FunnelConnectSDK.cdp().setUser(fcUserObj)
      promise.resolve("Set user complete")
    }
    else {
      promise.reject(Throwable("Invalid user object"))
    }
  }

  @ReactMethod
  fun getPermissions(promise: Promise) {
    val permissionsMap = WritableNativeMap()
    val permissions = FunnelConnectSDK.cdp().getPermissions()
    permissions.getAllKeys().forEach {
      permissionsMap.putBoolean(it, permissions.getPermission(it))
    }
    promise.resolve(permissionsMap)
  }

  @ReactMethod
  fun updatePermissions(permissions: ReadableMap, notificationsVersion: Int) {
    val permissionsMap = PermissionsMap()
    permissions.toHashMap().mapValues { (it.value).toString().toBoolean() }.forEach {
      permissionsMap.addPermission(it.key, it.value)
    }
    if (!permissionsMap.isEmpty())
      FunnelConnectSDK.cdp().updatePermissions(permissionsMap, notificationsVersion)
  }

  @ReactMethod
  fun updatePermissions(permissions: ReadableMap, notificationsVersion: Int, promise: Promise) {
    val permissionsMap = PermissionsMap()
    permissions.toHashMap().mapValues { (it.value).toString().toBoolean() }.forEach {
      permissionsMap.addPermission(it.key, it.value)
    }
    if (!permissionsMap.isEmpty())
      FunnelConnectSDK.cdp().updatePermissions(permissionsMap, notificationsVersion)
    promise.resolve({})
  }

  @ReactMethod
  fun logEvent(key: String, value: String) {
    FunnelConnectSDK.cdp().logEvent(key, value)
  }

  @ReactMethod
  fun logEvent(key: String, value: String, promise: Promise) {
    FunnelConnectSDK.cdp().logEvent(key, value, successCallback = {
       promise.resolve({})
    }, errorCallback = {
       promise.reject(it)
    })
  }

  @ReactMethod
  fun logEvents(events: ReadableMap) {
    println("RN Events $events")
    val eventsMap = events.toHashMap().toMap().mapValues { it.toString() }
    FunnelConnectSDK.cdp().logEvents(eventsMap)
  }

  @ReactMethod
  fun logEvents(events: ReadableMap, promise: Promise) {
    println("RN Events $events")
    val eventsMap = events.toHashMap().toMap().mapValues { it.toString() }
    FunnelConnectSDK.cdp().logEvents(eventsMap, successCallback = {
       promise.resolve({})
    }, errorCallback = {
       promise.reject(it)
    })
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
  fun acceptConsent(promise: Promise) {
    FunnelConnectSDK.trustPid().acceptConsent()
    promise.resolve({})
  }

  @ReactMethod
  fun rejectConsent() {
    FunnelConnectSDK.trustPid().rejectConsent()
  }

  @ReactMethod
  fun rejectConsent(promise: Promise) {
    FunnelConnectSDK.trustPid().rejectConsent()
    promise.resolve({})
  }

  @ReactMethod
  fun isConsentAccepted(promise: Promise) {
    promise.resolve(FunnelConnectSDK.trustPid().isConsentAccepted())
  }
}
