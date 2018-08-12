module TimedQueueTest where

import Prelude (Unit, discard, (==))
import Data.Maybe (Maybe(..))
import Data.Tuple (fst)
import Effect (Effect)
import Effect.Console (log)
import Test.Assert (assert)

import Common.Annex ((|>), ignoreResult)
import Common.TimedQueue
import Common.Time (seconds)


suite :: Effect Unit
suite = do
  enq1
  enqMult
  delay
  deq
  noDeq
  deqOne
  delayOne
  deqEntire
  pushDeq

enq1 :: Effect Unit
enq1 = do
  log "TIMED QUEUE TESTS"
  log "enqueue one item"
  let 
    tq = new |> (enqueue "a" (seconds 3))
  assert (1 == (size tq))

enqMult :: Effect Unit
enqMult = do
  log "enqueue multiple items"
  let 
    tq = new 
         |> (enqueue "a" (seconds 3))
         |> (enqueue "b" (seconds 2))
         |> (enqueue "c" (seconds 5))
  assert (3 == (size tq))

delay :: Effect Unit
delay = do
  log "get the next delay"
  let 
    tq = new
         |> (enqueue "a" (seconds 2))
         |> (enqueue "b" (seconds 5))
  assert ((Just (seconds 2)) == (nextDelay tq))

deq :: Effect Unit
deq = do
  log "can dequeue"
  let 
    tq = new
         |> (enqueue "a" (seconds 2))
         |> (enqueue "b" (seconds 5))
         |> (update (seconds 3))
  assert (true == (canDequeue tq))

noDeq :: Effect Unit
noDeq = do
  log "can't dequeue"
  let 
    tq = new
      |> (enqueue "a" (seconds 3))
      |> (enqueue "b" (seconds 5))
      |> (update (seconds 2))
  assert (false == (canDequeue tq))

deqOne :: Effect Unit
deqOne = do
  log "dequeue one element"
  let 
    tq = new
      |> (enqueue "a" (seconds 3))
      |> (enqueue "b" (seconds 5))
      |> (update (seconds 4))
    e1 = (dequeue tq) |> fst
  assert ((Just "a") == e1)

delayOne :: Effect Unit
delayOne = do
  log "delay only counts for one element"
  let 
    tq = new
      |> (enqueue "a" (seconds 3))
      |> (enqueue "b" (seconds 5))
      |> (update (seconds 10))
      |> (ignoreResult dequeue)
  assert (Nothing == (dequeue tq |> fst))

deqEntire :: Effect Unit
deqEntire = do
  log "dequeue entire queue"
  let 
    tq = new
      |> (enqueue "a" (seconds 3))
      |> (enqueue "b" (seconds 5))
      |> (enqueue "c" (seconds 2))
      |> (update (seconds 4))
      |> (ignoreResult dequeue)
      |> (update (seconds 5))
      |> (ignoreResult dequeue)
      |> (update (seconds 3))
      |> (enqueue "d" (seconds 8))
      |> (ignoreResult dequeue)
      |> (update (seconds 9))
      |> (ignoreResult dequeue)
  assert (0 == (size tq))

pushDeq :: Effect Unit
pushDeq = do
  log "dequeue after pushing"
  let 
    tq = new
      |> (push "a" (seconds 3))
      |> (push "b" (seconds 5))
      |> (update (seconds 6))
    e1 = (dequeue tq) |> fst
  assert ((Just "b") == e1)
 