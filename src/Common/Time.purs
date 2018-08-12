module Common.Time where

import Prelude


type Time = Number

second ∷ Time
second = 1000.0

minute ∷ Time
minute = 60.0 * second

milli ∷ Time
milli = 1.0
