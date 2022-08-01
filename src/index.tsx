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
    Funnelconnectreactnativesdk.getStaticString
  );
  return Funnelconnectreactnativesdk.getStaticString();
}

function resolveMultiplicationPromise(a: number, b: number): Promise<number> {
  return Funnelconnectreactnativesdk.resolveMultiplicationPromise(a, b);
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

export {
  printNativeLog,
  getStaticString,
  resolveMultiplicationPromise,
  callCallback,
};
