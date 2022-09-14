export const getTrustPidService = (Funnelconnectreactnativesdk: any) => {
  const trustPid = () => {
    return {
      startService: (isStub: boolean = false): void => {
        Funnelconnectreactnativesdk.startTrustPidService(isStub);
      },
      startTrustPidServiceAsync: async (
        isStub: boolean = false
      ): Promise<IdcData> => {
        try {
          const result =
            await Funnelconnectreactnativesdk.startTrustPidServiceAsync(isStub);
          return Promise.resolve(result);
        } catch (error: any) {
          throw new Error(error.message);
        }
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
