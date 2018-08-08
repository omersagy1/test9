module Game.Types.TopLevelEvent where

import Prelude (class Show, show, (<>))
import Data.List (List(..))

import Game.Types.StoryEvent (StoryEvent(..))
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


new ∷ String → TopLevelEvent
new n = TopLevel
  { name: n
  , reoccurring: false
  , trigger: Condition.Pure Condition.Never
  , event: Sequenced Nil
  }

reoccurring ∷ TopLevelEvent → TopLevelEvent
reoccurring (TopLevel e) = TopLevel (e {reoccurring = true})

trigger ∷ Condition → TopLevelEvent → TopLevelEvent
trigger c (TopLevel e) = TopLevel (e {trigger = c})

body ∷ StoryEvent → TopLevelEvent → TopLevelEvent
body e (TopLevel t) = TopLevel (t {event = e})
