module Game.Update where

import Common.Annex ((|>))
import Common.Time (Time)
import Data.Maybe (Maybe(..))
import Game.Types.Message (Message(..))
import Game.Types.Model (Model)
import Game.UpdateTime as UpdateTime
import Prelude ((-))


update ∷ Message → Model → Model
update msg model =
  case msg of
    UpdateTime timestamp → updateTime timestamp model
    other → model


updateTime ∷ Time → Model → Model
updateTime absoluteStamp model =
  let t = timePassed absoluteStamp model
  in
    model
    |> updateTimeLastFrame absoluteStamp
    |> UpdateTime.updateGame t


updateTimeLastFrame ∷ Time → Model → Model
updateTimeLastFrame stamp model =
  model { timeLastFrame = Just stamp }


timePassed ∷ Time → Model → Time
timePassed stamp model =
  case model.timeLastFrame of
    Nothing → 0.0
    Just lastStamp → stamp - lastStamp
