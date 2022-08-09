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
type GetPermissionsOutput = {
  omAccepted: string;
  optAccepted: string;
  nbaAccepted: string;
};

type Permissions = {
  permission: {
    'LI-OPT': boolean;
    'LI-OM': boolean;
    'LI-NBA': boolean;
  };
};

type FCOptions = {
  enableLogging: boolean;
};

type startTrustPidServiceOutput = {
  atid: string;
  mtid: string;
};

// Top level functions
const clearCookies = () => {
  Funnelconnectreactnativesdk.clearCookies();
};

// Kotlin
// TODO: Verify return type - I can see only Promise in the Module
const clearData = (): Promise<string> => {
  return Funnelconnectreactnativesdk.clearData();
};

// CDP service functions
const cdp = () => {
  return {
    startService: (userId: string | null = null) => {
      Funnelconnectreactnativesdk.startCdpService(userId);
    },
    // TODO: Verify if overload works in this bridge
    startServicePromise: (userId: string | null = null): Promise<string> => {
      return Funnelconnectreactnativesdk.startCdpService(userId);
    },
    getUmid: (): Promise<string> => {
      return Funnelconnectreactnativesdk.getUmid();
    },
    getUserId: (): Promise<string> => {
      return Funnelconnectreactnativesdk.getUserId();
    },
    setUserId: (userId: string): Promise<string> => {
      return Funnelconnectreactnativesdk.setUserId(userId);
    },
    getPermissions: (): Promise<GetPermissionsOutput> => {
      return Funnelconnectreactnativesdk.getPermissions();
    },
    // Kotlin
    // TODO: According to docs, this method also returns updated permissions
    // But it is not returned in Module
    updatePermissions: (
      omAccepted: boolean,
      optAccepted: boolean,
      nbaAccepted: boolean
    ): Promise<Permissions> => {
      return Funnelconnectreactnativesdk.updatePermissions(
        omAccepted,
        optAccepted,
        nbaAccepted
      );
    },
    // TODO: Just call native implementation and see whether it is being logged and if yes - where
    // If it doesn't show -> return message and console.log in RN
    logEvent: (key: string, value: string) => {
      return Funnelconnectreactnativesdk.logEvent(key, value);
    },
    // TODO: This won't work - we have no explicit nor implicit mapping of Map
    // Either consider remapping or running a foreach loop as in the commented out code below
    logEvents: (events: Map<string, string>) => {
      return Funnelconnectreactnativesdk.logEvents(events);
      // events.forEach((event) => {
      //   console.log('Event value:', event);
      // });
    },
  };
};

const trustPid = () => {
  return {
    startService: (isStub: boolean = false) => {
      Funnelconnectreactnativesdk.startTrustPidService(isStub);
    },
    // TODO: Verify if overload works in this bridge
    startServicePromise: (
      isStub: boolean = false
    ): Promise<startTrustPidServiceOutput> => {
      return Funnelconnectreactnativesdk.startTrustPidService(isStub);
    },
    acceptConsent: (): void => {
      return Funnelconnectreactnativesdk.acceptConsent();
    },
    rejectConsent: (): void => {
      return Funnelconnectreactnativesdk.rejectConsent();
    },
    isConsentAccepted: (): Promise<boolean> => {
      return Funnelconnectreactnativesdk.isConsentAccepted();
    },
  };
};

// Kotlin
// TODO: What with those 3 functions? I can see no corresponding functiond in the Module
const initialize = (
  sdkToken: string,
  { enableLogging = true }: FCOptions
): void => {
  if (!sdkToken) {
    console.log('no sdkToken provided');
  }
  if (enableLogging) {
    console.log('enableLogging set to true');
  }
  return;
};

const onInitialize = (): Promise<string> => {
  return new Promise((resolve, reject) => {
    if ('true') {
      resolve('JSONstring');
    } else {
      reject('nothing');
    }
  });
};

const isInitialized = (): Promise<boolean> => {
  return new Promise((resolve, reject) => {
    if ('true') {
      resolve(true);
    } else {
      reject(false);
    }
  });
};

const funnelConnectSdk = {
  clearCookies,
  clearData,
  cdp,
  trustPid,
  // initialize,
  // onInitialize,
  // isInitialized,
};

export { funnelConnectSdk };
