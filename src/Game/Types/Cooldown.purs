module Game.Types.Cooldown where

import Common.Time (Time)

import Prelude


type Cooldown =
  { timeRemaining ∷ Time
  , duration ∷ Time
  }

new ∷ Time → Cooldown
new duration =
  { timeRemaining: 0.0
  , duration: duration
  }


update ∷ Time → Cooldown → Cooldown
update timePassed c = 
  c { timeRemaining = max 0.0 c.timeRemaining - timePassed }


isCoolingDown ∷ Cooldown → Boolean
isCoolingDown c = c.timeRemaining > 0.0


start ∷ Cooldown → Cooldown
start c = c { timeRemaining = c.duration }


currentFraction ∷ Cooldown → Number
currentFraction c = c.timeRemaining / c.duration
