import React from 'react';
import { StyleSheet, Text, View } from 'react-native';


export const MessageDisplay = (props) => {
  const messages = props.messages.map((message, index) => {
    return (
      <Text key={index} style={styles.line}> 
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

  line: {
    color: 'white',
    fontSize: 24,
  }

});