import { wrapWithExceptionHandler } from './helpers/wrapWithExceptionHandler';
import { wrapWithExceptionHandlerAsync } from './helpers/wrapWithExceptionHandlerAsync';

export const getSdkFunctions = (Funnelconnectreactnativesdk: any) => {
  const initializeSDK = (
    sdkToken: string,
    { enableLogging = true }: FCOptions
  ): void => {
    wrapWithExceptionHandler(
      Funnelconnectreactnativesdk.initializeSDK,
      sdkToken,
      { enableLogging }
    );
  };

  const onInitializeAsync = (): Promise<string> => {
    return wrapWithExceptionHandlerAsync(
      Funnelconnectreactnativesdk.onInitializeAsync
    );
  };

  const isInitializedAsync = (): Promise<boolean> => {
    return wrapWithExceptionHandlerAsync(
      Funnelconnectreactnativesdk.isInitializedAsync
    );
  };

  const clearCookies = (): void => {
    wrapWithExceptionHandler(Funnelconnectreactnativesdk.clearCookies);
  };

  const clearCookiesAsync = (): Promise<string> => {
    return wrapWithExceptionHandlerAsync(
      Funnelconnectreactnativesdk.clearCookiesAsync
    );
  };

  const clearData = (): void => {
    wrapWithExceptionHandler(Funnelconnectreactnativesdk.clearData);
  };

  const clearDataAsync = (): Promise<string> => {
    return wrapWithExceptionHandlerAsync(
      Funnelconnectreactnativesdk.clearDataAsync
    );
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
