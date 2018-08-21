import React from 'react';
import { StyleSheet, Text, View } from 'react-native';


// Max number of text lines that
// can be displayed at once.
const MAX_NUM_LINES = 10;

// Opacity of the second line.
const OPACITY_FALLOFF = 0.7;


export const MessageDisplay = (props) => {
  const messages = props.messages.map((message, index) => {
    const opacityValue = index == 0 ? 1 : OPACITY_FALLOFF * (MAX_NUM_LINES - index) / MAX_NUM_LINES;
    return (
      <Text key={index} style={[styles.line, {opacity: opacityValue}]}> 
        {message} 
      </Text>
    );
  })

  return (
    <View style={styles.messages}>
      {messages} 
    </View>
  )
}

const styles = StyleSheet.create({

  messages: {
    paddingLeft: 10,
    paddingRight: 10,
  },

  line: {
    color: 'white',
    fontSize: 20,
    marginBottom: 5,
  }

});