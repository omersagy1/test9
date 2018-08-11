module Main where

import Prelude


-- INTERFACE TO BE USED BY JAVASCRIPT 

initialModel ∷ Model
initialModel = init

updateModel ∷ Message → Model → Model
updateModel = update

getCounter ∷ Model → Int
getCounter (Model model) = model.counter

getToggleState ∷ Model → Boolean
getToggleState (Model model) = model.toggle

toggleMessage ∷ Message
toggleMessage = Toggle

incMessage ∷ Message
incMessage = IncrementCounter

resetMessage ∷ Message
resetMessage = ResetCounter


-- END INTERFACE 

data Model = Model
  { counter ∷ Int
  , toggle ∷ Boolean
  }


data Message = Toggle
               | IncrementCounter
               | ResetCounter


init ∷ Model
init = Model { counter: 0, toggle: false }

update ∷ Message → Model → Model
update msg (Model model) =
  case msg of
    Toggle → Model (model { toggle = model.toggle })
    IncrementCounter → Model (model { counter = model.counter + 1 })
    ResetCounter → Model (model { counter = 0 })
