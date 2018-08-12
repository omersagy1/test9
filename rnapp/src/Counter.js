import React, { Component } from 'react';
import { Alert, Button, StyleSheet, Text, View } from 'react-native';

export const Counter = (props) => {
  return (

    <View style={styles.widget}>

      <View style={styles.numberDisplay}>
        <Text style={styles.counterText}> Seconds Passed: {props.count} </Text>
      </View>

      <View style={styles.buttonSection}>
        <Button onPress={props.incCallback} title="Increment Counter" />
        <Button onPress={props.resetCallback} title="Reset Counter" />
      </View>

    </View>
  )
}


const styles = StyleSheet.create({

  widget: {
    height: 300,
    alignSelf: 'stretch',
    backgroundColor: "lightgreen",
    borderWidth: 2,
    borderColor: 'blue'
  },

  numberDisplay: {
    backgroundColor: "lightblue",
    height: 40,
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center'
  },

  counterText: {
    fontSize: 20,
    color: 'purple',
  },

  buttonSection: {
    backgroundColor: "lightyellow",
    flex: 2,
    justifyContent: 'center',
    alignItems: 'center'
  }


});