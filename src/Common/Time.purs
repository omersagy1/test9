module Common.Time where

import Common.NumCompat (class NumberCompatible, (*))
import Prelude ((/))


-- The unit of time is a millisecond.
type Time = Number


second ∷ Time
second = 1000.0

minute ∷ Time
minute = 60.0 * second

milli ∷ Time
milli = 1.0

toSeconds ∷ Time → Number
toSeconds x = x / second

seconds ∷ ∀ a. NumberCompatible a ⇒ a → Time
seconds x = x * second
