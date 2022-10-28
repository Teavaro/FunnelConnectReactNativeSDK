#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(FunnelConnectSDK, NSObject)


+ (BOOL)requiresMainQueueSetup {
  return NO;
}

// Export functions for React Native.

// Top level functions

RCT_EXTERN_METHOD(initializeSDK:(NSString *)sdkToken
                  fcOptions:(NSDictionary *)fcOptions)

RCT_EXTERN_METHOD(onInitializeAsync:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(isInitializedAsync:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(isInitializedAsync:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(clearCookies)

RCT_EXTERN_METHOD(clearCookiesAsync:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(clearData)

RCT_EXTERN_METHOD(clearDataAsync:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

// CDP service functions

RCT_EXTERN_METHOD(startCdpServiceAsync:(NSDictionary *)fcUser
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(startCdpServiceWithNotificationVersionAsync:(NSDictionary *)fcUser
                  notificationsVersion: (int)notificationsVersion
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getUmidAsync:(RCTPromiseResolveBlock)resolver
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getUserIdAsync:(RCTPromiseResolveBlock)resolver
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(setUserAsync:(NSDictionary *)fcUser
                  resolver:(RCTPromiseResolveBlock)resolver
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getPermissionsAsync:(RCTPromiseResolveBlock)resolver
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(updatePermissions:(NSDictionary *)permissions
                  notificationsVersion: (int)notificationsVersion)

RCT_EXTERN_METHOD(updatePermissionsAsync:(NSDictionary *)permissions
                  notificationsVersion: (int)notificationsVersion
                  resolver:(RCTPromiseResolveBlock)resolver
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(logEvent:(NSString *)key value: (NSString *)value)

RCT_EXTERN_METHOD(logEventAsync:(NSString *)key
                  value: (NSString *)value
                  resolver:(RCTPromiseResolveBlock)resolver
                  rejecter:(RCTPromiseRejectBlock)rejecter)

RCT_EXTERN_METHOD(logEvents:(NSDictionary *)events)

RCT_EXTERN_METHOD(logEventsAsync:(NSDictionary *)events
                  resolver:(RCTPromiseResolveBlock)resolver
                  rejecter:(RCTPromiseRejectBlock)rejecter)

// TrustPid service functions

RCT_EXTERN_METHOD(startTrustPidService)

RCT_EXTERN_METHOD(startTrustPidService:(BOOL)isStub)

RCT_EXTERN_METHOD(startTrustPidServiceAsync:(BOOL)isStub
                  resolver:(RCTPromiseResolveBlock)resolver
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(acceptConsent)

RCT_EXTERN_METHOD(acceptConsentAsync:(RCTPromiseResolveBlock)resolver
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(rejectConsent)

RCT_EXTERN_METHOD(rejectConsentAsync:(RCTPromiseResolveBlock)resolver
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(isConsentAcceptedAsync:(RCTPromiseResolveBlock)resolver
                  rejecter:(RCTPromiseRejectBlock)reject)
@end
