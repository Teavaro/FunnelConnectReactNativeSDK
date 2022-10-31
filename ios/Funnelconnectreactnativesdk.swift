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
    
    @objc func onInitializeAsync(_ resolver: @escaping RCTPromiseResolveBlock,
                                 rejecter: @escaping RCTPromiseRejectBlock) {
        FunnelConnectSDK.shared.didInitializeWithResult {
            resolver(nil)
        } failure: {
            rejecter("onInitializeAsync", "onInitializeAsync \($0.localizedDescription)", $0)
        }
    }
    
    @objc func isInitializedAsync(_ resolver: @escaping RCTPromiseResolveBlock,
                                  rejecter: @escaping RCTPromiseRejectBlock) {
        resolver(FunnelConnectSDK.shared.isInitialize())
    }
    
    @objc func clearCookies() {
        try? FunnelConnectSDK.shared.clearData()
    }

    @objc func clearCookiesAsync(_ resolver: @escaping RCTPromiseResolveBlock,
                                 rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            try FunnelConnectSDK.shared.clearCookies()
            resolver(nil)
        }
        catch let error {
            rejecter("clearCookiesAsync", "clearCookiesAsync \(error.localizedDescription)", error)
        }
    }
    
    @objc func clearData() {
        try? FunnelConnectSDK.shared.clearData()
    }
    
    @objc func clearDataAsync(_ resolver: @escaping RCTPromiseResolveBlock,
                              rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            try FunnelConnectSDK.shared.clearData()
            resolver(nil)
        }
        catch let error {
            rejecter("clearDataAsync", "clearDataAsync \(error.localizedDescription)", error)
        }
    }
    
    // CDP service functions
    
    @objc func startCdpServiceAsync(_ fcUser: NSDictionary = NSDictionary(),
                                    resolver: @escaping RCTPromiseResolveBlock,
                                    rejecter: @escaping RCTPromiseRejectBlock) {
       
        let userIdType = fcUser["userIdType"] as? String
        let userId = fcUser["userId"] as? String
        if (userIdType != nil && userId != nil) {
            let fcUserObj = FCUser(userIdType: userIdType!, userId: userId!)
            do {
                try FunnelConnectSDK.shared.cdp().setUser(fcUser: fcUserObj, dataCallback: {
                    resolver($0)
                }, errorCallback: {
                    rejecter("startCdpServiceAsync", "startCdpServiceAsync \($0.localizedDescription)", $0)
                })
            }
            catch let error {
                rejecter("startCdpServiceAsync", "startCdpServiceAsync \(error.localizedDescription)", error)
            }
        }
        else {
            rejecter("startCdpServiceAsync", "Invalid user object", nil)
        }
    }
    
    @objc func startCdpServiceWithNotificationVersionAsync(_ fcUser: NSDictionary = NSDictionary(),
                                    notificationsVersion: Int,
                                    resolver: @escaping RCTPromiseResolveBlock,
                                    rejecter: @escaping RCTPromiseRejectBlock) {
       
        let userIdType = fcUser["userIdType"] as? String
        let userId = fcUser["userId"] as? String
        if (userIdType != nil && userId != nil) {
            let fcUserObj = FCUser(userIdType: userIdType!, userId: userId!)
            do {
                try FunnelConnectSDK.shared.cdp().startService(fcUser: fcUserObj, notificationsVersion: Int32(notificationsVersion), dataCallback: {
                    resolver($0)
                }, errorCallback: {
                    rejecter("startCdpServiceWithNotificationVersionAsync", "startCdpServiceWithNotificationVersionAsync \($0.localizedDescription)", $0)
                })
            }
            catch let error {
                rejecter("startCdpServiceWithNotificationVersionAsync", "startCdpServiceWithNotificationVersionAsync \(error.localizedDescription)", error)
            }
        }
        else {
            rejecter("startCdpServiceWithNotificationVersionAsync", "Invalid user object", nil)
        }
    }
    
    @objc func getUmidAsync(_ resolver: @escaping RCTPromiseResolveBlock,
                            rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            let cdp = try FunnelConnectSDK.shared.cdp()
            resolver(cdp.getUmid())
        }
        catch let error {
            rejecter("getUmidAsync", "getUmidAsync \(error.localizedDescription)", error)
        }
    }

    @objc func getUserIdAsync(_ resolver: @escaping RCTPromiseResolveBlock,
                              rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            let cdp = try FunnelConnectSDK.shared.cdp()
            resolver(cdp.getUserId())
        }
        catch let error {
            rejecter("getUserIdAsync", "getUserIdAsync \(error.localizedDescription)", error)
        }
    }

    @objc func setUserAsync(_ fcUser: NSDictionary,
                            resolver: @escaping RCTPromiseResolveBlock,
                            rejecter: @escaping RCTPromiseRejectBlock) {
        let userIdType = fcUser["userIdType"] as? String
        let userId = fcUser["userId"] as? String
        if (userIdType != nil && userId != nil) {
            let fcUserObj = FCUser(userIdType: userIdType!, userId: userId!)
            do {
                try FunnelConnectSDK.shared.cdp().setUser(fcUser: fcUserObj, dataCallback: {
                    resolver($0)
                }, errorCallback: {
                    rejecter(nil, nil, $0)
                })
            }
            catch let error {
                rejecter("setUserAsync", "setUserAsync \(error.localizedDescription)", error)
            }
        }
        else {
            rejecter("setUserAsync", "Invalid user info", nil)
        }
    }

    @objc func getPermissionsAsync(_ resolver: @escaping RCTPromiseResolveBlock,
                                   rejecter: @escaping RCTPromiseRejectBlock) {
        var permissionsDictionary = [String: String]()
        do {
            let permissions = try FunnelConnectSDK.shared.cdp().getPermissions()
            permissions.getAllKeys().forEach {
                if let key = $0 as? String {
                    permissionsDictionary[key] = permissions.getPermission(key: key).description
                }
                else {
                    rejecter("getPermissionsAsync", "Invalid permission keys", nil)
                }
            }
            resolver(permissionsDictionary)
        }
        catch let error {
            rejecter("getPermissionsAsync", "getPermissionsAsync \(error.localizedDescription)", error)
            rejecter(nil, nil, error)
        }
    }

    @objc func updatePermissions(_ permissions: NSDictionary, notificationsVersion: Int) {
        let permissionsMap = PermissionsMap()
        permissions.map { (($0 as! String), $1 as! Bool ?? false) }.forEach {
            permissionsMap.addPermission(key: $0, accepted: $1)
        }
        if (!permissionsMap.isEmpty()) {
            try? FunnelConnectSDK.shared.cdp().updatePermissions(permissions: permissionsMap, notificationsVersion: Int32(notificationsVersion), dataCallback: { _ in
            }, errorCallback: { _ in })
        }
    }

    @objc func updatePermissionsAsync(_ permissions: NSDictionary,
                                      notificationsVersion: Int,
                                      resolver: @escaping RCTPromiseResolveBlock,
                                      rejecter: @escaping RCTPromiseRejectBlock) {
        
        let permissionsMap = PermissionsMap()
        Dictionary(uniqueKeysWithValues: permissions.map { (($0 as! String), $1 as! Bool ?? false) }).forEach {
            permissionsMap.addPermission(key: $0, accepted: $1)
        }
        if (!permissionsMap.isEmpty()) {
            do {
                try FunnelConnectSDK.shared.cdp().updatePermissions(permissions: permissionsMap, notificationsVersion: Int32(notificationsVersion), dataCallback: {
                    resolver($0)
                }, errorCallback: {
                    rejecter("updatePermissionsAsync", "updatePermissionsAsync \($0.localizedDescription)", $0)
                })
            }
            catch let error {
                rejecter("updatePermissionsAsync", "updatePermissionsAsync \(error.localizedDescription)", error)
            }
        }
    }
    
    @objc func logEvent(_ key: String, value: String) {
        try? FunnelConnectSDK.shared.cdp().logEvent(key: key, value: value)
    }

    @objc func logEventAsync(_ key: String, value: String,
                             resolver: @escaping RCTPromiseResolveBlock,
                             rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            try FunnelConnectSDK.shared.cdp().logEvent(key: key, value: value, successCallback: {
                resolver(nil)
            }, errorCallback: {
                rejecter("logEventAsync", "logEventAsync \($0.localizedDescription)", $0)
            })
        }
        catch let error {
            rejecter("logEventAsync", "logEventAsync \(error.localizedDescription)", error)
        }
    }

    @objc func logEvents(_ events: NSDictionary) {
        let eventsDictionary = Dictionary(uniqueKeysWithValues: events.map { ($0 as! String, $1 as! String) })
        try? FunnelConnectSDK.shared.cdp().logEvents(events: eventsDictionary)
    }

    
    @objc func logEventsAsync(_ events: NSDictionary,
                              resolver: @escaping RCTPromiseResolveBlock,
                              rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            let eventsDictionary = Dictionary(uniqueKeysWithValues: events.map { ($0 as! String, $1 as! String) })
            try FunnelConnectSDK.shared.cdp().logEvents(events: eventsDictionary, successCallback: {
                resolver(nil)
            }, errorCallback: {
                rejecter("logEventsAsync", "logEventsAsync \($0.localizedDescription)", $0)
            })
        }
        catch let error {
            rejecter("logEventsAsync", "logEventsAsync \(error.localizedDescription)", error)
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
                                         resolver: @escaping RCTPromiseResolveBlock,
                                         rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            try FunnelConnectSDK.shared.trustPid().startService(isStub: isStub.boolValue, dataCallback: {
                var idcDataDictionary = NSMutableDictionary()
                idcDataDictionary["mtid"] = $0.mtid
                idcDataDictionary["atid"] = $0.atid
                resolver(idcDataDictionary)
            }, errorCallback: {
                rejecter("startTrustPidServiceAsync", "startTrustPidServiceAsync \($0.localizedDescription)", $0)
            })
        }
        catch let error {
            rejecter("clearCookiesAsync", "clearCookiesAsync \(error.localizedDescription)", error)
        }
    }

    @objc func acceptConsent() {
        try? FunnelConnectSDK.shared.trustPid().acceptConsent()
    }

    @objc func acceptConsentAsync(_ resolver: @escaping RCTPromiseResolveBlock,
                                  rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            try FunnelConnectSDK.shared.trustPid().acceptConsent()
            resolver(nil)
        }
        catch let error {
            rejecter("acceptConsentAsync", "acceptConsentAsync \(error.localizedDescription)", error)
        }
    }

    @objc func rejectConsent() {
        try? FunnelConnectSDK.shared.trustPid().rejectConsent()
    }
    
    @objc func rejectConsentAsync(_ resolver: @escaping RCTPromiseResolveBlock,
                                  rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            try FunnelConnectSDK.shared.trustPid().rejectConsent()
            resolver(nil)
        }
        catch let error {
            rejecter("rejectConsentAsync", "rejectConsentAsync \(error.localizedDescription)", error)
        }
    }

    @objc func isConsentAcceptedAsync(_ resolver: @escaping RCTPromiseResolveBlock,
                                      rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            try FunnelConnectSDK.shared.trustPid().isConsentAccepted()
            resolver(nil)
        }
        catch let error {
            rejecter("isConsentAcceptedAsync", "isConsentAcceptedAsync \(error.localizedDescription)", error)
        }
    }
}
