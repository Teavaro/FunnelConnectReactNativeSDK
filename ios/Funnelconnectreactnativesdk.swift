
// import FunnelConnectSDK
import Foundation

@objc(FunnelConnectSDK)
class Funnelconnectreactnativesdk: NSObject {
    
    // Top level functions
    
    @objc func initializeSDK(_ sdkToken: String, fcOptions: NSDictionary = NSDictionary()) {
        let enableLogging: Bool = fcOptions["enableLogging"] as? Bool ?? false
       // let fcOptionsObj = FCOptions(enableLogging: enableLogging)
       // FunnelConnectSDK.shared.initialize(sdkToken: sdkToken, options: fcOptionsObj)
    }
    
    @objc func onInitializeAsync(_ resolve: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock) {
        resolve("onInitialize called")
    }
    
    @objc func isInitializedAsync(_ resolve: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock) {
        resolve(true)
    }
    
    @objc func clearCookies() {
    
    }

    @objc func clearCookiesAsync(_ resolve: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock) {
        resolve("clearCookies called")
    }
    
    @objc func clearData() {

    }
    
    @objc func clearDataAsync(_ resolve: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock) {
        resolve("clearData called")
    }
    
    // CDP service functions
    
    @objc func startCdpServiceAsync(_ fcUser: NSDictionary = NSDictionary(), resolve: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock) {
        resolve("startCdpServiceAsync called")
    }
    
    @objc func getUmidAsync(_ resolve: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock) {
        resolve("getUmidAsync called")
    }

    @objc func getUserIdAsync(_ resolve: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock) {
        resolve("getUserIdAsync called")
    }

    @objc func setUserAsync(_ fcUser: NSDictionary, resolve: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock) {
        resolve("setUserAsync called")
      }

    @objc func getPermissionsAsync(_ resolve: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock) {
        resolve("getPermissionsAsync called")
      }

    @objc func updatePermissions(_ permissions: NSDictionary, notificationsVersion: Int) {

    }

    @objc func updatePermissionsAsync(_ permissions: NSDictionary, notificationsVersion: Int, resolve: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock) {
        resolve("updatePermissionsAsync called")
    }

    @objc func logEvent(_ key: String, value: String) {
    
    }

    @objc func logEventAsync(_ key: String, value: String, resolve: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock) {
        resolve("logEventAsync called")
    }

    @objc func logEvents(_ events: NSDictionary) {
       
    }

    @objc func logEventsAsync(_ events: NSDictionary, resolve: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock) {
        resolve("logEventsAsync called")
    }
    
    // TrustPid service functions
    
    @objc func startTrustPidService(_ isStub: DarwinBoolean) {

    }

    @objc func startTrustPidServiceAsync(_ isStub: DarwinBoolean, resolve: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock) {
        resolve("startTrustPidServiceAsync called")
    }

    @objc func acceptConsent() {

    }

    @objc func acceptConsentAsync(_ resolve: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock) {
        resolve("acceptConsentAsync called")

    }

    @objc func rejectConsent() {

    }
    
    @objc func rejectConsentAsync(_ resolve: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock) {
        resolve("rejectConsentAsync called")
    }

    @objc func isConsentAcceptedAsync(_ resolve: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock) {
        resolve("isConsentAcceptedAsync called")
    }
}
