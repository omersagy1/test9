module Game.Types.Milestones where

import Prelude ((+), map, (-))
import Data.Map (Map)
import Data.Map as Map
import Data.Maybe (Maybe(..), fromMaybe)

import Common.Annex ((|>))
import Common.Time (Time)


type Milestones = Map String Milestone


type Milestone =
  { name ∷ String
  , timeReached ∷ Time
  , counter ∷ Int
  }


init ∷ Milestones
init = Map.empty


inc ∷ Milestone → Milestone
inc m = m { counter = m.counter + 1 }


hasReached ∷ String → Milestones → Boolean
hasReached name milestones =
  Map.member name milestones


setReached ∷ String → Time → Milestones → Milestones
setReached name currentTime milestones =
  Map.insert name (newMilestone name currentTime |> inc) milestones


newMilestone ∷ String → Time → Milestone
newMilestone name timeReached = 
  { name: name
  , timeReached: timeReached
  , counter: 0
  }


timeSince ∷ String → Time → Milestones → Maybe Time
timeSince name currentTime milestones =
  Map.lookup name milestones
  |> map (\x → x.timeReached)
  |> map (\t → currentTime - t)


increment ∷ String → Time → Milestones → Milestones
increment name time milestones = 
  Map.alter (\maybem → case maybem of 
                          Nothing →
                            newMilestone name time |> inc |> Just
                          Just m → 
                            Just (inc m))
              name
              milestones


counter ∷ String → Milestones → Int
counter name milestones =
  Map.lookup name milestones 
  |> map (\x → x.counter)
  |> (fromMaybe 0)
