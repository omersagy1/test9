import React, { Component } from 'react';
import { Alert, TouchableHighlight, Button, StyleSheet, Text, View } from 'react-native';

import { PURESCRIPT } from './Purs';
import { DebugBar } from './DebugDisplay';
import { Counter } from './Counter';
import { ToggleButton } from './ToggleButton';


export default class App extends Component {

  constructor(props) {
    super(props);
    this.state = {
      // NOTE: all state for the entire app must go
      // into this model. Do not add any more variables
      // to the state object.
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

  togglePause = () => {
    this.processMessage(PURESCRIPT.togglePauseMessage);
  }

  restart = () => {
    this.processMessage(PURESCRIPT.restartMessage);
  }

  toggleFastForward = () => {
    this.processMessage(PURESCRIPT.toggleFastForwardMessage);
  }

  updateTime = (t) => {
    this.processMessage(PURESCRIPT.updateTimeMessage(t));
  }

  makeChoice = (prompt) => {
    return (() => {
      return this.processMessage(PURESCRIPT.makeChoiceMessage(prompt));
    });
  }

  isPaused = () => {
    return PURESCRIPT.isPaused(this.state.model);
  }

  inFastForwardState = () => {
    return PURESCRIPT.inFastForwardState(this.state.model);
  }

  timePassedSeconds = () => {
      return PURESCRIPT.getTimePassedSeconds(this.state.model);
  }

  messages = () => {
    return PURESCRIPT.getMessages(this.state.model);
  }

  hasActiveChoices = () => {
    return PURESCRIPT.hasActiveChoices(this.state.model);
  }

  getChoiceButtonLabels = () => {
    return PURESCRIPT.getChoiceButtonLabels(this.state.model);
  }

  render() {
    return (
      <View style={styles.app}>

        <DebugBar style={styles.debugBar} 
                  isPaused={this.isPaused()}
                  inFastForwardState={this.inFastForwardState()}
                  pauseCallback={this.togglePause}
                  restartCallback={this.restart}
                  fastForwardCallback={this.toggleFastForward} />

        <Counter count={ Math.round(this.timePassedSeconds()) } />

        <MessageDisplay messages={ this.messages() } />

        { this.hasActiveChoices() && 
          <Choices labels={ this.getChoiceButtonLabels() } 
                   callbackMaker={ this.makeChoice } /> 
        }

      </View>
    );
  }
}

const MessageDisplay = (props) => {
  const messages = props.messages.map((message, index) => {
    return <Text key={index}> {message} </Text>
  })

  return (
    <View style={styles.messages}>
      {messages} 
    </View>
  )
}

const Choices = (props) => {
  const choiceButtons = props.labels.map((label, index) => {
    return <ChoiceButton label={label} 
                         key={index} 
                         callback={props.callbackMaker(label)} />;
  })
  return (
    <View>
      {choiceButtons}
    </View>
  );
}

const ChoiceButton = (props) => {
  return (
    <TouchableHighlight style={styles.choiceButton} 
                        onPress={props.callback}
                        underlayColor='purple'>
      <Text style={styles.label}> {props.label} </Text>
    </TouchableHighlight>
  );
}


const styles = StyleSheet.create({

  app: {
    flex: 1,
    backgroundColor: "orange",
    paddingTop: 50,
  },

  debugBar: {
  },

  messages : {
    justifyContent: 'center',
  },

  choiceButton: {
    height: 100,
    width: 250,
    margin: 10,
    backgroundColor: 'red',
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 5,
    borderColor: 'black'
  },

  label: {
    fontSize: 28,
    color: 'white',
  },

});