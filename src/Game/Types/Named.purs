module Game.Types.Named where


import Data.Map (Map)
import Data.Map as Map
import Prelude ((==))


class Named a where
  name ∷ a → String


hasName ∷ ∀ a. Named a ⇒ String → a → Boolean
hasName s named = (name named) == s


type NameSet a = Map String a


init ∷ ∀ a. Named a ⇒ NameSet a
init = Map.empty

insert ∷ ∀ a. Named a ⇒ a → NameSet a → NameSet a
insert x set = Map.insert (name x) x set
