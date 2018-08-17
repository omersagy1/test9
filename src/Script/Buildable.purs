module Script.Buildable where

import Prelude (append, (<>))
import Data.List (List(..), snoc, (:))

import Game.Types.StoryEvent (StoryEvent(..))


class Buildable a where
  -- Like <> but 'combine' does not have to be associative.
  -- combine earlier built = ...
  combine ∷ a → a → a
  -- Like mempty.
  default ∷ a


instance buildableStoryEvent ∷ Buildable StoryEvent where

  combine ∷ StoryEvent → StoryEvent → StoryEvent
  combine (Sequenced events) (Sequenced more) = Sequenced (append events more)
  combine (Sequenced events) e = Sequenced (snoc events e)
  combine e (Sequenced events) = Sequenced (e : events)
  combine e1 e2 = Sequenced (e1 : e2 : Nil)

  default ∷ StoryEvent
  default = Sequenced Nil


instance buildableList ∷ Buildable (List a) where
  combine ∷ List a → List a → List a
  combine = (<>)

  default ∷ List a
  default = Nil
