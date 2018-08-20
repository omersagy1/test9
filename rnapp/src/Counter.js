import React, { Component } from 'react';
import { Alert, Button, StyleSheet, Text, View } from 'react-native';

export const Counter = (props) => {
  return (
    <View style={styles.numberDisplay}>
      <Text style={styles.counterText}> Seconds Passed: {props.count} </Text>
    </View>
  )
}


const styles = StyleSheet.create({

  numberDisplay: {
    justifyContent: 'center',
    alignItems: 'center',
    paddingBottom: 5,
  },

  counterText: {
    fontSize: 20,
    color: 'white',
  },

});