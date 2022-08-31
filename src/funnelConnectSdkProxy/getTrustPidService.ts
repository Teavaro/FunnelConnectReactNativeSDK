export const getTrustPidService = (Funnelconnectreactnativesdk: any) => {
  const trustPid = () => {
    return {
      startService: (isStub: boolean = false): void => {
        Funnelconnectreactnativesdk.startTrustPidService(isStub);
      },
      startTrustPidServiceAsync: (
        isStub: boolean = false
      ): Promise<IdcData> => {
        return Funnelconnectreactnativesdk.startTrustPidServiceAsync(isStub);
      },
      acceptConsent: (): void => {
        Funnelconnectreactnativesdk.acceptConsent();
      },
      acceptConsentAsync: (): Promise<string> => {
        return Funnelconnectreactnativesdk.acceptConsentAsync();
      },
      rejectConsent: (): void => {
        Funnelconnectreactnativesdk.rejectConsent();
      },
      rejectConsentAsync: (): Promise<string> => {
        return Funnelconnectreactnativesdk.rejectConsentAsync();
      },
      isConsentAcceptedAsync: (): Promise<boolean> => {
        return Funnelconnectreactnativesdk.isConsentAcceptedAsync();
      },
    };
  };

  return trustPid;
};
