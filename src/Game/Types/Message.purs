module Game.Types.Message where

import Common.Time (Time)
import Game.Types.ActionName as ActionName


-- Messages to control the running of the game
data Message = TogglePause
               | ToggleFastForward
               | Restart
               | UpdateTime Time
               | MakeChoice String -- The prompt for the choice.
               | GameplayMessage ActionName.Name
