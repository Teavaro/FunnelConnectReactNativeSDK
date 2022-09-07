package com.funnelconnectreactnativesdk

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager

class FunnelconnectreactnativesdkPackage : ReactPackage {

    override fun createNativeModules(reactContext: ReactApplicationContext) = listOf(FunnelconnectreactnativesdkModule(reactContext))

    override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> = emptyList()
}
