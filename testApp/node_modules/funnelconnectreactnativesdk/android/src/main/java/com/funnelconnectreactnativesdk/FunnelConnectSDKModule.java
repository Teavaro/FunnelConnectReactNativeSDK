
package com.funnelconnectreactnativesdk;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

public class FunnelConnectSDKModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;

  public FunnelConnectSDKModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @ReactMethod
  fun initialize(sdkToken: String) {
      val application = reactApplicationContext.applicationContext as Application
      println("Hello Android Context")
  }

  @Override
  public String getName() {
    return "FunnelConnectSDK";
  }
}