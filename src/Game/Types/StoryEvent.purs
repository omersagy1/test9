module Game.Types.StoryEvent where

import Data.List
import Data.Tuple (Tuple)
import Game.Types.Condition (Condition)
import Game.Types.Effect (Effect)
import Prelude (class Show, show, (<>))


data StoryEvent = 
  Atomic AtomicEvent
  | Sequenced (List StoryEvent)
  -- A list of possible choices for the player, with the text prompt for each.
  -- Choices will only appear if their condition is either Nothing or evaluates to True.
  | PlayerChoice (List Choice)
  | Conditioned ConditionedEvent
  -- List of options and their relative weights.
  -- A weight of 2 has twice the chance of being
  -- picked as a weight of 1.
  | Random (List (Tuple StoryEvent Int))
  -- First event which satisfies its condition is picked.
  | Cases (List ConditionedEvent) 

-- A storyevent that only runs if its condition evaluates to True.
data ConditionedEvent = ConditionedEvent Condition StoryEvent

data AtomicEvent =
  Narration String
  -- Dialogue causes "interaction mode" to start if it hasn't started already.
  -- This freezes many aspects of the game. It will also print the text in quotes.
  | Dialogue String
  -- Starts interaction mode, pausing gameplay outside the interaction.
  | StartInteraction
  -- Ends interaction mode and resumes the running of time in the game.
  | EndInteraction
  -- Reference to the name of another StoryEvent.
  | Goto String
  -- Executes some kind of state-mutating effect on the game.
  | Effectful Effect

type Choice =
  { condition ∷ Condition
  , prompt ∷ String
  , consq ∷ StoryEvent 
  }

instance showStoryEvent ∷ Show StoryEvent where
  show ∷ StoryEvent → String
  show e =
    case e of
      Atomic StartInteraction → "start-interaction"
      Atomic EndInteraction → "end-interaction"
      Atomic (Narration s) → "ln: " <> s
      Atomic (Dialogue s) → "di: " <> s
      Atomic (Effectful effect) → "effect: " <> (show effect)
      Atomic (Goto s) → "goto: " <> s
      Conditioned (ConditionedEvent c ce) → "conditioned: " <> (show ce)
      Sequenced es → (show es)
      other → "unimplemented"


