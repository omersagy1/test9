import React, { Component } from 'react';
import { AppRegistry, Image, Text, View } from 'react-native';
import {PS} from './purs_app';

export default class Bananas extends Component {
  render() {
    let pic = {
      uri: 'https://upload.wikimedia.org/wikipedia/commons/d/de/Bananavarieties.jpg'
    };
    let s = PS;
    let s1 = PS.Main.asString;
    console.log(s1);
    return (
      <View>
        <Image source={pic} style={{width: 193, height: 110}}/>
        <Text> {s1} </Text>
      </View>
    );
  }
}
