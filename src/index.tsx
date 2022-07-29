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

function multiply(a: number, b: number): Promise<number> {
  return Funnelconnectreactnativesdk.multiply(a, b);
}

function initializeSDK(): void {
  return Funnelconnectreactnativesdk.initializeSDK();
}

function getUmidgetUmid(): string {
  return Funnelconnectreactnativesdk.getUmidgetUmid();
}

export { multiply, initializeSDK, getUmidgetUmid };
