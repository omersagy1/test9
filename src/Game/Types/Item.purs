module Game.Types.Item where

import Game.Types.Activatable (class Activatable)
import Game.Types.Named (class Named)
import Prelude ((+), (-))


data Item = Item
  { name ∷ String
  , active ∷ Boolean
  , amount ∷ Amount
  }


data Amount = Single Boolean
              | Countable Int
              | Continuous Number


instance namedItem ∷ Named Item where
  name ∷ Item → String
  name (Item i) = i.name


instance activatableItem ∷ Activatable Item where

  activate ∷ Item → Item
  activate (Item i) = Item (i { active = true })

  deactivate ∷ Item → Item
  deactivate (Item i) = Item (i { active = false })

  active ∷ Item → Boolean
  active (Item i) = i.active


getAmount ∷ Item → Int
getAmount (Item item) =
  case item.amount of
    Countable v → v
    other → 0

add ∷ Int → Item → Item
add x (Item item) =
  case item.amount of
    Countable v → Item (item { amount = Countable (v + x) })
    other → Item item

subtract ∷ Int → Item → Item
subtract x (Item item) =
  case item.amount of
    Countable v → Item (item { amount = Countable (v - x) })
    other → Item item
