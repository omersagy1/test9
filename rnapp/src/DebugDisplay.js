import React from 'react';
import { TouchableHighlight, StyleSheet, Text, View } from 'react-native';

import { Counter } from './Counter';


export const DebugBar = (props) => {

  const pauseLabel = props.isPaused ? 'Resume' : 'Pause';
  const ffLabel = props.inFastForwardState ? 'Restore Speed' : 'Fast Forward';
  const restartLabel = 'Restart';

  return (
    <View style={styles.debug} > 

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

      <Counter count={ props.secondsPassed } />

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

  debug: {
    backgroundColor: 'gray',
    marginBottom: 20,
  },

  bar: {
    height: 80,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center'
  },

  button: {
    flex: 1,
    height: 60,
    margin: 5,
    backgroundColor: '#5af',
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 3,
    borderColor: 'black',
    borderRadius: 15,
  },

  toggledButton: {
    backgroundColor: TOGGLE_COLOR,
  },

  label: {
    fontSize: 16,
    color: 'white',
    fontWeight: 'bold',
    textShadowColor: 'black',
    textShadowOffset: { width: 0, height: 1},
    textShadowRadius: 1
  },

});