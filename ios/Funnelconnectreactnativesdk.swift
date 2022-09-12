
import Foundation
import FunnelConnectSDK

@objc(FunnelConnectSDK)
class Funnelconnectreactnativesdk: NSObject {
    
    // Top level functions
    
    @objc func initializeSDK(_ sdkToken: String, fcOptions: NSDictionary = NSDictionary()) {
        let enableLogging: Bool = fcOptions["enableLogging"] as? Bool ?? false
        let fcOptionsObj = FCOptions(enableLogging: enableLogging)
        FunnelConnectSDK.shared.initialize(sdkToken: sdkToken, options: fcOptionsObj)
    }
    
    @objc func onInitializeAsync(_ resolve: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
        FunnelConnectSDK.shared.didInitializeWithResult { resolve("onInitialize called") } failure: { rejecter(nil, nil, $0) }
    }
    
    @objc func isInitializedAsync(_ resolve: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
        resolve(FunnelConnectSDK.shared.isInitialize())
    }
    
    @objc func clearCookies() {
        try? FunnelConnectSDK.shared.clearData()
    }

    @objc func clearCookiesAsync(_ resolve: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            try FunnelConnectSDK.shared.clearCookies()
            resolve("clearCookies called")
        }
        catch let error {
            rejecter(nil, nil, error)
        }
    }
    
    @objc func clearData() {
        try? FunnelConnectSDK.shared.clearData()
    }
    
    @objc func clearDataAsync(_ resolve: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            try FunnelConnectSDK.shared.clearData()
            resolve("clearData called")
        }
        catch let error {
            rejecter(nil, nil, error)
        }
    }
    
    // CDP service functions
    
    @objc func startCdpServiceAsync(_ fcUser: NSDictionary = NSDictionary(),
                                    resolve: @escaping RCTPromiseResolveBlock,
                                    rejecter: @escaping RCTPromiseRejectBlock) {
       
        let userIdType = fcUser["userIdType"] as? String
        let userId = fcUser["userId"] as? String
        if (userIdType != nil && userId != nil) {
            let fcUserObj = FCUser(userIdType: userIdType!, userId: userId!)
            do {
                try FunnelConnectSDK.shared.cdp().setUser(fcUser: fcUserObj, dataCallback: {
                    resolve($0)
                }, errorCallback: {
                    rejecter(nil, nil, $0)
                })
                resolve("clearData called")
            }
            catch let error {
                rejecter(nil, nil, error)
            }
        }
        else {
            rejecter("Invalid user object", nil, nil)
        }
    }
    
    @objc func getUmidAsync(_ resolve: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            let cdp = try FunnelConnectSDK.shared.cdp()
            resolve(cdp.getUmid())
        }
        catch let error {
            rejecter(nil, nil, error)
        }
    }

    @objc func getUserIdAsync(_ resolve: @escaping RCTPromiseResolveBlock,
                              rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            let cdp = try FunnelConnectSDK.shared.cdp()
            resolve(cdp.getUserId())
        }
        catch let error {
            rejecter(nil, nil, error)
        }
    }

    @objc func setUserAsync(_ fcUser: NSDictionary,
                            resolve: @escaping RCTPromiseResolveBlock,
                            rejecter: @escaping RCTPromiseRejectBlock) {
        let userIdType = fcUser["userIdType"] as? String
        let userId = fcUser["userId"] as? String
        if (userIdType != nil && userId != nil) {
            let fcUserObj = FCUser(userIdType: userIdType!, userId: userId!)
            do {
                try FunnelConnectSDK.shared.cdp().setUser(fcUser: fcUserObj, dataCallback: {
                    resolve($0)
                }, errorCallback: {
                    rejecter(nil, nil, $0)
                })
            }
            catch let error {
                rejecter(nil, nil, error)
            }
        }
        else {
            rejecter("Invalid user info", nil, nil)
        }
    }

    @objc func getPermissionsAsync(_ resolve: @escaping RCTPromiseResolveBlock,
                                   rejecter: @escaping RCTPromiseRejectBlock) {
        var permissionsDictionary = [String: String]()
        do {
            let permissions = try FunnelConnectSDK.shared.cdp().getPermissions()
            permissions.getAllKeys().forEach {
                if let key = $0 as? String {
                    permissionsDictionary[key] = permissions.getPermission(key: key).description
                }
                else {
                    rejecter("Invalid permission keys", nil, nil)
                }
            }
            resolve(permissionsDictionary)
        }
        catch let error {
            rejecter(nil, nil, error)
        }
    }

    @objc func updatePermissions(_ permissions: NSDictionary, notificationsVersion: Int) {
        let permissionsMap = PermissionsMap()
        permissions.map { (($0 as! String), Bool($1 as! String) ?? false) }.forEach {
            permissionsMap.addPermission(key: $0, accepted: $1)
          }
        if (!permissionsMap.isEmpty()) {
            try? FunnelConnectSDK.shared.cdp().updatePermissions(permissions: permissionsMap, notificationsVersion: Int32(notificationsVersion))
        }
    }

    @objc func updatePermissionsAsync(_ permissions: NSDictionary,
                                      notificationsVersion: Int,
                                      resolve: @escaping RCTPromiseResolveBlock,
                                      rejecter: @escaping RCTPromiseRejectBlock) {
        
        let permissionsMap = PermissionsMap()
        Dictionary(uniqueKeysWithValues: permissions.map { ($0 as! String, Bool($1 as! String) ?? false) }).forEach {
            permissionsMap.addPermission(key: $0, accepted: $1)
        }
        if (!permissionsMap.isEmpty()) {
            do {
                try FunnelConnectSDK.shared.cdp().updatePermissions(permissions: permissionsMap, notificationsVersion: Int32(notificationsVersion))
                resolve("updatePermissionsAsync called")
            }
            catch let error {
                rejecter(nil, nil, error)
            }
        }
    }

    @objc func logEvent(_ key: String, value: String) {
        try? FunnelConnectSDK.shared.cdp().logEvent(key: key, value: value)
    }

    @objc func logEventAsync(_ key: String, value: String,
                             resolve: @escaping RCTPromiseResolveBlock,
                             rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            try FunnelConnectSDK.shared.cdp().logEvent(key: key, value: value, successCallback: {
                resolve("logEvent called")
            }, errorCallback: {
                rejecter(nil, nil, $0)
            })
        }
        catch let error {
            rejecter(nil, nil, error)
        }
    }

    @objc func logEvents(_ events: NSDictionary) {
        let eventsDictionary = Dictionary(uniqueKeysWithValues: events.map { ($0 as! String, $1 as! String) })
        try? FunnelConnectSDK.shared.cdp().logEvents(events: eventsDictionary)
    }

    @objc func logEventsAsync(_ events: NSDictionary,
                              resolve: @escaping RCTPromiseResolveBlock,
                              rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            let eventsDictionary = Dictionary(uniqueKeysWithValues: events.map { ($0 as! String, $1 as! String) })
            try FunnelConnectSDK.shared.cdp().logEvents(events: eventsDictionary, successCallback: {
                resolve("logEventsAsync called")
            }, errorCallback: {
                rejecter(nil, nil, $0)
            })
        }
        catch let error {
            rejecter(nil, nil, error)
        }
    }
    
    // TrustPid service functions
    
    @objc func startTrustPidService() {
        try? FunnelConnectSDK.shared.trustPid().startService()
    }
    
    @objc func startTrustPidService(_ isStub: DarwinBoolean) {
        try? FunnelConnectSDK.shared.trustPid().startService(isStub: isStub.boolValue)
    }

    @objc func startTrustPidServiceAsync(_ isStub: DarwinBoolean,
                                         resolve: @escaping RCTPromiseResolveBlock,
                                         rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            try FunnelConnectSDK.shared.trustPid().startService(isStub: isStub.boolValue, dataCallback: {
                resolve($0)
            }, errorCallback: {
                rejecter(nil, nil, $0)
            })
        }
        catch let error {
            rejecter(nil, nil, error)
        }
    }

    @objc func acceptConsent() {
        try? FunnelConnectSDK.shared.trustPid().acceptConsent()
    }

    @objc func acceptConsentAsync(_ resolve: @escaping RCTPromiseResolveBlock,
                                  rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            try FunnelConnectSDK.shared.trustPid().acceptConsent()
            resolve("acceptConsentAsync called")
        }
        catch let error {
            rejecter(nil, nil, error)
        }
    }

    @objc func rejectConsent() {
        try? FunnelConnectSDK.shared.trustPid().rejectConsent()
    }
    
    @objc func rejectConsentAsync(_ resolve: @escaping RCTPromiseResolveBlock,
                                  rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            try FunnelConnectSDK.shared.trustPid().rejectConsent()
            resolve("rejectConsentAsync called")
        }
        catch let error {
            rejecter(nil, nil, error)
        }
    }

    @objc func isConsentAcceptedAsync(_ resolve: @escaping RCTPromiseResolveBlock,
                                      rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            try FunnelConnectSDK.shared.trustPid().isConsentAccepted()
            resolve("isConsentAcceptedAsync called")
        }
        catch let error {
            rejecter(nil, nil, error)
        }
    }
}
