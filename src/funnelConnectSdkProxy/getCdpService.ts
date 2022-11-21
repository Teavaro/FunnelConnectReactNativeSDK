import { wrapWithExceptionHandler } from './helpers/wrapWithExceptionHandler';
import { wrapWithExceptionHandlerAsync } from './helpers/wrapWithExceptionHandlerAsync';
import type { FCUser, LogEventsMap, PermissionsMap } from './types/sdkTypes';

export const getCdpService = (Funnelconnectreactnativesdk: any) => {
  const cdp = () => {
    return {
      startCdpServiceAsync: (fcUser: FCUser | null = null): Promise<string> => {
        return wrapWithExceptionHandlerAsync(
          Funnelconnectreactnativesdk.startCdpServiceAsync,
          fcUser
        );
      },
      startCdpServiceWithNotificationsVersionAsync: (
        fcUser: FCUser | null = null,
        notificationsName: string,
        notificationsVersion: number
      ): Promise<string> => {
        return wrapWithExceptionHandlerAsync(
          Funnelconnectreactnativesdk.startCdpServiceWithNotificationsVersionAsync,
          fcUser,
          notificationsName,
          notificationsVersion
        );
      },
      getUmidAsync: (): Promise<string> => {
        return wrapWithExceptionHandlerAsync(
          Funnelconnectreactnativesdk.getUmidAsync
        );
      },
      getUserIdAsync: (): Promise<string> => {
        return wrapWithExceptionHandlerAsync(
          Funnelconnectreactnativesdk.getUserIdAsync
        );
      },
      setUserAsync: (fcUser: FCUser): Promise<string> => {
        return wrapWithExceptionHandlerAsync(
          Funnelconnectreactnativesdk.setUserAsync,
          fcUser
        );
      },
      getPermissionsAsync: (): Promise<PermissionsMap> => {
        return wrapWithExceptionHandlerAsync(
          Funnelconnectreactnativesdk.getPermissionsAsync
        );
      },
      updatePermissions: (
        permissions: PermissionsMap,
        notificationsVersion: number
      ): void => {
        wrapWithExceptionHandler(
          Funnelconnectreactnativesdk.updatePermissions,
          permissions,
          notificationsVersion
        );
      },
      updatePermissionsAsync: (
        permissions: PermissionsMap,
        notificationsVersion: number
      ): Promise<void> => {
        return wrapWithExceptionHandlerAsync(
          Funnelconnectreactnativesdk.updatePermissionsAsync,
          permissions,
          notificationsVersion
        );
      },
      logEvent: (key: string, value: string): void => {
        wrapWithExceptionHandler(
          Funnelconnectreactnativesdk.logEvent,
          key,
          value
        );
      },
      logEventAsync: (key: string, value: string): Promise<void> => {
        return wrapWithExceptionHandlerAsync(
          Funnelconnectreactnativesdk.logEventAsync,
          key,
          value
        );
      },
      logEvents: (events: LogEventsMap): void => {
        wrapWithExceptionHandler(Funnelconnectreactnativesdk.logEvents, events);
      },
      logEventsAsync: (events: LogEventsMap): Promise<void> => {
        return wrapWithExceptionHandlerAsync(
          Funnelconnectreactnativesdk.logEventsAsync,
          events
        );
      },
    };
  };

  return cdp;
};
