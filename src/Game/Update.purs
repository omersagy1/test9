module Game.Update where

import Common.Annex ((|>))
import Common.Time (Time)
import Data.Maybe (Maybe(..))
import Game.ModelHelpers as ModelHelpers
import Game.Types.Message (Message(..))
import Game.Types.Model (Model)
import Game.UpdateTime as UpdateTime
import Prelude ((-))


update ∷ Message → Model → Model
update msg model =
  case msg of

    TogglePause → ModelHelpers.togglePause model

    ToggleFastForward → ModelHelpers.toggleFastForward model

    Restart → ModelHelpers.restart model.paused

    UpdateTime timestamp → 
      if ModelHelpers.storyPaused model then model
      else 
        updateTime timestamp model

    MakeChoice prompt → 
      if ModelHelpers.hardPaused model then model
      else
        makeChoice prompt model

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


makeChoice ∷ String → Model → Model
makeChoice prompt model =
  let
    choice = ModelHelpers.getActiveChoiceWithPrompt prompt model
  in
    case choice of
      Nothing → model
      Just c →
        ModelHelpers.clearActiveChoices model
        |> UpdateTime.pushStoryEventWithDelay c.consq 0.0
