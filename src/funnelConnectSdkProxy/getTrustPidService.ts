import { wrapWithExceptionHandler } from './helpers/wrapWithExceptionHandler';
import { wrapWithExceptionHandlerAsync } from './helpers/wrapWithExceptionHandlerAsync';
import type { IdcData } from './types/sdkTypes';

export const getTrustPidService = (Funnelconnectreactnativesdk: any) => {
  const trustPid = () => {
    return {
      startService: (isStub: boolean = false): void => {
        Funnelconnectreactnativesdk.startTrustPidService(isStub);
      },
      startTrustPidServiceAsync: (
        isStub: boolean = false
      ): Promise<IdcData> => {
        return wrapWithExceptionHandlerAsync(
          Funnelconnectreactnativesdk.startTrustPidServiceAsync,
          isStub
        );
      },
      acceptConsent: (): void => {
        wrapWithExceptionHandler(Funnelconnectreactnativesdk.acceptConsent);
      },
      acceptConsentAsync: (): Promise<void> => {
        return wrapWithExceptionHandlerAsync(
          Funnelconnectreactnativesdk.acceptConsentAsync
        );
      },
      rejectConsent: (): void => {
        wrapWithExceptionHandler(Funnelconnectreactnativesdk.rejectConsent);
      },
      rejectConsentAsync: (): Promise<void> => {
        return wrapWithExceptionHandlerAsync(
          Funnelconnectreactnativesdk.rejectConsentAsync
        );
      },
      isConsentAcceptedAsync: (): Promise<boolean> => {
        return wrapWithExceptionHandlerAsync(
          Funnelconnectreactnativesdk.isConsentAcceptedAsync
        );
      },
    };
  };

  return trustPid;
};
