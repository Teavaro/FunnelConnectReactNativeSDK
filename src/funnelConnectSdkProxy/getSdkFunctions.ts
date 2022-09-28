import { wrapWithExceptionHandler } from './helpers/wrapWithExceptionHandler';
import { wrapWithExceptionHandlerAsync } from './helpers/wrapWithExceptionHandlerAsync';

type FCOptions = {
  enableLogging: boolean;
};

const getSdkFunctions = (Funnelconnectreactnativesdk: any) => {
  const initializeSDK = (sdkToken: string, fcOptions?: FCOptions): void => {
    const enableLogging = fcOptions ? fcOptions.enableLogging : false;
    wrapWithExceptionHandler(
      Funnelconnectreactnativesdk.initializeSDK,
      sdkToken,
      { enableLogging }
    );
  };

  const onInitializeAsync = (): Promise<void> => {
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

  const clearCookiesAsync = (): Promise<void> => {
    return wrapWithExceptionHandlerAsync(
      Funnelconnectreactnativesdk.clearCookiesAsync
    );
  };

  const clearData = (): void => {
    wrapWithExceptionHandler(Funnelconnectreactnativesdk.clearData);
  };

  const clearDataAsync = (): Promise<void> => {
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

export { FCOptions, getSdkFunctions };
