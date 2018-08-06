module Game.Types.Effect where

import Data.List
import Prelude

import Game.Types.ActionName


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
              | Compound (List Effect)
              | Compound2 Effect Effect