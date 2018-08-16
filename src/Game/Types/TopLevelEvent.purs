module Game.Types.TopLevelEvent where

import Data.List (List(..))

import Game.Types.StoryEvent (StoryEvent(..))
import Game.Types.Condition (Condition)
import Game.Types.Condition as Condition


type TopLevelEvent =
  { name ∷ String
  , reoccurring ∷ Boolean
  , trigger ∷ Condition
  , event ∷ StoryEvent
  }


new ∷ String → TopLevelEvent
new n = 
  { name: n
  , reoccurring: false
  , trigger: Condition.Pure Condition.Never
  , event: Sequenced Nil
  }

reoccurring ∷ TopLevelEvent → TopLevelEvent
reoccurring e = e {reoccurring = true}

trigger ∷ Condition → TopLevelEvent → TopLevelEvent
trigger c e = e {trigger = c}

body ∷ StoryEvent → TopLevelEvent → TopLevelEvent
body e t = t {event = e}
