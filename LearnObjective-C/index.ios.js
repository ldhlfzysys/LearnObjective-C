import React from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Alert,
  Button
} from 'react-native';

import {NativeModules} from 'react-native';
// import MapView from './MapView.js';

const onButtonPress = () => {
  Alert.alert('点击了Button按钮');
};

var CustomView = NativeModules.CustomView;
CustomView.addEvent('Birthday Party', '4 Privet Drive, Surrey');
 
class Root extends React.Component {
    render() {
        return (
            <View style={styles.container}>
                <Text style={styles.welcome}>
                    Welcome to React Native!
                </Text>
                <Text style={styles.instructions}>
                    To get started, edit index.android.js
                </Text>
                <Text style={styles.instructions}>
                    Double tap R on your keyboard to reload,{'\n'}
                    Shake or press menu button for dev menu
                </Text>
                <Button
                    title="我是按钮"
                    onPress={onButtonPress}
                    color="#841584">
                </Button>
            </View>
        );
    }
}


const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
    },
    welcome: {
        fontSize: 20,
        textAlign: 'center',
        margin: 10,
    },
    instructions: {
        textAlign: 'center',
        color: '#333333',
        marginBottom: 5,
    },
});

// 整体js模块的名称
AppRegistry.registerComponent('MyReactNativeApp', () => Root);
