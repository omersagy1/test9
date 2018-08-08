module Data.Scene where


import Common.Annex
import Data.Builder (Builder(..), getConstruct)
import Game.Types.Story (Story(..))
import Game.Types.StoryEvent (AtomicEvent(..), StoryEvent(..))
import Game.Types.TopLevelEvent (TopLevelEvent)
import Game.Types.TopLevelEvent as TopLevelEvent
import Prelude (Unit, discard, unit, ($))


top ∷ String → Builder Story Unit
top name = BD (Story [TopLevelEvent.new name (Atomic StartInteraction)]) unit

fl ∷ TopLevelEvent → Builder Story Unit
fl e = BD (Story [e]) unit

ln ∷ String → Builder StoryEvent Unit
ln text = BD (Atomic (Narration text)) unit


story ∷ Story
story = getConstruct $ do

  top <| "first"
  top "second"
  top "third"
  fl <| 
    TopLevelEvent.new "fourth" (Atomic StartInteraction)
  fl <|
    TopLevelEvent.new "fifth" (getConstruct $ do
    ln "first line!"
    ln "second line!"
    ln "fourth line!"
    ln "fifth line!"
    ln "sixth line!")

