module Game.Types.TopLevelEvent where

import Prelude

import Game.Types.StoryEvent (StoryEvent)
import Game.Types.Condition (Condition)
import Game.Types.Condition as Condition


data TopLevelEvent = TopLevel 
  { name ∷ String
  , reoccurring ∷ Boolean
  , trigger ∷ Condition
  , event ∷ StoryEvent
  }

instance showTopLevelEvent ∷ Show TopLevelEvent where
  show ∷ TopLevelEvent → String
  show (TopLevel e) = (show e.name) <> " " <> (show e.event)


new ∷ String → StoryEvent → TopLevelEvent
new name event = TopLevel
  { name: name
  , reoccurring: false
  , trigger: Condition.Pure Condition.Never
  , event: event
  }
