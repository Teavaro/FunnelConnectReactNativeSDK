import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'FunnelConnectReactNativeSDK' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const Funnelconnectreactnativesdk = NativeModules.FunnelConnectReactNativeSDK
  ? NativeModules.FunnelConnectReactNativeSDK
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

// TODO: Move types to external file when all of the shapes are decided
type PermissionsMap = {
  [key: string]: boolean;
};

type FCOptions = {
  enableLogging: boolean;
};

type FCUser = {
  userIdType: string;
  userId: string;
};

type startTrustPidServiceOutput = {
  atid: string;
  mtid: string;
};

type LogEvent = {
  key: string;
  value: string;
};

// Top level functions
const initializeSDK = (
  sdkToken: string,
  { enableLogging = true }: FCOptions
): void => {
  Funnelconnectreactnativesdk.initializeSDK(sdkToken, { enableLogging });
};

const onInitialize = (): Promise<string> => {
  return Funnelconnectreactnativesdk.onInitialize();
};

const isInitialized = (): Promise<boolean> => {
  return Funnelconnectreactnativesdk.isInitialized();
};

const clearCookies = (): void => {
  Funnelconnectreactnativesdk.clearCookies();
};

const clearCookiesPromise = (): Promise<string> => {
  return Funnelconnectreactnativesdk.clearCookies();
};

const clearData = (): void => {
  Funnelconnectreactnativesdk.clearData();
};

const clearDataPromise = (): Promise<string> => {
  return Funnelconnectreactnativesdk.clearData();
};

// CDP service functions
const cdp = () => {
  return {
    startService: (fcUser: FCUser | null = null): Promise<string> => {
      return Funnelconnectreactnativesdk.startCdpService(fcUser);
    },
    getUmid: (): Promise<string> => {
      return Funnelconnectreactnativesdk.getUmid();
    },
    getUserId: (): Promise<string> => {
      return Funnelconnectreactnativesdk.getUserId();
    },
    setUser: (fcUser: FCUser): Promise<string> => {
      return Funnelconnectreactnativesdk.setUser(fcUser);
    },
    getPermissions: (): Promise<PermissionsMap> => {
      return Funnelconnectreactnativesdk.getPermissions();
    },
    updatePermissions: (
      permissions: PermissionsMap,
      notificationsVersion: number
    ): void => {
      Funnelconnectreactnativesdk.updatePermissions(
        permissions,
        notificationsVersion
      );
    },
    updatePermissionsPromise: (
      permissions: PermissionsMap,
      notificationsVersion: number
    ): Promise<string> => {
      return Funnelconnectreactnativesdk.updatePermissions(
        permissions,
        notificationsVersion
      );
    },
    logEvent: (key: string, value: string): void => {
      Funnelconnectreactnativesdk.logEvent(key, value);
    },
    logEventPromise: (key: string, value: string): Promise<string> => {
      return Funnelconnectreactnativesdk.logEvent(key, value);
    },
    logEvents: (events: LogEvent[]): void => {
      Funnelconnectreactnativesdk.logEvents(events);
    },
    logEventsPromise: (events: LogEvent[]): Promise<string> => {
      return Funnelconnectreactnativesdk.logEvents(events);
    },
  };
};

const trustPid = () => {
  return {
    startService: (isStub: boolean = false): void => {
      Funnelconnectreactnativesdk.startTrustPidService(isStub);
    },
    startServicePromise: (
      isStub: boolean = false
    ): Promise<startTrustPidServiceOutput> => {
      return Funnelconnectreactnativesdk.startTrustPidService(isStub);
    },
    acceptConsent: (): void => {
      Funnelconnectreactnativesdk.acceptConsent();
    },
    acceptConsentPromise: (): Promise<string> => {
      return Funnelconnectreactnativesdk.acceptConsent();
    },
    rejectConsent: (): void => {
      Funnelconnectreactnativesdk.rejectConsent();
    },
    rejectConsentPromise: (): Promise<string> => {
      return Funnelconnectreactnativesdk.rejectConsent();
    },
    isConsentAccepted: (): Promise<boolean> => {
      return Funnelconnectreactnativesdk.isConsentAccepted();
    },
  };
};

const funnelConnectSdk = {
  initializeSDK,
  onInitialize,
  isInitialized,
  clearCookies,
  clearCookiesPromise,
  clearData,
  clearDataPromise,
  cdp,
  trustPid,
};

export { funnelConnectSdk };
