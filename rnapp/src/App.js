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

  toggleState = () => {
    return PURESCRIPT.getToggleState(this.state.model);
  }

  render() {
    const counter = this.counter();
    const toggled = this.toggleState();

    let bgStyle = [styles.app]
    if (toggled) {
      bgStyle.push(styles.toggledBackground);
    }

    return (
      <View style={bgStyle}>
        <Counter count={this.counter()} 
                 resetCallback={this.reset}
                 incCallback={this.increment}></Counter>

        <View style={styles.toggle}>
          <ToggleButton callback={this.toggle} />
        </View>

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