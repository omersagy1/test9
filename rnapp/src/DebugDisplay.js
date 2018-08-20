import React from 'react';
import { TouchableHighlight, StyleSheet, Text, View } from 'react-native';


export const DebugBar = (props) => {

  const pauseLabel = props.isPaused ? 'Resume' : 'Pause';
  const ffLabel = props.inFastForwardState ? 'Restore Speed' : 'Fast Forward';
  const restartLabel = 'Restart';

  return (
    <View style={styles.bar}>
      <DebugButton label={pauseLabel} callback={props.pauseCallback} />
      <DebugButton label={restartLabel} callback={props.restartCallback} />
      <DebugButton label={ffLabel} callback={props.fastForwardCallback} />
    </View>
  );
}


const DebugButton = (props) => {
  return (
    <TouchableHighlight style={styles.button} 
                        onPress={props.callback}
                        underlayColor='purple'>
      <Text style={styles.label}> {props.label} </Text>
    </TouchableHighlight>
  );
}


const styles = StyleSheet.create({

  bar: {
    height: 100,
    flex: 1,
    flexDirection: 'row',
    backgroundColor: "orange",
    alignItems: 'center'
  },

  button: {
    flex: 1,
    height: 100,
    backgroundColor: 'lightblue',
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