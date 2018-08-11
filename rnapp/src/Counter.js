import React, { Component } from 'react';
import { Alert, Button, StyleSheet, Text, View } from 'react-native';

export const Counter = (props) => {
  return (

    <View style={styles.app}>
      <Text> Counter! </Text>;

      <View style={styles.display}>
        <Text> Hello, World! </Text>
        <Text> Counter: {props.count} </Text>
      </View>

      <View style={styles.buttonSection}>
        <Button onPress={props.incCallback} title="Increment Counter" />
        <Button onPress={props.resetCallback} title="Reset Counter" />
      </View>

    </View>
  )
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