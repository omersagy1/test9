module Script.Keywords where

import Prelude (Unit, identity, unit, (>>>))
import Data.Time (Time)

import Common.Annex ((|>))
import Game.Types.ActionName (Name(..))
import Game.Types.Condition (Condition(..), PureCondition(..))
import Game.Types.Effect (Effect)
import Game.Types.Story (Story(..))
import Game.Types.StoryEvent (AtomicEvent(..), ConditionedEvent(..), StoryEvent(..))
import Game.Types.TopLevelEvent (body, reoccurring, trigger)
import Game.Types.TopLevelEvent as TopLevelEvent
import Script.Buildable (class Buildable)
import Script.Builder (Builder(..), getConstruct)


begin ∷ ∀ s. Builder s Unit → s
begin = getConstruct

build ∷ ∀ a. Buildable a ⇒ a → Builder a Unit
build x = BD x unit


-- TOP LEVEL EVENT HELPERS --
reoccuringWhen ∷ Boolean
reoccuringWhen = true

occursOnceWhen ∷ Boolean
occursOnceWhen = false

top ∷ String → Boolean → Condition → StoryEvent → Builder Story Unit
top n r c e =
  let 
    tl = TopLevelEvent.new n
               |> (if r then reoccurring else identity)
               |> (trigger c)
               |> (body e)
  in
    build (Story [tl])

-- STORY EVENT HELPERS --

ln ∷ String → Builder StoryEvent Unit
ln text = build (Atomic (Narration text))

di ∷ String → Builder StoryEvent Unit
di text = build (Atomic (Dialogue text))

restrict ∷ Builder StoryEvent Unit
restrict = build (Atomic StartInteraction)

resume ∷ Builder StoryEvent Unit
resume = build (Atomic EndInteraction)

cond ∷ Condition → StoryEvent → Builder StoryEvent Unit
cond c e = build (Conditioned (ConditionedEvent c e))

effect ∷ Effect → Builder StoryEvent Unit
effect e = build (Atomic (Effectful e))

goto ∷ String → Builder StoryEvent Unit
goto s = build (Atomic (Goto s))


-- CONDITION HELPERS --

chance ∷ Number → Condition
chance = Chance 

and ∷ Condition → Condition → Condition
and = And 

or ∷ Condition → Condition → Condition
or = Or 

notif ∷ Condition → Condition
notif = Not 

gameTimePassed ∷ Time → Condition
gameTimePassed = GameTimePassed >>> Pure

never ∷ Condition
never = Never |> Pure

unconditionally ∷ Condition
unconditionally = Always |> Pure

resourceAmountAbove ∷ String → Int → Condition
resourceAmountAbove = (\r c → Pure (ResourceAmountAbove r c))

resourceActive ∷ String → Condition
resourceActive = ResourceActive >>> Pure

fireExtinguished ∷ Condition
fireExtinguished = FireExtinguished |> Pure

fireStoked ∷ Condition
fireStoked = FireStoked |> Pure

actionPerformed ∷ String → Condition
actionPerformed = UserDefined >>> ActionPerformed >>> Pure

milestoneReached ∷ String → Condition
milestoneReached = MilestoneReached >>> Pure

timeSinceMilestone ∷ String → Time → Condition
timeSinceMilestone = (\t c → Pure (TimeSinceMilestone t c))

milestoneAtCount ∷ String → Int → Condition
milestoneAtCount = (\m c → Pure (MilestoneAtCount m c))

milestoneGreaterThan ∷ String → Int → Condition
milestoneGreaterThan = (\m c → Pure (MilestoneGreaterThan m c))
