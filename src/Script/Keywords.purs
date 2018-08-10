module Script.Keywords where

import Data.List

import Common.Annex ((|>))
import Data.Time (Time)
import Game.Types.ActionName (Name(..))
import Game.Types.Condition (Condition(..), PureCondition(..))
import Game.Types.Effect (Effect)
import Game.Types.Story (Story(..))
import Game.Types.StoryEvent (AtomicEvent(..), Choice(..), ConditionedEvent(..), StoryEvent(..))
import Game.Types.TopLevelEvent (body, reoccurring, trigger)
import Game.Types.TopLevelEvent as TopLevelEvent
import Prelude (Unit, identity, unit, (>>>), ($))
import Script.Buildable (class Buildable)
import Script.Builder (Builder(..), getConstruct)

-- BUILDER HELPERS --

type EventBuilder = Builder StoryEvent Unit

type StoryBuilder = Builder Story Unit

type ChoicesBuilder = Builder (List Choice) Unit


begin ∷ ∀ s. Builder s Unit → s
begin = getConstruct

build ∷ ∀ a. Buildable a ⇒ a → Builder a Unit
build x = BD x unit

nestBuilder ∷ ∀ a b. (a → b) → Builder a Unit → b
nestBuilder fn (BD x unit) = fn x
infixr 0 nestBuilder as #


-- TOP LEVEL EVENT HELPERS --

reoccuringWhen ∷ Boolean
reoccuringWhen = true

occursOnceWhen ∷ Boolean
occursOnceWhen = false

top ∷ String → Boolean → Condition → StoryEvent → StoryBuilder
top n r c e =
  let 
    tl = TopLevelEvent.new n
               |> (if r then reoccurring else identity)
               |> (trigger c)
               |> (body e)
  in
    build (Story [tl])

-- STORY EVENT HELPERS --

ln ∷ String → EventBuilder
ln text = build (Atomic (Narration text))

di ∷ String → EventBuilder
di text = build (Atomic (Dialogue text))

restrict ∷ EventBuilder
restrict = build (Atomic StartInteraction)

resume ∷ EventBuilder
resume = build (Atomic EndInteraction)

cond ∷ Condition → StoryEvent → EventBuilder
cond c e = build (Conditioned (ConditionedEvent c e))

effect ∷ Effect → EventBuilder
effect e = build (Atomic (Effectful e))

goto ∷ String → EventBuilder
goto s = build (Atomic (Goto s))

choices ∷ List Choice → EventBuilder
choices c = build (PlayerChoice c)

prompt ∷ String → StoryEvent → ChoicesBuilder
prompt s e = build $ singleton $ Choice { prompt: s, consq: e, condition: unconditionally }

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
