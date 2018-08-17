module Game.Types.Activatable where


class Activatable a where
  activate ∷ a → a
  deactivate ∷ a → a
  active ∷ a → Boolean
