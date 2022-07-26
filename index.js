/**
 * @format
 */

// import {AppRegistry} from 'react-native';
// import App from './App';
// import {name as appName} from './app.json';

// AppRegistry.registerComponent(appName, () => App);

/* Docs: 
https://reactnative.dev/docs/environment-setup
https://reactnative.dev/docs/native-modules-android -- change to Kotlin tab on the site
*/

import {NativeModules} from 'react-native';

console.log('NATIVE MODULE: ', NativeModules);

// const {FunnelConnectSDK} = NativeModules;

// FunnelConnectSDK.something() <-- add some logging test method without params etc.
