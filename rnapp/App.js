import React, { Component } from 'react';
import { Alert, Button, Text, View } from 'react-native';
import {PS} from './purs_app';

const FFI = PS["Main"];


export default class App extends Component {

  constructor(props) {
    super(props);
    this.state = {
      model: FFI.initialModel
    }
  }

  increment = () => {
    this.setState(prev => {
      return { model: FFI.inc(prev.model) };
    })
  }

  reset = () => {
    this.setState(prev => {
      return { model: FFI.reset(prev.model) };
    })
  }

  render() {
    const counter = FFI.getCounter(this.state.model);
    return (
      <View>
        <Text> Hello, World! </Text>
        <Text> {counter} </Text>
        <Button onPress={this.increment} title="Increment Counter" />
        <Button onPress={this.reset} title="Reset Counter" />

      </View>
    );
  }
}
