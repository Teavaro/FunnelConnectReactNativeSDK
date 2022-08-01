package com.funnelconnectreactnativesdk
import android.app.Application
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise
// import com.teavaro.funnelConnect.core.initializer.FunnelConnectSDK
import com.teavaro.funnelConnect.core.services.ErrorCallback
import com.teavaro.funnelConnect.core.services.cdp.DataCallback

class FunnelconnectreactnativesdkModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
      return "Funnelconnectreactnativesdk"
  }

  @ReactMethod
  fun printNativeLog() {
    println("Native log printed...")
  }

  @ReactMethod
  fun getStaticString(): String {
   return "Test of static string from native module"
  }

  @ReactMethod
  fun resolveMultiplicationPromise(a: Int, b: Int, promise: Promise) {
    promise.resolve(a * b)
  }

  @ReactMethod
  fun callCallback(name: String, location: String, callback: Callback) {
    callback.invoke(name, location)
  }
}
