import React, { Component } from 'react';
import { Alert, Button, StyleSheet, Text, View } from 'react-native';

import { PURESCRIPT } from './Purs';
import { Counter } from './Counter';


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
      <View>
        <Counter count={this.counter()}
                 resetCallback={this.reset}
                 incCallback={this.increment} />
      </View>
    );
  }
}
