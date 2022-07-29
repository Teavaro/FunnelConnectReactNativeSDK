import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import { initializeSDK, startCDP, getUmid } from 'funnelconnectreactnativesdk';

export default function App() {
  const [result, setResult] = React.useState<string | undefined>();

  React.useEffect(() => {
    initializeSDK();
    setTimeout(() => {
      startCDP();
      setTimeout(() => {
        const umid = getUmid();
        console.log('umid: ', umid);
        setResult(umid);
      }, 20000);
    }, 20000);
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
