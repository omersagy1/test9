module Common.Annex where

import Prelude ((#), ($))
import Data.Maybe (Maybe(..))
import Data.List (List(..), (:))
import Data.Tuple (Tuple(..), snd)


pipeForward ∷ ∀ a b. a → (a → b) → b
pipeForward = (#)
infixl 0 pipeForward as |>


pipeBack ∷ ∀ a b. (a → b) → a → b
pipeBack = ($)
infixr 0 pipeBack as <|


ignoreResult ∷ ∀ s a. (s → Tuple a s) → (s → s)
ignoreResult f = (\x → (f x) |> snd)


maybeToList ∷ ∀ a. Maybe a → List a
maybeToList x =
  case x of
    Nothing → Nil
    Just val → val : Nil

maybePred ∷ ∀ a. (a → Boolean) → Maybe a → Boolean
maybePred pred m =
  case m of
    Nothing → false
    Just x → pred x

-- TODO: figure out how to use this idea properly.
maybePerform ∷ ∀ a b. (a → b → b) → Maybe a → b → b
maybePerform mutateFn maybeArg struct =
  case maybeArg of
    Nothing → struct
    Just arg → mutateFn arg struct


filterMutate ∷ ∀ a b. 
                (a → b → Tuple Boolean b) → List a → b → Tuple (List a) b
filterMutate filterFn argList struct =
  case argList of
    Nil → Tuple Nil struct
    first:rest →
      let 
        Tuple success nextStruct = filterFn first struct
        Tuple restResults finalStruct = filterMutate filterFn rest nextStruct
      in
        if success then
          Tuple (first:restResults) finalStruct
        else
          Tuple restResults finalStruct
