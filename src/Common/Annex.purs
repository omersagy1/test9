module Common.Annex where

import Prelude ((#), ($))
import Data.Tuple (Tuple, snd)


pipeForward ∷ ∀ a b. a → (a → b) → b
pipeForward = (#)
infixl 0 pipeForward as |>


pipeBack ∷ ∀ a b. (a → b) → a → b
pipeBack = ($)
infixr 0 pipeBack as <|


ignoreResult :: forall s a. (s -> Tuple a s) -> (s -> s)
ignoreResult f = (\x -> (f x) |> snd)
