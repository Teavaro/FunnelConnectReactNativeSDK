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
        try? FunnelConnectSDK.shared.clearCookies()
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
        self.doIfValidUserInfoOrFail(functionName: "startCdpServiceAsync", fcUser: fcUser, rejecter: rejecter) {
            do {
                try FunnelConnectSDK.shared.cdp().startService(fcUser: $0, dataCallback: {
                    resolver($0)
                }, errorCallback: {
                    rejecter("startCdpServiceAsync", "startCdpServiceAsync \($0.localizedDescription)", $0)
                })
            }
            catch let error {
                rejecter("startCdpServiceAsync", "startCdpServiceAsync \(error.localizedDescription)", error)
            }
        }
    }
    
    @objc func startCdpServiceWithNotificationsVersionAsync(_ fcUser: NSDictionary = NSDictionary(),
                                                           notificationsVersion: Int,
                                                           resolver: @escaping RCTPromiseResolveBlock,
                                                           rejecter: @escaping RCTPromiseRejectBlock) {
        self.doIfValidUserInfoOrFail(functionName: "startCdpServiceWithNotificationVersionAsync",
                                     fcUser: fcUser,
                                     rejecter: rejecter) { fcUserObj in
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
        self.doIfValidUserInfoOrFail(functionName: "setUserAsync", fcUser: fcUser, rejecter: rejecter) {
            do {
                try FunnelConnectSDK.shared.cdp().setUser(fcUser: $0, dataCallback: {
                    resolver($0)
                }, errorCallback: {
                    rejecter(nil, nil, $0)
                })
            }
            catch let error {
                rejecter("setUserAsync", "setUserAsync \(error.localizedDescription)", error)
            }
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
        self.doIfEmptyPermissionsOrNot(permissions: permissions) { permissionsMap in
            try? FunnelConnectSDK.shared.cdp().updatePermissions(permissions: permissionsMap,
                                                                 notificationsVersion: Int32(notificationsVersion),
                                                                 dataCallback: { _ in },
                                                                 errorCallback: { _ in })
        }
    }

    @objc func updatePermissionsAsync(_ permissions: NSDictionary,
                                      notificationsVersion: Int,
                                      resolver: @escaping RCTPromiseResolveBlock,
                                      rejecter: @escaping RCTPromiseRejectBlock) {
        self.doIfEmptyPermissionsOrNot(permissions: permissions) { permissionsMap in
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
        } emptyPermissionsAction: {
            let error = NSError(domain: "Empty Permissions!", code: -1991)
            rejecter("updatePermissionsAsync", "updatePermissionsAsync \(error.localizedDescription)", error)
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
        let eventsDictionary = self.nsDictionaryToSwiftDictionary(events: events)
        try? FunnelConnectSDK.shared.cdp().logEvents(events: eventsDictionary)
    }

    
    @objc func logEventsAsync(_ events: NSDictionary,
                              resolver: @escaping RCTPromiseResolveBlock,
                              rejecter: @escaping RCTPromiseRejectBlock) {
        do {
            let eventsDictionary = self.nsDictionaryToSwiftDictionary(events: events)
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
    
    private func doIfValidUserInfoOrFail(functionName: String, fcUser: NSDictionary?, rejecter: @escaping RCTPromiseRejectBlock, action: (FCUser) -> Void) {
        let userIdType = fcUser?["userIdType"] as? String
        let userId = fcUser?["userId"] as? String
        if (userIdType != nil && userId != nil) {
            action(FCUser(userIdType: userIdType!, userId: userId!))
        }
        else {
            rejecter(functionName, "Invalid user info", nil)
        }
     }
    
    private func permissionsMapFromReadableMap(permissions: NSDictionary) -> PermissionsMap {
        let permissionsMap = PermissionsMap()
        Dictionary(uniqueKeysWithValues: permissions.map { (($0 as! String), $1 as? Bool ?? false) }).forEach {
            permissionsMap.addPermission(key: $0, accepted: $1)
        }
        return permissionsMap
    }

     private func doIfEmptyPermissionsOrNot(permissions: NSDictionary, permissionsAction: (PermissionsMap) -> Void, emptyPermissionsAction: () -> Void = {}) {
         let permissionsMap = self.permissionsMapFromReadableMap(permissions: permissions)
         if (permissionsMap.isEmpty()) { emptyPermissionsAction() } else { permissionsAction(permissionsMap) }
     }
    
    private func nsDictionaryToSwiftDictionary(events: NSDictionary) -> [String : String] {
        return Dictionary(uniqueKeysWithValues: events.map { ($0 as! String, $1 as! String) })
    }
}
