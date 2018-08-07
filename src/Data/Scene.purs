module Data.Scene where

import Prelude (Unit, discard, unit, ($))

import Common.Annex
import Data.Builder (Builder(..), Construct(..), getStory, getConstruct)
import Game.Types.Story (Story(..))
import Game.Types.TopLevelEvent (TopLevelEvent)
import Game.Types.TopLevelEvent as TopLevelEvent
import Game.Types.StoryEvent (AtomicEvent(..), StoryEvent(..))


ev ∷ String → Builder Unit
ev name = Builder unit (S (Story [TopLevelEvent.new name (Atomic StartInteraction)]))

fl ∷ TopLevelEvent → Builder Unit
fl e = Builder unit (S (Story [e]))

story ∷ Story
story = getStory $ getConstruct $ do

  ev <| "first"
  ev "second"
  ev "third"
  fl <| 
    TopLevelEvent.new "fourth" (Atomic StartInteraction)
