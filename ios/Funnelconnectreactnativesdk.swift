
import FunnelConnectSDK

@objc(Funnelconnectreactnativesdk)
class Funnelconnectreactnativesdk: NSObject {

  @objc(multiply:withB:withResolver:withRejecter:)
  func multiply(a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
    resolve(a*b)
  }
    
    // Top level functions
    @objc func initializeSDK(sdkToken: String, fcOptions: NSDictionary = NSDictionary()) {
        let enableLogging: Bool = fcOptions["enableLogging"] as? Bool ?? false
        let fcOptionsObj = FCOptions(enableLogging: enableLogging)
        FunnelConnectSDK.shared.initialize(sdkToken: sdkToken, options: fcOptionsObj)
    }
    
   @objc(multiply:withB:withResolver:withRejecter:)
    func multiply() {
        FunnelConnectSDK.shared.cdp()
   }
}
