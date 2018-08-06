module Data.Scenario where

import Prelude

import Data.List (List)

newtype Story = Story (List TopLevelEvent)

data TopLevelEvent = TopLevel 
  { name ∷ String
  , reoccurring ∷ Boolean
  , trigger ∷ Condition
  , event ∷ StoryEvent
  }

data StoryEvent = 
  Atomic AtomicEvent
  | Sequenced (List StoryEvent)
  -- A list of possible choices for the player, with the text prompt for each.
  -- Choices will only appear if their condition is either Nothing or evaluates to True.
  | PlayerChoice (List Choice)
  | Conditioned ConditionedEvent
  -- All options have equal weight.
  | Random (List StoryEvent)
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


data Choice = Choice
  { condition ∷ Condition
  , prompt ∷ String
  , consq ∷ StoryEvent 
  }

data Condition = Pure PureCondition
                 | Chance Number
                 | And Condition Condition
                 | Or Condition Condition
                 | Not Condition

data PureCondition = GameTimePassed Number -- TODO: Time
                     | Never
                     | Always
                     | ResourceAmountAbove String Int 
                     | ResourceActive String
                     | FireExtinguished
                     | FireStoked
                     | ActionPerformed Name
                     | MilestoneReached String
                     | TimeSinceMilestone String Number -- TODO: Time
                     | MilestoneAtCount String Int
                     | MilestoneGreaterThan String Int

data Name = StokeFire 
            | UserDefined String

data Effect = NoEffect
              | ActivateResource String
              | AddToResource String Int
              | AddToResourceRand String Int Int
              | SubtractResource String Int
              | SetResourceAmount String Int
              | SetMilestoneReached String
              | IncrementMilestone String
              | ActivateAction Name
              | DeactivateAction Name
              | StokeFireEff
              | GameOver
              | Compound (List Effect)
              | Compound2 Effect Effect

forwardPipe ∷ ∀ a b. a → (a → b) → b
forwardPipe = (#)
infixl 0 forwardPipe as |>

backPipe ∷ ∀ a b. (a → b) → a → b
backPipe = ($)
infixl 1 backPipe as <|


data State a = State a Int

counter ∷ ∀ a. State a → Int
counter (State x c) = c

instance sFunctor ∷ Functor State  where
  map ∷ ∀ a b. (a → b) → State a → State b
  map f (State x c) = State (f x) (c + 1)

instance sApply ∷ Apply State where
  apply ∷ ∀ a b. State (a → b) → State a → State b
  apply (State f c1) (State x c2) = (State (f x) (c1 + c2))

instance sApplicative ∷ Applicative State where
  pure ∷ ∀ a. a → State a
  pure x = State x 1

instance sBind ∷ Bind State where
  bind ∷ ∀ a b. State a → (a → State b) → State b
  bind (State x c1) fn = 
    let
      (State y c2) = fn x
    in
      (State y (c1 + c2))
    
instance sMonad ∷ Monad State

instance sShow ∷ Show a ⇒ Show (State a) where
  show ∷ State a  → String
  show (State x c) = "State: " <> (show x) <> " with counter: " <> (show c)


init ∷ Int → State Int
init x = pure x

dummy ∷ State Unit
dummy = pure unit

inc ∷ State Int → State Int
inc (State x c) = (State x (c + 1))

p ∷ State Int
p = (init 10) >>= (\x → 
      (init 20) >>= (\y →
        (init 10) >>= (\z →
          pure (x + y) >>= (\r →
            (pure (r * z))))))

q ∷ State Int
q = do
  x ← init 10
  y ← init 20
  z ← init 10
  r ← pure (x + y)
  _ ← init 9
  _ ← init 9
  dummy
  dummy
  pure (r * z)

-- story ∷ Story
-- story = begin
-- 
--   |> add (topLevel 
--   |> name "first"
--   |> trigger (gameTimePassed (0*Time.second))
--   |> body (start
--   |> effect (activateAction "search for wood")
--   |> ln "narrating...."
--   |> ln "mysterious..."
--   |> restrict
--   |> di "Hello to you!"
--   |> di "We're talking together!"
--   |> di "one more line..."
--   |> resume
--   |> ln "back to narration."))
