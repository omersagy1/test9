module Item where

import Data.Map (Map)
import Data.Map as Map


class Named a where
  name :: a → String

type NameMap a = Map String a

init :: ∀ a. Named a ⇒ 
        NameMap a
init = Map.empty

insert :: ∀ a. Named a ⇒ a → NameMap a → NameMap a
insert named m = Map.insert (name named) named m

data Item = Item
  { name :: String
  , active :: Boolean
  , amount :: Amount
  }

instance namedItem :: Named Item where
  name :: Item → String
  name (Item i) = i.name

data Amount = Single Boolean
              | Countable Int
              | Continuous Number
