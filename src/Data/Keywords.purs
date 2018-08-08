module Data.Keywords where

import Common.Annex ((|>))
import Data.Buildable (class Buildable)
import Game.Types.Condition (Condition(..), PureCondition(..))

import Data.Builder (Builder(..), getConstruct)
import Game.Types.Story (Story(..))
import Game.Types.StoryEvent (AtomicEvent(..), StoryEvent(..))
import Game.Types.TopLevelEvent (body, reoccurring, trigger)
import Game.Types.TopLevelEvent as TopLevelEvent
import Prelude (Unit, identity, unit)


begin ∷ ∀ s. Builder s Unit → s
begin = getConstruct

build ∷ ∀ a. Buildable a ⇒ a → Builder a Unit
build x = BD x unit


-- TOP LEVEL EVENT HELPERS --
reoccuring ∷ Boolean
reoccuring = true

onlyOnce ∷ Boolean
onlyOnce = false

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

-- CONDITION HELPERS --

never ∷ Condition
never = Pure Never
