module Game.Printer where

import Common.Annex (maybeToList, (|>))
import Data.Int as Int
import Data.List (List, (:))
import Data.Maybe (Maybe(..), isJust)
import Data.String as String

import Common.Animation as Animation
import Common.Time (Time, seconds)
import Game.Types.Model (Model, ScrollingMessage)
import Prelude (not, (<>), (*))


update ∷ Time → Model → Model
update timePassed model =
  case model.activeScrollingMessage of
    Nothing → model
    Just msg → 
      let
        updatedMsg = msg { animation = Animation.update timePassed msg.animation }
      in
        model { activeScrollingMessage = Just updatedMsg }
        |> endIfComplete


setActiveMessage ∷ String → Model → Model
setActiveMessage msg model = 
  model { activeScrollingMessage = Just (scrollingMessage msg) }


endIfComplete ∷ Model → Model
endIfComplete model =
  case model.activeScrollingMessage of
    Nothing → model
    Just msg → 
      if not (scrollComplete msg) then model
      else
        model { activeScrollingMessage = Nothing
              , messageHistory = (msg.fullText):model.messageHistory }


isPrinting ∷ Model → Boolean
isPrinting model = isJust model.activeScrollingMessage


allMessages ∷ Model → List String
allMessages m = (maybeToList (activeMessage m)) <> (messageHistory m)


-- All messages already fully printed.
messageHistory ∷ Model → List String
messageHistory m = m.messageHistory


activeMessage ∷ Model → Maybe String
activeMessage m =
  case m.activeScrollingMessage of
    Nothing → Nothing
    Just scrollingMessage →
      Just (currentText scrollingMessage)


scrollingMessage ∷ String → ScrollingMessage
scrollingMessage msg =
  { fullText: msg
  , animation: Animation.init (scrollTime msg)
  }


scrollComplete ∷ ScrollingMessage → Boolean
scrollComplete msg = Animation.complete msg.animation


currentText ∷ ScrollingMessage → String
currentText sm =
  let
    totalNumChars = String.length (sm.fullText)
    fracToDisplay = Animation.currentValue sm.animation
    numCharsToDisplay = (Int.toNumber totalNumChars) * fracToDisplay
  in
    String.take (Int.round numCharsToDisplay) sm.fullText


timePerCharacter ∷ Time
timePerCharacter = seconds 0.03


scrollTime ∷ String → Time
scrollTime s = (Int.toNumber (String.length s)) * timePerCharacter
