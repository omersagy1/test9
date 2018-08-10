module Game.Types.Effect where

import Prelude (class Show)

import Game.Types.ActionName (Name)


data Effect = NoEffect
              | ActivateResource String
              | AddToResource String Int
              | AddToResourceRand String Int Int
              | SubtractResource String Int
              | SetResourceAmount String Int
              | SetMilestoneReached String
              | IncrementMilestone String
              | ActivateAction Name
              | DeactivateAction Name
              | StokeFireEff
              | GameOver
              | Compound (Array Effect)
              | Compound2 Effect Effect


instance showEffect ∷ Show Effect where
  show ∷ Effect → String
  show e = "(some effect)"
