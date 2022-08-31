import { NativeModules, Platform } from 'react-native';
import { getCdpService } from './funnelConnectSdkProxy/getCdpService';
import { getSdkFunctions } from './funnelConnectSdkProxy/getSdkFunctions';
import { getTrustPidService } from './funnelConnectSdkProxy/getTrustPidService';

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

const coreSdkFunctions = getSdkFunctions(Funnelconnectreactnativesdk);
const cdp = getCdpService(Funnelconnectreactnativesdk);
const trustPid = getTrustPidService(Funnelconnectreactnativesdk);

const funnelConnectSdk = {
  ...coreSdkFunctions,
  cdp,
  trustPid,
};

export { funnelConnectSdk };
