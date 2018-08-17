module Game.Types.Model where

import Data.List (List)
import Data.Maybe (Maybe)

import Common.Animation (Animation)
import Common.Time (Time)
import Common.TimedQueue (TimedQueue)
import Game.Types.GameState (GameState)
import Game.Types.Story (Story)
import Game.Types.StoryEvent (Choice, StoryEvent)


type Model = 

  -- State of the game on a semantic level; i.e.
  -- gameState only contains things relevant to
  -- the conceptual understanding of the game, not
  -- the state of the machinery.
  { gameState ∷ GameState

  , initialized ∷ Boolean
  
  , timeLastFrame ∷ Maybe Time

  , gameTimePassed ∷ Number

  -- Messages to be displayed on-screen.
  , messageHistory ∷ List String 

  -- Events waiting to be executed.
  , eventQueue ∷ TimedQueue StoryEvent

  -- All story events that could be Conditioned.
  , story ∷ Story

  -- Whether the game is sped up.
  , fastForward ∷ Boolean

  -- The choice the player must make to continue the game.
  , activeChoices ∷ List Choice

  , activeScrollingMessage ∷ Maybe ScrollingMessage

  -- Whether the game receives update time events.
  , paused ∷ Boolean

  -- In 'interaction' mode normal gameplay actions can't
  -- be taken. Only narration and choices can proceed.
  , interactionMode ∷ Boolean

  }


-- This is an animated message that progresses one
-- character at a time.
type ScrollingMessage =
  { fullText ∷ String
  , animation ∷ Animation
  }
