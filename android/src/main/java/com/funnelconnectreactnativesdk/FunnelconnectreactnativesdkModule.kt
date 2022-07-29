package com.funnelconnectreactnativesdk
import android.app.Application
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise
import com.teavaro.funnelConnect.core.initializer.FunnelConnectSDK
import com.teavaro.funnelConnect.core.services.ErrorCallback
import com.teavaro.funnelConnect.core.services.cdp.DataCallback

class FunnelconnectreactnativesdkModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String {
        return "Funnelconnectreactnativesdk"
    }

    @ReactMethod
    fun initializeSDK() {
      FunnelConnectSDK.initialize(reactContext.applicationContext as Application, 123)
    }

  @ReactMethod
  fun startCDP() {
    FunnelConnectSDK.cdp().startService(dataCallback = {
         println("RNLogger $it")
    }, errorCallback = {
      println("RNLogger Error $it")
    })
  }

  @ReactMethod
  fun getUmid(): String? {
   return FunnelConnectSDK.cdp().getUmid()
  }

    // Example method
    // See https://reactnative.dev/docs/native-modules-android
    @ReactMethod
    fun multiply(a: Int, b: Int, promise: Promise) {
          promise.resolve(a * b)
    }
}
