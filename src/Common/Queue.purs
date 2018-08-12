module Common.Queue where

import Prelude ((+))

import Data.List (List(..), (:))
import Data.List as List
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))

import Common.Annex ((|>))

data Queue a = Q (List a) (List a)

new ∷ ∀ a. Queue a
new = Q Nil Nil

enqueue ∷ ∀ a. a → Queue a → Queue a
enqueue x (Q front rear) = Q front (x:rear)

push ∷ ∀ a. a → Queue a → Queue a
push x (Q front rear) = Q (x:front) rear

dequeue ∷ ∀ a. Queue a → Tuple (Maybe a) (Queue a)
dequeue queue =
  case queue of
    -- Queue is empty, return nothing.
    Q Nil Nil → Tuple Nothing (Q Nil Nil)

    -- Front is empty, reverse the rear and return the first element.
    Q Nil rear → 
      let 
        front = List.reverse rear
        rtn = List.head front
        remainingFront = List.tail front
      in
        -- TODO: This check should not be necessary since we know
        -- that 'rear' is not [].
        case remainingFront of
          Nothing → Tuple rtn (Q Nil Nil)
          Just x → Tuple rtn (Q x Nil)

    -- Front is non-empty, return its first element.
    Q (x:xs) rear → Tuple (Just x) (Q xs rear)


peek ∷ ∀ a. Queue a → Maybe a
peek queue =
  case queue of
    Q Nil Nil → Nothing
    Q Nil rear → List.reverse rear |> List.head
    Q front rear → List.head front


size ∷ ∀ a. Queue a → Int
size (Q front rear) = (List.length front) + (List.length rear)
