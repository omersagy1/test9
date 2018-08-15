module Game.Init where

import Data.Maybe

import Common.TimedQueue as TimedQueue
import Game.Types.ActionSet as ActionSet
import Game.Types.Fire as Fire
import Game.Types.GameState (GameState)
import Game.Types.Milestones as Milestones
import Game.Types.Model (Model)
import Script.Scene as Scene


initialModel ∷ Model
initialModel = 
  { gameState: initialGameState 
  , initialized: false
  , timeLastFrame: Nothing
  , gameTimePassed: 0.0
  , messageHistory: []
  , eventQueue: TimedQueue.new
  , story: Scene.story
  , paused: false
  , fastForward: false
  , activeChoices: []
  , activeScrollingMessage: Nothing
  , interactionMode: false
  }


initialGameState ∷ GameState
initialGameState =
  { gameTime: 0.0
  , resources: []
  , fire: Fire.init 0.0
  , actionHistory: ActionSet.init
  , milestones: Milestones.init
  , actions: ActionSet.init
  , gameOver: false
  }
