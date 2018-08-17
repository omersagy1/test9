module Game.UpdateTime where

import Common.Time (Time)

import Common.Annex
import Common.TimedQueue as TimedQueue

import Game.Constants as Constants
import Game.Types.Condition (Condition)
import Game.RunCondition as RunCondition
import Game.Types.GameState (GameState)
import Game.Types.Model (Model)
import Game.Printer as Printer
import Game.Types.Story as Story
import Game.Types.StoryEvent 


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
    |> Model.clearActionHistory 


updateGameTime ∷ Time → Model → Model
updateGameTime timePassed m =
  let
    newState = if m.interactionMode then m.gameState
               else GameState.update timePassed m.gameState
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
      , story = story
      }
    |> enqueueStoryEvents triggeredEvents


enqueueStoryEvents ∷ List StoryEvent → Model → Model
enqueueStoryEvents events model =
  model |>
  case events of
    [] → identity
    event:rest → enqueueStoryEvent event


enqueueStoryEvent ∷ StoryEvent → Model → Model
enqueueStoryEvent event m =
  let
    delay = if Model.eventQueueEmpty m then
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
    Atomic (Goto _) → 0
    PlayerChoice _ → Constants.choiceButtonsDelay
    other → 0


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
    Random options →
      playRandomEvent options
    Cases cases →
      playCasesEvent cases


playAtomicEvent ∷ AtomicEvent → Model → Model
playAtomicEvent e model =
  model |>
  case e of
    Narration ln → 
      displayText ln
    
    Dialogue ln →
      displayDialogue ln

    Effectful eff →
      Model.applyEffect eff

    Goto ref →
      (maybePerform playStoryEvent) 
        (Story.getEventByName ref model.story 
         |> Maybe.map StoryEvent.getEvent)
    
    StartInteraction →
      (\model → model { interactionMode = True })

    EndInteraction →
      (\model → model { interactionMode = False })


playSequencedEvent ∷ List StoryEvent → Model → Model
playSequencedEvent events model =
  model |>
  case events of
    [] → identity
    first : rest →
      pushStoryEvents (List.reverse rest)
      >> pushStoryEventWithDelay first Constants.postChoiceMessageDelay


pushStoryEvents ∷ List StoryEvent → Model → Model
pushStoryEvents events model =
  model |>
  case events of
    [] → identity
    first:rest → pushStoryEvent first >> pushStoryEvents rest


playConditionedEvent ∷ Condition → StoryEvent → Model → Model
playConditionedEvent c e m =
  let
    Tuple success state = ConditionFns.condition c m.gameState
  in
    Model.setGameState state m |>
    if success then
      (pushStoryEvent e)
    else identity


playRandomEvent ∷ List StoryEvent → Model → Model
playRandomEvent events m =
  Model.choose events m
  |> (\(Tuple event model) → (maybePerform pushStoryEvent event model))


playCasesEvent ∷ List ConditionedEvent → Model → Model
playCasesEvent events m =
  case events of
    [] → m
    (ConditionedEvent condition event):rest →
      let 
        Tuple success state = ConditionFns.condition condition m.gameState
      in
        Model.setGameState state m |>
        if success then
          pushStoryEvent event
        else
          playCasesEvent rest


playChoice ∷ List Choice → Model → Model
playChoice choices m =
  let
    Tuple choicesToDisplay newState = 
      filterMutate (\choice gameState → 
                      ConditionFns.condition choice.condition gameState) 
                   choices 
                   m.gameState
  in
    Model.setGameState newState m
    |> Model.displayChoices choicesToDisplay


displayText ∷ String → Model → Model
displayText text model =
  Printer.setActiveMessage text model


displayDialogue ∷ String → Model → Model
displayDialogue text model =
  displayText ("\"" ++ text ++ "\"") model


type TriggeredEventsReturn =
  { triggeredEvents ∷ List StoryEvent
  , remainingStory ∷ Story
  , updatedState ∷ GameState
  }

-- Returns (triggered events, remaining story, gamestate)
triggeredStoryEvents ∷ GameState → Story → TriggeredEventsReturn
triggeredStoryEvents state story = triggeredHelper state story [] []

triggeredHelper ∷ GameState → Story → List StoryEvent → Story → TriggeredEventsReturn
triggeredHelper state toscan triggered remaining =
  case toscan of
    [] → { triggeredEvents: triggered
          , remainingStory: remaining
          , updatedState: state
          }
    first:rest →
      let
        Tuple eventTriggered newState = 
          (ConditionFns.condition(StoryEvent.getTrigger first) state)
        triggered2 = if eventTriggered then 
                       (StoryEvent.getEvent first)∷triggered 
                     else triggered
        shouldRemove = eventTriggered && not (StoryEvent.isReoccurring first)
        remaining2 = if shouldRemove then remaining else first∷remaining
      in
        triggeredHelper newState rest triggered2 remaining2
