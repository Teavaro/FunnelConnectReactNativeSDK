package com.teavaro.funnelConnect.core.initializer

import android.app.Application
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.teavaro.funnelConnect.data.models.dataClasses.FCOptions

class FunnelConnectSDKModule(reactContext: ReactApplicationContext): ReactContextBaseJavaModule(reactContext) {

    @ReactMethod
    fun initialize(sdkToken: String, options: FCOptions = FCOptions()) {
        val application = reactApplicationContext.applicationContext as Application
        FunnelConnectSDK.initialize(application, "test123")
    }

    // Mandatory function getName that specifies the module name
    override fun getName() = "FunnelConnectSDK"

    @ReactMethod
    fun cdp() = funnelConnect.cdp()

    fun trustPid() = funnelConnect.trustPid()

    fun clearCookies() {
        funnelConnect.clearCookies()
    }

    fun clearData() {
        funnelConnect.clearData()
    }
}