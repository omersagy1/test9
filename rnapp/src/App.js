import React, { Component } from 'react';
import { Alert, Button, StyleSheet, Text, View } from 'react-native';

import { PURESCRIPT } from './Purs';
import { Counter } from './Counter';
import { ToggleButton } from './ToggleButton';


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

  loop = (currentTime) => {
    this.updateTime(currentTime);
    requestAnimationFrame(this.loop);
  }

  updateTime = (t) => {
    this.processMessage(PURESCRIPT.updateTimeMessage(t));
  }

  timePassed = () => {
      return PURESCRIPT.getTimePassed(this.state.model);
  }

  render() {
    return (
      <View>

        <Counter count={ Math.round(this.timePassed() / 1000.0) } />

      </View>
    );
  }
}


const styles = StyleSheet.create({

  app: {
    flex: 1,
    backgroundColor: "orange",
    paddingTop: 100,
    alignItems: 'center'
  },

  toggledBackground: {
    backgroundColor: "green"
  },

  toggle: {
    marginTop: 50
  }

});