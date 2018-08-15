module Game.Update where

import Prelude ((+), (-))
import Data.Maybe (Maybe(..))

import Common.Annex ((|>))
import Common.Time (Time)
import Game.Types.Message (Message(..))
import Game.Types.Model (Model)


update ∷ Message → Model → Model
update msg model =
  case msg of
    UpdateTime timestamp → updateTime timestamp model
    other → model


updateTime ∷ Time → Model → Model
updateTime t model =
  updateTimePassed t model
  |> updateTimeLastFrame t


updateTimeLastFrame ∷ Time → Model → Model
updateTimeLastFrame t model =
  model { timeLastFrame = Just t }


updateTimePassed ∷ Time → Model → Model
updateTimePassed t model =
  let 
    tot = case model.timeLastFrame of
            Nothing → 0.0
            Just x → model.gameTimePassed + (t - x)
  in
    model {gameTimePassed = tot}
