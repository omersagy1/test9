module Data.Scene where


import Common.Annex
import Data.Builder (Builder(..), Construct(..), getStory, getEvent, getConstruct)
import Game.Types.Story (Story(..))
import Game.Types.StoryEvent (AtomicEvent(..), StoryEvent(..))
import Game.Types.TopLevelEvent (TopLevelEvent)
import Game.Types.TopLevelEvent as TopLevelEvent
import Prelude (Unit, discard, unit, ($), (<<<))


top ∷ String → Builder Unit
top name = Builder unit (S (Story [TopLevelEvent.new name (Atomic StartInteraction)]))

fl ∷ TopLevelEvent → Builder Unit
fl e = Builder unit (S (Story [e]))

ln ∷ String → Builder Unit
ln text = Builder unit (E (Atomic (Narration text)))

body ∷ Builder Unit → StoryEvent
body b = (getEvent <<< getConstruct) b

story ∷ Story
story = getStory $ getConstruct $ do

  top <| "first"
  top "second"
  top "third"
  fl <| 
    TopLevelEvent.new "fourth" (Atomic StartInteraction)
  fl <|
    TopLevelEvent.new "fifth" (body $ do
    ln "first line!"
    ln "second line!"
    ln "fourth line!"
    ln "fifth line!"
    ln "sixth line!")

