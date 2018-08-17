module Game.Types.Story where

import Prelude ((==))
import Data.List
import Data.Maybe (Maybe(..))

import Game.Types.TopLevelEvent (TopLevelEvent)


type Story = List TopLevelEvent


new ∷ Story
new = Nil


getEventByName ∷ String → Story → Maybe TopLevelEvent
getEventByName name story =
  let
    matches = filter (\e → e.name == name) story
  in
    case matches of
      Nil → Nothing
      -- Only return the first match.
      head:tail → Just head
