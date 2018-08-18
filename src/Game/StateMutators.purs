module Game.StateMutators where

import Game.Types.GameState

import Common.Annex ((|>))
import Common.Time (Time)
import Data.List (List)
import Data.List as List
import Data.Maybe (Maybe)
import Data.Maybe as Maybe
import Game.Types.Action (Action)
import Game.Types.Action as Action
import Game.Types.ActionName as ActionName
import Game.Types.ActionSet as ActionSet
import Game.Types.Activatable as Activatable
import Game.Types.Effect (Effect)
import Game.Types.Effect as Effect
import Game.Types.Fire as Fire
import Game.Types.Item (Item(..))
import Game.Types.Item as Item
import Game.Types.Milestones as Milestones
import Game.Types.Named as Named
import Prelude ((+), (<>), not, map, (==))


update ∷ Time → GameState → GameState
update t s = 
  s { gameTime = s.gameTime + t }
  |> updateActionCooldowns t
  |> (\state → state { fire = Fire.update t state.fire })


addItem ∷ Item → GameState → GameState
addItem r s =
  s { resources = s.resources <> (List.singleton r) }


initFire ∷ Time → Time → GameState → GameState
initFire burnTime stokeCooldown s =
  s { fire = Fire.init burnTime 
      , actions = ActionSet.addAction (Action.fireAction stokeCooldown) s.actions
    }


updateActionCooldowns ∷ Time → GameState → GameState
updateActionCooldowns t s =
  s { actions = ActionSet.map (Action.updateCooldown t) s.actions }


activeItems ∷ GameState → List Item
activeItems s =
  List.filter (\r → Activatable.active r) s.resources

resourceActive ∷ String → GameState → Boolean
resourceActive name s =
  List.elem name (map (\r → Named.name r) (activeItems s))


getItemNamed ∷ String → GameState → Maybe Item
getItemNamed name state =
  List.filter (\(Item r) → r.name == name) state.resources
  |> List.head


applyToItem ∷ String → (Item → Item) → GameState → GameState
applyToItem name fn s =
  s { resources = map (\r → if (Named.name r) == name then fn r else r) s.resources }


resourceAmount ∷ String → GameState → Int
resourceAmount name s =
  getItemNamed name s
  |> map Item.getAmount
  |> Maybe.fromMaybe 0


addAction ∷ Action → GameState → GameState
addAction a s = s { actions = ActionSet.addAction a s.actions}


actionPerformed ∷ ActionName.Name → GameState → Boolean
actionPerformed a s = ActionSet.hasActionNamed a s.actionHistory


addActionToHistory ∷ Action → GameState → GameState
addActionToHistory a s = s { actionHistory = ActionSet.addAction a s.actionHistory }


clearActionHistory ∷ GameState → GameState
clearActionHistory s = s { actionHistory = ActionSet.clearActions }


milestoneReached ∷ String → GameState → Boolean
milestoneReached name s = Milestones.hasReached name s.milestones


setMilestoneReached ∷ String → GameState → GameState
setMilestoneReached name s =
  s { milestones = Milestones.setReached name s.gameTime s.milestones }


incrementMilestone ∷ String → GameState → GameState
incrementMilestone name s =
  s { milestones = Milestones.increment name s.gameTime s.milestones }


milestoneCounter ∷ String → GameState → Int
milestoneCounter name s = Milestones.counter name s.milestones


timeSince ∷ String → GameState → Maybe Time
timeSince name s = Milestones.timeSince name s.gameTime s.milestones


applyToAction ∷ ActionName.Name → (Action → Action) → GameState → GameState
applyToAction n f s =
  s { actions = ActionSet.applyToNamed n f s.actions }


applyEffect ∷ Effect → GameState → GameState
applyEffect e s =
  case e of
    Effect.NoEffect → s 

    Effect.ActivateResource name → 
      applyToItem name (Activatable.activate) s

    Effect.AddToResource name x → 
      addToItem name x s

    Effect.SubtractResource name x →
      applyToItem name (Item.subtract x) s

    Effect.SetMilestoneReached name → 
      setMilestoneReached name s

    Effect.IncrementMilestone name → 
      incrementMilestone name s

    Effect.ActivateAction name → 
      applyToAction name (Action.activate) s

    Effect.DeactivateAction name → 
      applyToAction name (Action.deactivate) s
    
    Effect.StokeFire →
      s { fire = Fire.stoke s.fire }
    
    Effect.GameOver →
      gameOver s

    -- Effect.Compound effects → 
    --   List.foldl applyEffect s effects

    -- Effect.Compound2 e1 e2 → 
    --   List.foldl applyEffect s [e1, e2]

    other → s

addToItem ∷ String → Int → GameState → GameState
addToItem name x s = 
  let 
    stateWithActiveResource = 
      if not (resourceActive name s) 
      then applyToItem name (Activatable.activate) s 
      else s
  in
    applyToItem
      name (Item.add x) stateWithActiveResource


gameOver ∷ GameState → GameState
gameOver s = s { gameOver = true }
