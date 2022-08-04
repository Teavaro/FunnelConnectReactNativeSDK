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

function printNativeLog(): void {
  return Funnelconnectreactnativesdk.printNativeLog();
}

function getStaticString(): string {
  console.log(
    'Funnelconnectreactnativesdk.getStaticString(): ',
    Funnelconnectreactnativesdk.getStaticString()
  );
  return Funnelconnectreactnativesdk.getStaticString();
}

function resolveMultiplicationPromise(a: number, b: number): Promise<number> {
  return Funnelconnectreactnativesdk.resolveMultiplicationPromise(a, b);
}

function resolveUserDataPromise(a: number, b: number): Promise<any> {
  return Funnelconnectreactnativesdk.resolveUserDataPromise(a, b);
}

function resolveUserMapPromise(a: number, b: number): Promise<any> {
  return Funnelconnectreactnativesdk.resolveUserMapPromise(a, b);
}

function callCallback(name: string, location: string): void {
  Funnelconnectreactnativesdk.callCallback(
    name,
    location,
    (name: string, location: string) => {
      console.log(
        `Called a callback with name ${name} and location ${location}`
      );
    }
  );
}

function callProvidedCallback(parameter: string, callback: Function): void {
  Funnelconnectreactnativesdk.callProvidedCallback(parameter, callback);
}

function callUserDataProvidedCallback(
  parameter: string,
  callback: Function
): void {
  Funnelconnectreactnativesdk.callProvidedCallback(parameter, callback);
}

type Permissions = {
  permission: {
    'LI-OPT': boolean;
    'LI-OM': boolean;
    'LI-NBA': boolean;
  };
};

const cdp = () => {
  return {
    /* Visitor and customer methods */
    startService: (
      userId: string | null = null,
      dataCallBack: Function | null = null,
      errorCallback: Function | null = null
    ) => {
      // TODO: How to shape the callbacks types
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
    logEvent: (key: string, value: string) => {
      // TODO: Need clarification there
    },
    logEvents: (events: Map<string, string>) => {
      // TODO: Need clarification there
    },
    /* Customer only methods */
    // TODO: We cannot overload this method in JS, we would need to do:
    // string | boolean | null and then manually check input type
    // but then we would need to name the param the same for both cases
    startService: (
      isStub: boolean = false,
      dataCallBack: Function | null = null,
      errorCallback: Function | null = null
    ) => {
      // TODO: How to shape the callbacks types
    },
    setUserId: (userId: string) => {},
    getUserId: (): Promise<string> => {
      return new Promise((resolve, reject) => {
        resolve('testUserId');
      });
    },
  };
};

// TODO: For methods like setUserId - do we want to return promise with
// no value just to indicate, that the operation has finished?
// How is it used right now? Seems right to return promise for e.g. startService

// TODO: What about FunnelConnectSDK.initialize(this, R.raw.config) from Getting Started?
// Do we need to also handle this case?

const trustPid = () => {
  return {
    acceptConsent: () => {
      // This method will prompt the user to grant his Consent for the TrustPid service.
      // TODO: Test if it will work this way
    },
    startService: (
      isStub: boolean = false,
      dataCallback: Function | null = null,
      errorCallback: Function | null = null
    ) => {
      // TODO: How to shape the callbacks types
    },
    isConsentAccepted: (): Promise<boolean> => {
      return new Promise((resolve, reject) => {
        resolve(true);
      });
    },
    rejectConsent: () => {
      // With this method the developer can update the user consent or set it to true or false:
      // TODO: How does it work? What it gets as an input, what it does from an output
    },
  };
};

const funnelConnectSdk = {
  cdp,
  trustPid,
};

export {
  printNativeLog,
  getStaticString,
  resolveMultiplicationPromise,
  resolveUserDataPromise,
  resolveUserMapPromise,
  callCallback,
  callProvidedCallback,
  callUserDataProvidedCallback,
};
