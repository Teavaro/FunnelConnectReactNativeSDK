package com.funnelconnectreactnativesdk

import android.app.Application
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod

class FunnelConnectSDKModule(reactContext: ReactApplicationContext): ReactContextBaseJavaModule(reactContext) {

    @ReactMethod
    fun initialize(sdkToken: String) {
        val application = reactApplicationContext.applicationContext as Application
        println("Hello Android Context")
    }

    // Mandatory function getName that specifies the module name
    override fun getName() = "FunnelConnectSDK"
}