module Data.TopLevelEvent where

import Prelude

import Game.Types.StoryEvent
import Game.Types.Condition


data TopLevelEvent = TopLevel 
  { name ∷ String
  , reoccurring ∷ Boolean
  , trigger ∷ Condition
  , event ∷ StoryEvent
  }
