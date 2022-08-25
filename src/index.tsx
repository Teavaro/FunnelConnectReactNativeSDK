import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'funnelconnectreactnativesdk' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const Funnelconnectreactnativesdk = NativeModules.Funnelconnectreactnativesdk
  ? NativeModules.Funnelconnectreactnativesdk
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

const clearData = (): void => {
  Funnelconnectreactnativesdk.clearData();
};

// CDP service functions
const cdp = () => {
  return {
    startService: (fcUser: FCUser | null = null) => {
      Funnelconnectreactnativesdk.startCdpService(fcUser);
    },
    // TODO: Verify if overload works in this bridge
    startServicePromise: (fcUser: FCUser | null = null): Promise<string> => {
      return Funnelconnectreactnativesdk.startCdpService(fcUser);
    },
    getUmid: (): Promise<string> => {
      return Funnelconnectreactnativesdk.getUmid();
    },
    getUserId: (): Promise<string> => {
      return Funnelconnectreactnativesdk.getUserId();
    },
    setUser: (fcUser: FCUser): void => {
      Funnelconnectreactnativesdk.setUser(fcUser);
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
    logEvent: (key: string, value: string): void => {
      Funnelconnectreactnativesdk.logEvent(key, value);
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
    // TODO: Verify if overload works in this bridge
    startServicePromise: (
      isStub: boolean = false
    ): Promise<startTrustPidServiceOutput> => {
      return Funnelconnectreactnativesdk.startTrustPidService(isStub);
    },
    acceptConsent: (): void => {
      Funnelconnectreactnativesdk.acceptConsent();
    },
    rejectConsent: (): void => {
      Funnelconnectreactnativesdk.rejectConsent();
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
  clearData,
  cdp,
  trustPid,
};

export { funnelConnectSdk };
