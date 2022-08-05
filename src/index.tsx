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

const cdp = () => {
  return {
    /* Visitor and customer methods */
    startService: (userId: string | null = null): Promise<string> => {
      return new Promise((resolve, reject) => {
        resolve('JSONstring');
      });
    },
    getUmid: (): Promise<string> => {
      return new Promise((resolve, reject) => {
        resolve('testUmid');
      });
    },
    updatePermissions: (
      om: boolean,
      opt: boolean,
      nba: boolean
    ): Promise<Permissions> => {
      return new Promise((resolve, reject) => {
        resolve({
          permission: {
            'LI-OPT': opt,
            'LI-OM': om,
            'LI-NBA': nba,
          },
        });
      });
    },
    getPermissions: (): Promise<boolean> => {
      return new Promise((resolve, reject) => {
        resolve(true);
      });
    },
    // TODO: Just call native implementation and see whether it is being logged and if yes - where
    // If it doesn't show -> return message and console.log in RN
    logEvent: (key: string, value: string) => {
      // As above
    },
    logEvents: (events: Map<string, string>) => {
      // As above
    },
    /* Customer only methods */
    startServiceCHANGETHENAME: (isStub: boolean = false): Promise<string> => {
      return new Promise((resolve, reject) => {
        resolve('JSONstring');
      });
    },
    setUserId: (userId: string): Promise<string> => {
      return new Promise((resolve, reject) => {
        resolve('JSONstring');
      });
    },
    getUserId: (): Promise<string> => {
      return new Promise((resolve, reject) => {
        resolve('testUserId');
      });
    },
  };
};

const trustPid = () => {
  return {
    acceptConsent: (): void => {
      return;
    },
    startService: (isStub: boolean = false): Promise<string> => {
      return new Promise((resolve, reject) => {
        resolve('JSONstring');
      });
    },
    isConsentAccepted: (): Promise<boolean> => {
      return new Promise((resolve, reject) => {
        resolve(true);
      });
    },
    rejectConsent: (): void => {
      return;
    },
  };
};

const initialize = (
  sdkToken: string,
  { enableLogging = true }: FCOptions
): void => {
  return;
};

const onInitialize = (): Promise<string> => {
  return new Promise((resolve, reject) => {
    resolve('JSONstring');
  });
};

const isInitialized = (): Promise<boolean> => {
  return new Promise((resolve, reject) => {
    resolve(true);
  });
};

// TODO: Remove after testing
const getStaticString = (): Promise<string> => {
  return Funnelconnectreactnativesdk.getStaticString();
};

const funnelConnectSdk = {
  cdp,
  trustPid,
  initialize,
  onInitialize,
  isInitialized,
  getStaticString,
};

export { funnelConnectSdk };
