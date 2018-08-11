import React, { Component } from 'react';
import { Alert, Button, StyleSheet, Text, View } from 'react-native';
import { PS } from '../purs_app';


const PURESCRIPT = PS["Main"];


export default class App extends Component {

  constructor(props) {
    super(props);
    this.state = {
      model: PURESCRIPT.initialModel
    }
    requestAnimationFrame(this.loop);
  }

  processMessage = (msg) => {
    this.setState(prev => {
      let newModel = PURESCRIPT.updateModel(msg)(prev.model);
      return this.state = {
        model: newModel
      }
    })
  }

  loop = (time) => {
    this.processMessage(PURESCRIPT.incMessage);
    requestAnimationFrame(this.loop);
  }

  increment = () => {
    this.processMessage(PURESCRIPT.incMessage);
  }

  reset = () => {
    this.processMessage(PURESCRIPT.resetMessage);
  }

  toggle = () => {
    this.processMessage(PURESCRIPT.toggleMessage);
  }

  counter = () => {
    return PURESCRIPT.getCounter(this.state.model);
  }


  render() {
    const counter = this.counter();
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