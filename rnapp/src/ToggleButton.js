import React, { Component } from 'react';
import { Alert, TouchableHighlight, StyleSheet, Text, View } from 'react-native';


export const ToggleButton = (props) => {
  return (
    <TouchableHighlight style={styles.thing} 
                        onPress={props.callback}>
      <Text style={styles.label}> TOGGLE </Text>
    </TouchableHighlight>
  )
}


const styles = StyleSheet.create({

  thing: {
    height: 100,
    width: 250,
    backgroundColor: 'red',
    alignItems: 'center',
    justifyContent: 'center'
  },

  label: {
    fontSize: 20,
    color: 'white',
  }

});