module Game.Types.Message where

import Common.Time (Time)
import Game.Types.ActionName as ActionName
import Game.Types.StoryEvent (Choice)


-- Messages to control the running of the game
data Message = TogglePause
               | ToggleFastForward
               | Restart
               | UpdateTime Time
               | MakeChoice Choice
               | GameplayMessage ActionName.Name
               | StartTime Time
