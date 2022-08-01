import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import {
  printNativeLog,
  getStaticString,
  resolveMultiplicationPromise,
  resolveUserDataPromise,
  callCallback,
  callProvidedCallback,
  callUserDataProvidedCallback,
} from 'funnelconnectreactnativesdk';

export default function App() {
  const [staticString, setStaticString] = React.useState<string>();
  const [multiplicationResult, setMultiplicationResult] =
    React.useState<number>();
  const [callbackResult, setCallbackResult] = React.useState<string>();
  const [userData, setUserData] = React.useState<any>();

  const callbackFunction = (someParamProvidedByNativeInvoke: string) => {
    setCallbackResult(someParamProvidedByNativeInvoke);
  };

  React.useEffect(() => {
    printNativeLog();

    const getStaticStringResult = getStaticString();
    console.log('getStaticStringResult: ', getStaticStringResult);
    setStaticString(getStaticStringResult);

    resolveMultiplicationPromise(25, 4).then(setMultiplicationResult);
    resolveUserDataPromise(25, 4).then((result) => {
      console.log(result);
      console.log(JSON.stringify(result));
      setUserData(result);
    });

    callCallback('Test name', 'Test location');

    callProvidedCallback('sdkToken', callbackFunction);
  }, []);

  return (
    <View style={styles.container}>
      <Text>Static string: {staticString}</Text>
      <Text>Multiplication result: {multiplicationResult}</Text>
      <Text>Callback result: {callbackResult}</Text>
      <Text>Callback result: {userData}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
