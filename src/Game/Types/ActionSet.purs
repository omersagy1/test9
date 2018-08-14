module Game.Types.ActionSet where

import Prelude ((==))

import Data.List (List)
import Data.Map as Map
import Data.Map (Map)
import Data.Maybe
import Data.Set (Set)

import Common.Annex ((|>))
import Common.Time (Time)
import Game.Types.Action as Action
import Game.Types.Action (Action)
import Game.Types.ActionName (Name(..))


type ActionSet = Map Name Action


init ∷ ActionSet
init = Map.empty


addAction ∷ Action → ActionSet → ActionSet
addAction a s = Map.insert a.name a s


clearActions ∷ ActionSet
clearActions = Map.empty


hasAction ∷ Action → ActionSet → Boolean
hasAction a s = hasActionNamed a.name s


hasActionNamed ∷ Name → ActionSet → Boolean
hasActionNamed n s = Map.member n s


getAction ∷ Name → ActionSet → Maybe Action
getAction n = Map.lookup n


activeActions ∷ ActionSet → List Action
activeActions s = Map.filter (\a → a.active) s
                  |> Map.values


update ∷ Time → ActionSet → ActionSet
update t s = map (Action.updateCooldown t) s


map ∷ (Action → Action) → ActionSet → ActionSet
map f s = map f s


filter ∷ (Action → Boolean) → ActionSet → ActionSet
filter pred s = Map.filter pred s


applyIfNamed ∷ Name → (Action → Action) → Action → Action
applyIfNamed name f a = if name == a.name then f a else a


applyToNamed ∷ Name → (Action → Action) → ActionSet → ActionSet
applyToNamed name f s = map (applyIfNamed name f) s


names ∷ ActionSet → Set Name
names s = Map.keys s


-- user-defined names only.
userDefinedNames ∷ ActionSet → Set Name
userDefinedNames s = filter (\a → case a.name of 
                                    UserDefined x → true
                                    other → false)
                            s
                     |> names
