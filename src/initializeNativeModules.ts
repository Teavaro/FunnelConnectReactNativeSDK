import { NativeModules, Platform } from 'react-native';

export const initializeNativeModules = () => {
  const SDK_LINKING_ERROR =
    `The package 'FunnelConnectSDK' doesn't seem to be linked. Make sure: \n\n` +
    Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
    '- You rebuilt the app after installing the package\n' +
    '- You are not using Expo managed workflow\n';
  console.log(JSON.stringify(NativeModules));
  const FunnelConnectSdkModule = NativeModules.FunnelConnectSDK
    ? NativeModules.FunnelConnectSDK
    : new Proxy(
        {},
        {
          get() {
            throw new Error(SDK_LINKING_ERROR);
          },
        }
      );

  return { FunnelConnectSdkModule };
};
