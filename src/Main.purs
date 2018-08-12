module Main where

import Common.Annex ((|>))
import Common.Time

import Data.Maybe (Maybe(..))
import Prelude (not, (+), (-))


-- INTERFACE TO BE USED BY JAVASCRIPT 

initialModel ∷ Model
initialModel = init

updateModel ∷ Message → Model → Model
updateModel = update

getCounter ∷ Model → Int
getCounter (Model model) = model.counter

getToggleState ∷ Model → Boolean
getToggleState (Model model) = model.toggle

getTimePassed ∷ Model → Number
getTimePassed (Model model) = model.gameTimePassed


toggleMessage ∷ Message
toggleMessage = Toggle

incMessage ∷ Message
incMessage = IncrementCounter

resetMessage ∷ Message
resetMessage = ResetCounter

updateTimeMessage ∷ Number → Message
updateTimeMessage t = UpdateTime t


-- END INTERFACE 


data Model = Model
  { counter ∷ Int
  , toggle ∷ Boolean
  , timeLastFrame ∷ Maybe Time
  , gameTimePassed ∷ Time
  }


data Message = Toggle
               | IncrementCounter
               | ResetCounter
               | UpdateTime Time


init ∷ Model
init = Model 
  { counter: 0
  , toggle: false 
  , timeLastFrame: Nothing
  , gameTimePassed: 0.0
  }


update ∷ Message → Model → Model
update msg (Model model) =
  case msg of
    UpdateTime timestamp → updateTime timestamp (Model model)
    Toggle → Model (model { toggle = not model.toggle })
    IncrementCounter → Model (model { counter = model.counter + 1 })
    ResetCounter → Model (model { counter = 0 })


updateTime ∷ Time → Model → Model
updateTime t (Model model) =
  updateTimePassed t (Model model)
  |> updateTimeLastFrame t


updateTimeLastFrame ∷ Time → Model → Model
updateTimeLastFrame t (Model model) =
  Model (model { timeLastFrame = Just t })


updateTimePassed ∷ Time → Model → Model
updateTimePassed t (Model model) =
  let 
    tot = case model.timeLastFrame of
            Nothing → 0.0
            Just x → model.gameTimePassed + (t - x)
  in
    Model (model {gameTimePassed = tot}) 
