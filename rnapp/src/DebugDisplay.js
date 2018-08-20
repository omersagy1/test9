import React from 'react';
import { TouchableHighlight, StyleSheet, Text, View } from 'react-native';


export const DebugBar = (props) => {

  const pauseLabel = props.isPaused ? 'Resume' : 'Pause';
  const ffLabel = props.inFastForwardState ? 'Restore Speed' : 'Fast Forward';
  const restartLabel = 'Restart';

  return (
    <View style={styles.bar}>

      <DebugButton label={pauseLabel} 
                   toggled={props.isPaused}
                   callback={props.pauseCallback} />

      <DebugButton label={restartLabel} 
                   toggled={false}
                   callback={props.restartCallback} />

      <DebugButton label={ffLabel} 
                   toggled={props.inFastForwardState}
                   callback={props.fastForwardCallback} />
    </View>
  );
}


const DebugButton = (props) => {
  const style = [styles.button];
  if (props.toggled) {
    style.push(styles.toggledButton);
  }
  return (
    <TouchableHighlight style={style} 
                        onPress={props.callback}
                        underlayColor={TOGGLE_COLOR}>
      <Text style={styles.label}> {props.label} </Text>
    </TouchableHighlight>
  );
}


const TOGGLE_COLOR = 'purple';

const styles = StyleSheet.create({

  bar: {
    height: 60,
    flex: 1,
    flexDirection: 'row',
    backgroundColor: 'orange',
    justifyContent: 'center'
  },

  button: {
    flex: 1,
    height: 100,
    margin: 5,
    backgroundColor: 'lightblue',
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 5,
    borderColor: 'black',
  },

  toggledButton: {
    backgroundColor: TOGGLE_COLOR,
  },

  label: {
    fontSize: 20,
    color: 'black',
  },

});