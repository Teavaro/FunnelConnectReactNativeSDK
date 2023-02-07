import { getCdpService } from './funnelConnectSdkProxy/getCdpService';
import { getSdkFunctions } from './funnelConnectSdkProxy/getSdkFunctions';
import { getTrustPidService } from './funnelConnectSdkProxy/getTrustPidService';
import { initializeNativeModules } from './initializeNativeModules';

const { FunnelConnectSdkModule } = initializeNativeModules();

const coreSdkFunctions = getSdkFunctions(FunnelConnectSdkModule);
const cdp = getCdpService(FunnelConnectSdkModule);
const trustPid = getTrustPidService(FunnelConnectSdkModule);

const funnelConnectSdk = {
  ...coreSdkFunctions,
  cdp,
  trustPid,
};
console.log('Test');
export { funnelConnectSdk };

export * from './funnelConnectSdkProxy/types/sdkTypes';
