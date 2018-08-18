module Main where

import Data.Maybe

import Common.Annex (listToArray, (|>))
import Common.Time as Time
import Game.Init as Init
import Game.Printer as Printer
import Game.Types.Message (Message(..))
import Game.Types.Model (Model)
import Game.Update as Update

-- Interface to be accessed by Javascript.
-- The only things that the JS should ever
-- call are the functions in this file.

initialModel ∷ Model
initialModel = Init.initialModel

updateModel ∷ Message → Model → Model
updateModel = Update.update

-- 't' should be measured in milliseconds.
updateTimeMessage ∷ Number → Message
updateTimeMessage t = UpdateTime t


-- USE THE FOLLOWING TO GET CURRENT MODEL STATE --

getTimePassedMillis ∷ Model → Number
getTimePassedMillis model = model.gameState.gameTime

getTimePassedSeconds ∷ Model → Number
getTimePassedSeconds model = Time.toSeconds model.gameState.gameTime

getMessages ∷ Model → Array String
getMessages model = Printer.allMessages model |> listToArray
