module Common.Animation where

import Prelude

import Common.Time (Time)


-- Animates linearly between 0 and 1.
data Animation = Linear LinearParams


type LinearParams =
  { timePassed ∷ Time
  , totalDuration ∷ Time
  }


init ∷ Time → Animation
init duration = Linear { timePassed: 0.0, totalDuration: duration }


update ∷ Time → Animation → Animation
update timePassed anim =
  case anim of
    Linear params → 
      Linear params
        { timePassed = min (params.timePassed + timePassed) params.totalDuration }


currentValue ∷ Animation → Number
currentValue anim =
  case anim of
    Linear params → params.timePassed / params.totalDuration


complete ∷ Animation → Boolean
complete anim = (currentValue anim) == 1.0
