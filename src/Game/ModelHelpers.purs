module Game.ModelHelpers where

import Data.Maybe

import Common.TimedQueue as TimedQueue
import Data.List (List(..))
import Data.List as List
import Game.Init as Init
import Game.StateMutators as StateMutators
import Game.Types.Effect (Effect)
import Game.Types.GameState (GameState)
import Game.Types.Model (Model)
import Game.Types.StoryEvent (Choice)
import Prelude (not, (==), (||))


storyPaused ∷ Model → Boolean
storyPaused m =
  hardPaused m || softPaused m


gameplayPaused ∷ Model → Boolean
gameplayPaused m =
  storyPaused m || inInteractionMode m


hardPaused ∷ Model → Boolean
hardPaused m = m.paused


softPaused ∷ Model → Boolean
softPaused = waitingOnChoice


waitingOnChoice ∷ Model → Boolean
waitingOnChoice m = not (List.null m.activeChoices)


inInteractionMode ∷ Model → Boolean
inInteractionMode m = m.interactionMode


isGameOver ∷ Model → Boolean
isGameOver m = m.gameState.gameOver


togglePause ∷ Model → Model
togglePause m = m { paused = not m.paused }


toggleFastForward ∷ Model → Model
toggleFastForward m = m { fastForward = not m.fastForward }


restart ∷ Boolean → Model
restart paused = 
  let
    fresh = Init.initialModel
  in
    fresh { paused = paused }


clearActionHistory ∷ Model → Model
clearActionHistory m = m { gameState = StateMutators.clearActionHistory m.gameState }


displayChoices ∷ List Choice → Model → Model
displayChoices choices m =
  m { activeChoices = choices }


applyEffect ∷ Effect → Model → Model
applyEffect effect model =
  model { gameState = StateMutators.applyEffect effect model.gameState }


setGameState ∷ GameState → Model → Model
setGameState s m = m { gameState = s }


hasActiveChoices ∷ Model → Boolean
hasActiveChoices m =
  not (List.null m.activeChoices)


clearActiveChoices ∷ Model → Model
clearActiveChoices m =
  m { activeChoices = Nil }


getActiveChoiceWithPrompt ∷ String → Model → Maybe Choice
getActiveChoiceWithPrompt prompt model =
  case model.activeChoices of
    Nil → Nothing
    choices → List.find (\c → c.prompt == prompt) choices


eventQueueEmpty ∷ Model → Boolean
eventQueueEmpty model = (TimedQueue.size model.eventQueue) == 0
