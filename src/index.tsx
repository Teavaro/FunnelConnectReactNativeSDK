import {
  getCdpService,
  FCUser,
  PermissionsMap,
  LogEventsMap,
} from './funnelConnectSdkProxy/getCdpService';
import {
  getSdkFunctions,
  FCOptions,
} from './funnelConnectSdkProxy/getSdkFunctions';
import {
  getTrustPidService,
  IdcData,
} from './funnelConnectSdkProxy/getTrustPidService';
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

export {
  funnelConnectSdk,
  FCUser,
  PermissionsMap,
  LogEventsMap,
  FCOptions,
  IdcData,
};
