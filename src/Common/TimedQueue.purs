module Common.TimedQueue where

import Prelude (map, (+), (>=), (==))
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))

import Common.Annex ((|>))
import Common.Queue as Queue
import Common.Time (Time)


type TimedQueue a = 
  { queue ∷ Queue.Queue (QueueEntry a)
  , currentTime ∷ Time
  }


type QueueEntry a = 
  { item ∷ a
  , delay ∷ Time
  }


new ∷ ∀ a. TimedQueue a
new = { queue: Queue.new
      , currentTime: 0.0
      }


update ∷ ∀ a. Time → TimedQueue a → TimedQueue a
update timeElapsed timedQueue =
  timedQueue { currentTime = timedQueue.currentTime + timeElapsed }


enqueue ∷ ∀ a. a → Time → TimedQueue a → TimedQueue a
enqueue item delay timedQueue =
  timedQueue { queue = (Queue.enqueue { item: item, delay: delay } 
                                      timedQueue.queue) }


push ∷ ∀ a. a → Time → TimedQueue a → TimedQueue a
push item delay timedQueue =
  timedQueue
  { queue = (Queue.push { item: item, delay: delay } 
                        timedQueue.queue) 
  }


size ∷ ∀ a. TimedQueue a → Int
size timedQueue = (Queue.size timedQueue.queue)


nextDelay ∷ ∀ a. TimedQueue a → Maybe Time
nextDelay timedQueue =
  Queue.peek timedQueue.queue 
  |> map (\x → x.delay)


canDequeue ∷ ∀ a. TimedQueue a → Boolean
canDequeue timedQueue =
  nextDelay timedQueue
  |> map ((>=) timedQueue.currentTime)
  |> (==) (Just true)


dequeue ∷ ∀ a. TimedQueue a → Tuple (Maybe a) (TimedQueue a)
dequeue timedQueue =
  if (canDequeue timedQueue) then
    let 
      Tuple entry q = (Queue.dequeue timedQueue.queue)
    in
      Tuple (entry |> map (\x → x.item))
            (timedQueue { queue = q , currentTime = 0.0 })
  else
    Tuple Nothing timedQueue
