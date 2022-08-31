export const getSdkFunctions = (Funnelconnectreactnativesdk: any) => {
  const initializeSDK = (
    sdkToken: string,
    { enableLogging = true }: FCOptions
  ): void => {
    Funnelconnectreactnativesdk.initializeSDK(sdkToken, { enableLogging });
  };

  const onInitializeAsync = (): Promise<string> => {
    return Funnelconnectreactnativesdk.onInitializeAsync();
  };

  const isInitializedAsync = (): Promise<boolean> => {
    return Funnelconnectreactnativesdk.isInitializedAsync();
  };

  const clearCookies = (): void => {
    Funnelconnectreactnativesdk.clearCookies();
  };

  const clearCookiesAsync = (): Promise<string> => {
    return Funnelconnectreactnativesdk.clearCookiesAsync();
  };

  const clearData = (): void => {
    Funnelconnectreactnativesdk.clearData();
  };

  const clearDataAsync = (): Promise<string> => {
    return Funnelconnectreactnativesdk.clearDataAsync();
  };

  return {
    initializeSDK,
    onInitializeAsync,
    isInitializedAsync,
    clearCookies,
    clearCookiesAsync,
    clearData,
    clearDataAsync,
  };
};
