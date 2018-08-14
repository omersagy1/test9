module Game.Types.Item where


data Item = Item
  { name ∷ String
  , active ∷ Boolean
  , amount ∷ Amount
  }

data Amount = Single Boolean
              | Countable Int
              | Continuous Number

class Named a where
  name ∷ a → String

instance namedItem ∷ Named Item where
  name ∷ Item → String
  name (Item i) = i.name
