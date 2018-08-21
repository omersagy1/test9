import React, { Component } from 'react';
import { TouchableHighlight, StyleSheet, Text, View } from 'react-native';


export const Choices = (props) => {
  const choiceButtons = props.labels.map((label, index) => {
    return <ChoiceButton label={label} 
                         key={index} 
                         callback={props.callbackMaker(label)} />;
  })
  return (
    <View style={styles.choices}>
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

  choices: {
    justifyContent: 'center',
    alignItems: 'center',
    flexGrow: 1,
  },

  choiceButton: {
    height: 100,
    width: 250,
    margin: 10,
    backgroundColor: 'gray',
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 3,
    borderColor: 'yellow',
    borderRadius: 20,
  },

  label: {
    fontSize: 28,
    color: 'white',
  },

});