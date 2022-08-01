import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import {
  printNativeLog,
  getStaticString,
  resolveMultiplicationPromise,
  callCallback,
} from 'funnelconnectreactnativesdk';

export default function App() {
  const [staticString, setStaticString] = React.useState<string>();
  const [multiplicationResult, setMultiplicationResult] =
    React.useState<number>();

  React.useEffect(() => {
    printNativeLog();

    const getStaticStringResult = getStaticString();
    console.log('getStaticStringResult: ', getStaticStringResult);
    setStaticString(getStaticStringResult);

    resolveMultiplicationPromise(25, 4).then(setMultiplicationResult);

    callCallback('Test name', 'Test location');
  }, []);

  return (
    <View style={styles.container}>
      <Text>Static string: {staticString}</Text>
      <Text>Multiplication result: {multiplicationResult}</Text>
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
