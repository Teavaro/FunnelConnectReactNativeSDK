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
        if (userId) {
          resolve('JSONstring');
        } else {
          reject('No userId provided');
        }
      });
    },
    getUmid: (): Promise<string> => {
      return new Promise((resolve, reject) => {
        if ('true') {
          resolve('testUmid');
        } else {
          reject('rejected');
        }
      });
    },
    updatePermissions: (
      om: boolean,
      opt: boolean,
      nba: boolean
    ): Promise<Permissions> => {
      return new Promise((resolve, reject) => {
        if ('true') {
          resolve({
            permission: {
              'LI-OPT': opt,
              'LI-OM': om,
              'LI-NBA': nba,
            },
          });
        } else {
          reject('rejected');
        }
      });
    },
    getPermissions: (): Promise<boolean> => {
      return new Promise((resolve, reject) => {
        if ('true') {
          resolve(true);
        } else {
          reject(false);
        }
      });
    },
    // TODO: Just call native implementation and see whether it is being logged and if yes - where
    // If it doesn't show -> return message and console.log in RN
    logEvent: (key: string, value: string) => {
      console.log('Key:', key, 'and value:', value);
    },
    logEvents: (events: Map<string, string>) => {
      events.forEach((event) => {
        console.log('Event value:', event);
      });
    },
    /* Customer only methods */
    startServiceCustomer: (isStub: boolean = false): Promise<string> => {
      return new Promise((resolve, reject) => {
        if (isStub) {
          resolve('JSONstring');
        } else {
          reject('no stub provided');
        }
      });
    },
    setUserId: (userId: string): Promise<string> => {
      return new Promise((resolve, reject) => {
        if (userId) {
          resolve('JSONstring');
        } else {
          reject('No userId provided');
        }
      });
    },
    getUserId: (): Promise<string> => {
      return new Promise((resolve, reject) => {
        if ('true') {
          resolve('testUserId');
        } else {
          reject('no userId');
        }
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
        if (isStub) {
          resolve('JSONstring');
        } else {
          reject('no stub provided');
        }
      });
    },
    isConsentAccepted: (): Promise<boolean> => {
      return new Promise((resolve, reject) => {
        if ('true') {
          resolve(true);
        } else {
          reject('not accepted');
        }
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
