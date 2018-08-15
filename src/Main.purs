module Main where

import Game.Init as Init
import Game.Update as Update
import Game.Types.Message (Message(..))
import Game.Types.Model (Model)

-- Interface to be accessed by Javascript.
-- The only things that the JS should ever
-- call are the functions in this file.

initialModel ∷ Model
initialModel = Init.initialModel

updateModel ∷ Message → Model → Model
updateModel = Update.update

getTimePassed ∷ Model → Number
getTimePassed model = model.gameTimePassed

updateTimeMessage ∷ Number → Message
updateTimeMessage t = UpdateTime t
