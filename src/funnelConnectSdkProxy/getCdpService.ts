export const getCdpService = (Funnelconnectreactnativesdk: any) => {
  const cdp = () => {
    return {
      startCdpServiceAsync: (fcUser: FCUser | null = null): Promise<string> => {
        return Funnelconnectreactnativesdk.startCdpServiceAsync(fcUser);
      },
      getUmidAsync: (): Promise<string> => {
        return Funnelconnectreactnativesdk.getUmidAsync();
      },
      getUserIdAsync: (): Promise<string> => {
        return Funnelconnectreactnativesdk.getUserIdAsync();
      },
      setUserAsync: (fcUser: FCUser): Promise<string> => {
        return Funnelconnectreactnativesdk.setUserAsync(fcUser);
      },
      getPermissionsAsync: (): Promise<PermissionsMap> => {
        return Funnelconnectreactnativesdk.getPermissionsAsync();
      },
      updatePermissions: (
        permissions: PermissionsMap,
        notificationsVersion: number
      ): void => {
        Funnelconnectreactnativesdk.updatePermissions(
          permissions,
          notificationsVersion
        );
      },
      updatePermissionsAsync: (
        permissions: PermissionsMap,
        notificationsVersion: number
      ): Promise<string> => {
        return Funnelconnectreactnativesdk.updatePermissionsAsync(
          permissions,
          notificationsVersion
        );
      },
      logEvent: (key: string, value: string): void => {
        Funnelconnectreactnativesdk.logEvent(key, value);
      },
      logEventSdkAsync: (key: string, value: string): Promise<string> => {
        return Funnelconnectreactnativesdk.logEventSdkAsync(key, value);
      },
      logEvents: (events: LogEventsMap): void => {
        console.log(`events for logEvents: ${JSON.stringify(events)}`);
        Funnelconnectreactnativesdk.logEvents(events);
      },
      logEventsSdkAsync: (events: LogEventsMap): Promise<string> => {
        console.log(`events for logEventsSdkAsync: ${JSON.stringify(events)}`);
        return Funnelconnectreactnativesdk.logEventsSdkAsync(events);
      },
    };
  };

  return cdp;
};
