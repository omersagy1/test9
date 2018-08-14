module Game.Types.Action where

import Prelude (not)

import Common.Time (Time)
import Game.Types.ActionName (Name(..))
import Game.Types.Condition as Condition
import Game.Types.Condition (PureCondition)
import Game.Types.Cooldown as Cooldown
import Game.Types.Cooldown (Cooldown)
import Game.Types.Effect as Effect
import Game.Types.Effect (Effect)


type Action =
  { name ∷ Name
  , active∷ Boolean
  , effect ∷ Effect
  , cooldown ∷ Cooldown
  , condition ∷ PureCondition
  }


init ∷ String → Action
init name =
  { name: UserDefined name
  , active: false
  , effect: Effect.NoEffect
  , cooldown: Cooldown.new 0.0
  , condition: Condition.Always
  }


fireAction ∷ Time → Action
fireAction cooldownTime =
  { name: StokeFire
  , active: true
  , effect: Effect.Compound2 Effect.StokeFire 
                             (Effect.SubtractResource "wood" 1)
  , cooldown: Cooldown.new cooldownTime
  , condition: Condition.ResourceAmountAbove "wood" 1
  }


effect ∷ Effect → Action → Action
effect e a = a { effect = e }


cooldown ∷ Time → Action → Action
cooldown t a = a { cooldown = Cooldown.new t }


updateCooldown ∷ Time → Action → Action
updateCooldown t a =
  if not a.active then a
  else
    a { cooldown = Cooldown.update t a.cooldown }


activate ∷ Action → Action
activate a = a { active = true }


deactivate ∷ Action → Action
deactivate a = a { active = false }


ready ∷ Action → Boolean
ready a = not (Cooldown.isCoolingDown a.cooldown)


performAction ∷ Action → Action
performAction a =
  if not (ready a) then a
  else
    a { cooldown = Cooldown.start a.cooldown }
