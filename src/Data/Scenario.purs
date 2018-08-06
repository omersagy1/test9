module Data.Scenario where

import Prelude

import Data.List (List)


forwardPipe ∷ ∀ a b. a → (a → b) → b
forwardPipe = (#)
infixl 0 forwardPipe as |>

backPipe ∷ ∀ a b. (a → b) → a → b
backPipe = ($)
infixl 1 backPipe as <|
