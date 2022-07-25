package com.teavaro.funnelConnect.core.initializer

import android.view.View
import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ReactShadowNode
import com.facebook.react.uimanager.ViewManager

class FunnelConnectSDKPackage : ReactPackage {
    override fun createNativeModules(
        reactContext: ReactApplicationContext
    ): MutableList<NativeModule> = listOf(FunnelConnectSDKModule(reactContext)).toMutableList()
}

// https://github.com/facebook/react-native/blob/main/ReactAndroid/src/main/java/com/facebook/react/TurboReactPackage.java
// https://reactnative.dev/docs/native-modules-android
