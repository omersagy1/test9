module Common.Annex where

import Prelude


pipeForward ∷ ∀ a b. a → (a → b) → b
pipeForward = (#)
infixl 0 pipeForward as |>


pipeBack ∷ ∀ a b. (a → b) → a → b
pipeBack = ($)
infixr 0 pipeBack as <|
