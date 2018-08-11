import React, { Component } from 'react';
import { Text, View } from 'react-native';
import {PS} from './purs_app';

export default class Bananas extends Component {
  render() {
    let story = PS.Main.asString;
    return (
      <View>
        <Text> {story} </Text>
      </View>
    );
  }
}
