module Game.Types.GameState where

import Common.Time (Time)
import Game.Types.ActionSet (ActionSet)
import Game.Types.Item (Item)
import Game.Types.Fire (Fire)
import Game.Types.Milestones (Milestones)


type GameState =
  -- Time passed in the game so far.
  { gameTime ∷ Time
  , resources ∷ Array Item
  , fire ∷ Fire
  -- List of actions performed since the last update.
  -- Read by Condition to decide whether to Condition a
  -- StoryEvent.
  , actionHistory ∷ ActionSet
  , milestones ∷ Milestones
  , actions ∷ ActionSet
  , gameOver ∷ Boolean
  }
