type PermissionsMap = {
  [key: string]: boolean;
};

type FCOptions = {
  enableLogging: boolean;
};

type FCUser = {
  userIdType: string;
  userId: string;
};

type IdcData = {
  atid: string;
  mtid: string;
};

type LogEventsMap = {
  [key: string]: string;
};

export { PermissionsMap, FCOptions, FCUser, IdcData, LogEventsMap };
