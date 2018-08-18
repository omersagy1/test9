module Game.RunCondition where

import Common.Annex (maybePred, (|>))
import Common.Time (Time)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Prelude (not, (&&), (<), (<=), (==), (>=), (||))

import Game.Types.ActionName as ActionName
import Game.Types.Condition (Condition(..), PureCondition(..))
import Game.Types.Fire as Fire
import Game.Types.Item as Item
import Game.Types.GameState (GameState)
import Game.StateMutators as StateMutators


condition ∷ Condition → GameState → Tuple Boolean GameState
condition c s =
  case c of
    Pure pureCondition → Tuple (pure pureCondition s) s
    And c1 c2 → and c1 c2 s
    Or c1 c2 → or c1 c2 s
    Not c1 → notFn c1 s
    other → Tuple false s


pure ∷ PureCondition → GameState → Boolean
pure c s =
  case c of
    GameTimePassed t → gameTimePassed t s
    Never → false
    Always → true
    ResourceAmountAbove name val → resourceAbove name val s
    ResourceActive name → resourceActive name s
    FireExtinguished → fireExtinguished s
    FireStoked → actionPerformed ActionName.StokeFire s
    ActionPerformed action → customActionPerformed action s
    MilestoneReached name → milestoneReached name s
    TimeSinceMilestone name t → timePassedSince name t s
    MilestoneAtCount name x → milestoneAtCount name x s
    MilestoneGreaterThan name x → milestoneGreaterThan name x s


type ConditionFn = GameState → Boolean


gameTimePassed ∷ Time → ConditionFn
gameTimePassed t = (\s → s.gameTime >= t)


resourceAbove ∷ String → Int → ConditionFn
resourceAbove name amount =
  (\s →
    case StateMutators.getItemNamed name s of
      Nothing → false
      Just r → (Item.getAmount r) >= amount)


resourceActive ∷ String → ConditionFn
resourceActive name =
  (\s → StateMutators.resourceActive name s)


fireExtinguished ∷ ConditionFn
fireExtinguished s = Fire.isExtinguished s.fire


actionPerformed ∷ ActionName.Name → ConditionFn
actionPerformed a = (\s → StateMutators.actionPerformed a s)


customActionPerformed ∷ ActionName.Name → ConditionFn
customActionPerformed name = 
  (\s → StateMutators.actionPerformed name s)


milestoneReached ∷ String → ConditionFn
milestoneReached name = StateMutators.milestoneReached name


timePassedSince ∷ String → Time → ConditionFn
timePassedSince name target = 
  (\s → 
    StateMutators.timeSince name s 
    |> maybePred ((<=) target))


milestoneAtCount ∷ String → Int → ConditionFn
milestoneAtCount name target =
  (\s →
    StateMutators.milestoneCounter name s
    |> (==) target)


milestoneGreaterThan ∷ String → Int → ConditionFn
milestoneGreaterThan name target =
  (\s →
    StateMutators.milestoneCounter name s
    |> (<) target)



and ∷ Condition → Condition → GameState → Tuple Boolean GameState
and c1 c2 s =
  let
    Tuple a s1 = condition c1 s
    Tuple b s2 = condition c2 s1
  in
    Tuple (a && b) s2


or ∷ Condition → Condition → GameState → Tuple Boolean GameState
or c1 c2 s =
  let
    Tuple a s1 = condition c1 s
    Tuple b s2 = condition c2 s1
  in
    Tuple (a || b) s2


notFn ∷ Condition → GameState → Tuple Boolean GameState
notFn c s =
  let
    Tuple a s1 = condition c s
  in
    Tuple (not a) s1
