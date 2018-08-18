module Game.UpdateTime where

import Prelude (identity, map, not, (&&), (*), (<>), (>>>))
import Data.List (List(..), (:))
import Data.List as List
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))

import Common.Annex (filterMutate, maybePerform, (|>))
import Common.Time (Time)
import Common.TimedQueue as TimedQueue
import Game.Constants as Constants
import Game.ModelHelpers as ModelHelpers
import Game.StateMutators as StateMutators
import Game.Types.Condition (Condition)
import Game.RunCondition as RunCondition
import Game.Types.GameState (GameState)
import Game.Types.Model (Model)
import Game.Printer as Printer
import Game.Types.Story (Story)
import Game.Types.Story as Story
import Game.Types.StoryEvent (AtomicEvent(..), Choice, ConditionedEvent(..), StoryEvent(..)) 


updateGame ∷ Time → Model → Model
updateGame t m =
  let
    timePassed = 
        if m.fastForward 
        then t * Constants.fastForwardFactor        
        else t
  in
    m
    |> updateGameTime timePassed
    |> Printer.update timePassed
    |> triggerStoryEvents
    |> (if not (Printer.isPrinting m) then processEventQueue else identity)
    |> ModelHelpers.clearActionHistory 


updateGameTime ∷ Time → Model → Model
updateGameTime timePassed m =
  let
    newState = if m.interactionMode then m.gameState
               else StateMutators.update timePassed m.gameState
  in
    m { gameState = newState
      , eventQueue = TimedQueue.update timePassed m.eventQueue 
      }


triggerStoryEvents ∷ Model → Model
triggerStoryEvents m =
  let
    { triggeredEvents: es
    , remainingStory: s
    , updatedState: gameState
    } = 
      triggeredStoryEvents m.gameState m.story
  in
    m { gameState = gameState
      , story = s
      }
    |> enqueueStoryEvents es


enqueueStoryEvents ∷ List StoryEvent → Model → Model
enqueueStoryEvents events model =
  model |>
  case events of
    Nil → identity
    event:rest → enqueueStoryEvent event


enqueueStoryEvent ∷ StoryEvent → Model → Model
enqueueStoryEvent event m =
  let
    delay = if ModelHelpers.eventQueueEmpty m then
              Constants.firstMessageDelay
            else 
              Constants.firstMessageNonEmptyQueueDelay
  in
    enqueueStoryEventWithDelay event delay m


enqueueStoryEventWithDelay ∷ StoryEvent → Time → Model → Model
enqueueStoryEventWithDelay event delay m =
      m { eventQueue = TimedQueue.enqueue 
                            event 
                            delay
                            m.eventQueue 
        }


pushStoryEvent ∷ StoryEvent → Model → Model
pushStoryEvent event m =
  pushStoryEventWithDelay event (getDelay event) m


pushStoryEventWithDelay ∷ StoryEvent → Time → Model → Model
pushStoryEventWithDelay event delay m =
      m { eventQueue = TimedQueue.push 
                            event 
                            delay
                            m.eventQueue 
        }


getDelay ∷ StoryEvent → Time
getDelay event =
  case event of
    Atomic (Narration _) → Constants.defaultMessageDelay
    Atomic (Dialogue _) → Constants.defaultMessageDelay
    Atomic (Effectful _) → Constants.mutatorDelay
    Atomic (Goto _) → 0.0
    PlayerChoice _ → Constants.choiceButtonsDelay
    other → 0.0


processEventQueue ∷ Model → Model
processEventQueue m = 
  let 
    Tuple e newModel = dequeueEvent m
  in
    case e of
      Nothing → newModel
      Just event → playStoryEvent event newModel


dequeueEvent ∷ Model → Tuple (Maybe StoryEvent) Model
dequeueEvent m =
  let 
    Tuple e queue = TimedQueue.dequeue m.eventQueue
  in
    Tuple e (m { eventQueue = queue })


playStoryEvent ∷ StoryEvent → Model → Model
playStoryEvent event model = 
  model |>
  case event of
    Atomic e → 
      playAtomicEvent e
    Sequenced events → 
      playSequencedEvent events
    Conditioned (ConditionedEvent c e) → 
      playConditionedEvent c e
    PlayerChoice choices → 
      playChoice choices
    Cases cases →
      playCasesEvent cases
    other →
      identity


playAtomicEvent ∷ AtomicEvent → Model → Model
playAtomicEvent e model =
  model |>
  case e of
    Narration ln → 
      displayText ln
    
    Dialogue ln →
      displayDialogue ln

    Effectful eff →
      ModelHelpers.applyEffect eff

    Goto ref →
      (maybePerform playStoryEvent) 
        (Story.getEventByName ref model.story 
         |> map (\x → x.event))
    
    StartInteraction →
      (\m → m { interactionMode = true })

    EndInteraction →
      (\m → m { interactionMode = false })


playSequencedEvent ∷ List StoryEvent → Model → Model
playSequencedEvent events model =
  model |>
  case events of
    Nil → identity
    first : rest →
      pushStoryEvents (List.reverse rest)
      >>> pushStoryEventWithDelay first Constants.postChoiceMessageDelay


pushStoryEvents ∷ List StoryEvent → Model → Model
pushStoryEvents events model =
  model |>
  case events of
    Nil → identity
    first:rest → pushStoryEvent first >>> pushStoryEvents rest


playConditionedEvent ∷ Condition → StoryEvent → Model → Model
playConditionedEvent c e m =
  let
    Tuple success state = RunCondition.condition c m.gameState
  in
    ModelHelpers.setGameState state m |>
    if success then
      (pushStoryEvent e)
    else identity


playCasesEvent ∷ List ConditionedEvent → Model → Model
playCasesEvent events m =
  case events of
    Nil → m
    (ConditionedEvent condition event):rest →
      let 
        Tuple success state = RunCondition.condition condition m.gameState
      in
        ModelHelpers.setGameState state m |>
        if success then
          pushStoryEvent event
        else
          playCasesEvent rest


playChoice ∷ List Choice → Model → Model
playChoice choices m =
  let
    Tuple choicesToDisplay newState = 
      filterMutate (\choice gameState → 
                      RunCondition.condition choice.condition gameState) 
                   choices 
                   m.gameState
  in
    ModelHelpers.setGameState newState m
    |> ModelHelpers.displayChoices choicesToDisplay


displayText ∷ String → Model → Model
displayText text model =
  Printer.setActiveMessage text model


displayDialogue ∷ String → Model → Model
displayDialogue text model =
  displayText ("\"" <> text <> "\"") model


type TriggeredEventsReturn =
  { triggeredEvents ∷ List StoryEvent
  , remainingStory ∷ Story
  , updatedState ∷ GameState
  }

-- Returns (triggered events, remaining story, gamestate)
triggeredStoryEvents ∷ GameState → Story → TriggeredEventsReturn
triggeredStoryEvents state story = triggeredHelper state story Nil Nil

triggeredHelper ∷ GameState → Story → List StoryEvent → Story → TriggeredEventsReturn
triggeredHelper state toscan triggered remaining =
  case toscan of
    Nil → { triggeredEvents: triggered
         , remainingStory: remaining
         , updatedState: state
         }
    first:rest →
      let
        Tuple eventTriggered newState = 
          (RunCondition.condition(first.trigger) state)
        triggered2 = if eventTriggered then 
                       (first.event):triggered 
                     else triggered
        shouldRemove = eventTriggered && not (first.reoccurring)
        remaining2 = if shouldRemove then remaining else first:remaining
      in
        triggeredHelper newState rest triggered2 remaining2
