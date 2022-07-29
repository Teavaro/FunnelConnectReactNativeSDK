import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import {
  multiply,
  initializeSDK,
  getUmidgetUmid,
} from 'funnelconnectreactnativesdk';

export default function App() {
  const [result, setResult] = React.useState<number | undefined>();

  React.useEffect(() => {
    multiply(3, 7).then(setResult);
    initializeSDK();
    setTimeout(() => console.log(getUmidgetUmid()), 10000);
  }, []);

  return (
    <View style={styles.container}>
      <Text>Result: {result}</Text>
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
