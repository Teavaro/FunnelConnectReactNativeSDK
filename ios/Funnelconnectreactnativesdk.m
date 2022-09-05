#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(FunnelConnectSDK, NSObject)

RCT_EXTERN_METHOD(multiply:(float)a withB:(float)b
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

// Export functions for React Native.

RCT_EXTERN_METHOD(initializeSDK:(NSString *)sdkToken :(NSDictionary *)fcOptions)

//{
//    RCTLogInfo(@"Pretending to create an event");
//}
@end
