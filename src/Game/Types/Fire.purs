module Game.Types.Fire where

import Prelude

import Common.Time (Time)
import Game.Types.Cooldown as Cooldown
import Game.Types.Cooldown (Cooldown)


type Fire = { strength ∷ Cooldown }


init ∷ Time → Fire
init burnTime = { strength: Cooldown.new burnTime }


update ∷ Time → Fire → Fire
update t f = f { strength = Cooldown.update t f.strength }


stoke ∷ Fire → Fire
stoke f = { strength: Cooldown.start f.strength }


strength ∷ Fire → Number
strength f = Cooldown.currentFraction f.strength


isExtinguished ∷ Fire → Boolean
isExtinguished f = not (Cooldown.isCoolingDown f.strength)
