module Game.Types.Story where

import Prelude (class Monoid, class Semigroup, class Show, mempty, show, (<>), (==))
import Data.Array as Array
import Data.Maybe (Maybe(..))

import Game.Types.TopLevelEvent (TopLevelEvent)


data Story = Story (Array TopLevelEvent)


instance showStory ∷ Show Story where
  show ∷ Story → String
  show (Story s) = "Story: \n" <> (show s)


instance semigroupStory ∷ Semigroup Story where
  append ∷ Story → Story → Story
  append (Story s1) (Story s2) = (Story (s1 <> s2))


instance monoidStory ∷ Monoid Story where
  mempty ∷ Story
  mempty = Story []


new ∷ Story
new = mempty


getEventByName ∷ String → Story → Maybe TopLevelEvent
getEventByName name (Story story) =
  let
    matches = Array.filter (\e → e.name == name) story
  in
    case Array.uncons matches of
      Nothing → Nothing
      -- Only return the first match.
      Just { head: e, tail: es } → Just e
