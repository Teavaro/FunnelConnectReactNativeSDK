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

const onInitializeWithPromise = (): Promise<string> => {
  return Funnelconnectreactnativesdk.onInitializeWithPromise();
};

const isInitializedWithPromise = (): Promise<boolean> => {
  return Funnelconnectreactnativesdk.isInitializedWithPromise();
};

const clearCookies = (): void => {
  Funnelconnectreactnativesdk.clearCookies();
};

const clearCookiesWithPromise = (): Promise<string> => {
  return Funnelconnectreactnativesdk.clearCookiesWithPromise();
};

const clearData = (): void => {
  Funnelconnectreactnativesdk.clearData();
};

const clearDataWithPromise = (): Promise<string> => {
  return Funnelconnectreactnativesdk.clearDataWithPromise();
};

// CDP service functions
const cdp = () => {
  return {
    startCdpServiceWithPromise: (
      fcUser: FCUser | null = null
    ): Promise<string> => {
      return Funnelconnectreactnativesdk.startCdpServiceWithPromise(fcUser);
    },
    getUmidWithPromise: (): Promise<string> => {
      return Funnelconnectreactnativesdk.getUmidWithPromise();
    },
    getUserIdWithPromise: (): Promise<string> => {
      return Funnelconnectreactnativesdk.getUserIdWithPromise();
    },
    setUserWithPromise: (fcUser: FCUser): Promise<string> => {
      return Funnelconnectreactnativesdk.setUserWithPromise(fcUser);
    },
    getPermissionsWithPromise: (): Promise<PermissionsMap> => {
      return Funnelconnectreactnativesdk.getPermissionsWithPromise();
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
    updatePermissionsWithPromise: (
      permissions: PermissionsMap,
      notificationsVersion: number
    ): Promise<string> => {
      return Funnelconnectreactnativesdk.updatePermissionsWithPromise(
        permissions,
        notificationsVersion
      );
    },
    logEvent: (key: string, value: string): void => {
      Funnelconnectreactnativesdk.logEvent(key, value);
    },
    logEventWithPromise: (key: string, value: string): Promise<string> => {
      return Funnelconnectreactnativesdk.logEventWithPromise(key, value);
    },
    logEvents: (events: LogEvent[]): void => {
      Funnelconnectreactnativesdk.logEvents(events);
    },
    logEventsWithPromise: (events: LogEvent[]): Promise<string> => {
      return Funnelconnectreactnativesdk.logEventsWithPromise(events);
    },
  };
};

const trustPid = () => {
  return {
    startService: (isStub: boolean = false): void => {
      Funnelconnectreactnativesdk.startTrustPidService(isStub);
    },
    startTrustPidServiceWithPromise: (
      isStub: boolean = false
    ): Promise<startTrustPidServiceOutput> => {
      return Funnelconnectreactnativesdk.startTrustPidServiceWithPromise(
        isStub
      );
    },
    acceptConsent: (): void => {
      Funnelconnectreactnativesdk.acceptConsent();
    },
    acceptConsentWithPromise: (): Promise<string> => {
      return Funnelconnectreactnativesdk.acceptConsentWithPromise();
    },
    rejectConsent: (): void => {
      Funnelconnectreactnativesdk.rejectConsent();
    },
    rejectConsentWithPromise: (): Promise<string> => {
      return Funnelconnectreactnativesdk.rejectConsentWithPromise();
    },
    isConsentAcceptedWithPromise: (): Promise<boolean> => {
      return Funnelconnectreactnativesdk.isConsentAcceptedWithPromise();
    },
  };
};

const funnelConnectSdk = {
  initializeSDK,
  onInitializeWithPromise,
  isInitializedWithPromise,
  clearCookies,
  clearCookiesWithPromise,
  clearData,
  clearDataWithPromise,
  cdp,
  trustPid,
};

export { funnelConnectSdk };
