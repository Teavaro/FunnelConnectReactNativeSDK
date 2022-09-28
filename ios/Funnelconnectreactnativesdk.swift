
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
            resolver({})
        } failure: {
            rejecter(nil, nil, $0)
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
            resolver({})
        }
        catch let error {
            rejecter(nil, nil, error)
        }
    }
    
    @objc func clearData() {
        try? FunnelConnectSDK.shared.clearData()
    }
    
    @objc func clearDataAsync(_ resolver: @escaping RCTPromiseResolveBlock,
                              rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            try FunnelConnectSDK.shared.clearData()
            resolver({})
        }
        catch let error {
            rejecter(nil, nil, error)
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
                    rejecter(nil, nil, $0)
                })
                resolver("clearData called")
            }
            catch let error {
                rejecter(nil, nil, error)
            }
        }
        else {
            rejecter("Invalid user object", nil, nil)
        }
    }
    
    @objc func getUmidAsync(_ resolver: @escaping RCTPromiseResolveBlock,
                            rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            let cdp = try FunnelConnectSDK.shared.cdp()
            resolver(cdp.getUmid())
        }
        catch let error {
            rejecter(nil, nil, error)
        }
    }

    @objc func getUserIdAsync(_ resolver: @escaping RCTPromiseResolveBlock,
                              rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            let cdp = try FunnelConnectSDK.shared.cdp()
            resolver(cdp.getUserId())
        }
        catch let error {
            rejecter(nil, nil, error)
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
                rejecter(nil, nil, error)
            }
        }
        else {
            rejecter("Invalid user info", nil, nil)
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
                    rejecter("Invalid permission keys", nil, nil)
                }
            }
            resolver(permissionsDictionary)
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
            try? FunnelConnectSDK.shared.cdp().updatePermissions(permissions: permissionsMap, notificationsVersion: Int32(notificationsVersion), dataCallback: { _ in
            }, errorCallback: { _ in })
        }
    }

    @objc func updatePermissionsAsync(_ permissions: NSDictionary,
                                      notificationsVersion: Int,
                                      resolver: @escaping RCTPromiseResolveBlock,
                                      rejecter: @escaping RCTPromiseRejectBlock) {
        
        let permissionsMap = PermissionsMap()
        Dictionary(uniqueKeysWithValues: permissions.map { ($0 as! String, Bool($1 as! String) ?? false) }).forEach {
            permissionsMap.addPermission(key: $0, accepted: $1)
        }
        if (!permissionsMap.isEmpty()) {
            do {
                try FunnelConnectSDK.shared.cdp().updatePermissions(permissions: permissionsMap, notificationsVersion: Int32(notificationsVersion), dataCallback: {
                    resolver($0)
                }, errorCallback: {
                    rejecter(nil, nil, $0)
                })
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
                             resolver: @escaping RCTPromiseResolveBlock,
                             rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            try FunnelConnectSDK.shared.cdp().logEvent(key: key, value: value, successCallback: {
                resolver("logEvent called")
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
                              resolver: @escaping RCTPromiseResolveBlock,
                              rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            let eventsDictionary = Dictionary(uniqueKeysWithValues: events.map { ($0 as! String, $1 as! String) })
            try FunnelConnectSDK.shared.cdp().logEvents(events: eventsDictionary, successCallback: {
                resolver({})
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
                                         resolver: @escaping RCTPromiseResolveBlock,
                                         rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            try FunnelConnectSDK.shared.trustPid().startService(isStub: isStub.boolValue, dataCallback: {
                var idcDataDictionary = NSMutableDictionary()
                idcDataDictionary["mtid"] = $0.mtid
                idcDataDictionary["atid"] = $0.atid
                resolver(idcDataDictionary)
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

    @objc func acceptConsentAsync(_ resolver: @escaping RCTPromiseResolveBlock,
                                  rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            try FunnelConnectSDK.shared.trustPid().acceptConsent()
            resolver({})
        }
        catch let error {
            rejecter(nil, nil, error)
        }
    }

    @objc func rejectConsent() {
        try? FunnelConnectSDK.shared.trustPid().rejectConsent()
    }
    
    @objc func rejectConsentAsync(_ resolver: @escaping RCTPromiseResolveBlock,
                                  rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            try FunnelConnectSDK.shared.trustPid().rejectConsent()
            resolver({})
        }
        catch let error {
            rejecter(nil, nil, error)
        }
    }

    @objc func isConsentAcceptedAsync(_ resolver: @escaping RCTPromiseResolveBlock,
                                      rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            try FunnelConnectSDK.shared.trustPid().isConsentAccepted()
            resolver({})
        }
        catch let error {
            rejecter(nil, nil, error)
        }
    }
}
