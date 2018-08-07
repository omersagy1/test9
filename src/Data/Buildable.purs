module Data.Buildable where

import Prelude ((<>), mempty)
import Data.List (List(..), singleton, snoc)

import Game.Types.Story (Story)
import Game.Types.StoryEvent (AtomicEvent(..), StoryEvent(..))


class Buildable a where
  -- Like <> but 'combine' does not have to be associative.
  -- combine earlier built = ...
  combine ∷ a → a → a
  -- Like mempty.
  default ∷ a


instance buildableStory ∷ Buildable Story where
  combine = (<>)
  default = mempty


instance buildableStoryEvent ∷ Buildable StoryEvent where

  combine ∷ StoryEvent → StoryEvent → StoryEvent
  combine s1 s2 =
    case s2 of
      Sequenced events → Sequenced (Cons s1 events)
      other → Sequenced (snoc (singleton s1) s2)

  default = Atomic EndInteraction
