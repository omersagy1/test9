import React, { Component } from 'react';
import { Alert, Button, StyleSheet, Text, View } from 'react-native';
import {PS} from './purs_app';


const PURESCRIPT = PS["Main"];


export default class App extends Component {

  constructor(props) {
    super(props);
    this.state = {
      model: PURESCRIPT.initialModel
    }
    requestAnimationFrame(this.loop);
  }

  loop = (time) => {
    this.setState(prev => {
      return { model: PURESCRIPT.inc(prev.model) };
    })
    requestAnimationFrame(this.loop);
  }

  increment = () => {
    this.setState(prev => {
      return { model: PURESCRIPT.inc(prev.model) };
    })
  }

  reset = () => {
    this.setState(prev => {
      return { model: PURESCRIPT.reset(prev.model) };
    })
  }

  toggle = () => {
    this.setState(prev => {
      return { model: PURESCRIPT.toggle(prev.model) };
    })
  }


  render() {
    const counter = PURESCRIPT.getCounter(this.state.model);
    return (
      <View style={styles.app}>
        <View style={styles.display}>
          <Text> Hello, World! </Text>
          <Text> Counter: {counter} </Text>
        </View>
        <View style={styles.buttonSection}>
          <Button onPress={this.increment} title="Increment Counter" />
          <Button onPress={this.reset} title="Reset Counter" />
        </View>
      </View>
    );
  }
}

const styles = StyleSheet.create({

  app: {
    margin: 10,
    flex: 1,
    justifyContent: 'center'
  },

  display: {
    backgroundColor: "lightblue",
    flex: 0,
    alignItems: "center"
  },

  buttonSection: {
    backgroundColor: "lightgreen"
  }

});