module Main where

import Common.Annex (listToArray, (|>))
import Common.Time as Time
import Game.Init as Init
import Game.ModelHelpers as ModelHelpers
import Game.Printer as Printer
import Game.Types.Message (Message(..))
import Game.Types.Model (Model)
import Game.Update as Update
import Prelude (map)

-- Interface to be accessed by Javascript.
-- The only things that the JS should ever
-- call are the functions in this file.


-- USE THE FOLLOWING METHODS TO MANAGE MODEL STATE


initialModel ∷ Model
initialModel = Init.initialModel

updateModel ∷ Message → Model → Model
updateModel = Update.update


-- USE THE FOLLOWING FUNCTIONS TO CREATE MESSAGES
-- WHICH CAN BE SENT TO 'UPDATE'


togglePauseMessage ∷ Message
togglePauseMessage = TogglePause

restartMessage ∷ Message
restartMessage = Restart

toggleFastForwardMessage ∷ Message
toggleFastForwardMessage = ToggleFastForward

updateTimeMessage ∷ Number → Message
updateTimeMessage timestampMilliseconds = UpdateTime timestampMilliseconds

makeChoiceMessage ∷ String → Message
makeChoiceMessage prompt = MakeChoice prompt


-- USE THE FOLLOWING TO GET CURRENT MODEL STATE --


isPaused ∷ Model → Boolean
isPaused model = model.paused

inFastForwardState ∷ Model → Boolean
inFastForwardState model = model.fastForward

getTimePassedSeconds ∷ Model → Number
getTimePassedSeconds model = Time.toSeconds model.gameState.gameTime

getMessages ∷ Model → Array String
getMessages model = Printer.allMessages model 
                    |> listToArray

hasActiveChoices ∷ Model → Boolean
hasActiveChoices = ModelHelpers.hasActiveChoices

getChoiceButtonLabels ∷ Model → Array String
getChoiceButtonLabels m = map (\c → c.prompt) m.activeChoices 
                          |> listToArray
