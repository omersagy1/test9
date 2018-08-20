import React, { Component } from 'react';
import { Alert, TouchableHighlight, Button, StyleSheet, Text, View } from 'react-native';

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

  makeChoice = (prompt) => {
    return (() => {
      return this.processMessage(PURESCRIPT.makeChoiceMessage(prompt));
    });
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
      <View>
        <Counter count={ Math.round(this.timePassedSeconds()) } />
        <MessageDisplay messages={ this.messages() } />
        { this.hasActiveChoices() && 
          <Choices labels={ this.getChoiceButtonLabels() } 
                   callbackMaker={ this.makeChoice }/> 
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
    <View>
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
    paddingTop: 100,
    alignItems: 'center'
  },

  choiceButton: {
    height: 100,
    width: 250,
    backgroundColor: 'red',
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 5,
    borderColor: 'black'
  },

  label: {
    fontSize: 20,
    color: 'white',
  },

});