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

  timePassedSeconds = () => {
      return PURESCRIPT.getTimePassedSeconds(this.state.model);
  }

  messages = () => {
    return PURESCRIPT.getMessages(this.state.model);
  }

  activeMessage = () => {
    return PURESCRIPT.getActiveMessage(this.state.model);
  }

  render() {
    return (
      <View>
        <Counter count={ Math.round(this.timePassedSeconds()) } />
        <MessageDisplay messages={this.messages()} />
      </View>
    );
  }
}

const MessageDisplay = (props) => {
  return (
    <View>
      {
        props.messages.map((message) => {
          return <Text> {message} </Text>
        })
      } 
    </View>
  )
}


const styles = StyleSheet.create({

  app: {
    flex: 1,
    backgroundColor: "orange",
    paddingTop: 100,
    alignItems: 'center'
  },

});