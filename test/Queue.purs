module Test.Queue where

import Prelude (Unit, discard, (==))
import Data.Maybe (Maybe(..))
import Data.Tuple (fst)
import Effect (Effect)
import Effect.Console (log)
import Test.Assert (assert)

import Common.Annex ((|>), ignoreResult)
import Common.Queue (dequeue, enqueue, new, size, push, peek)


main :: Effect Unit
main = do
  oneDequeue
  threeEl
  dqEntire
  mult
  pkHead
  alt
  pushFront


oneDequeue :: Effect Unit
oneDequeue = do
  log "one one element dequeue"
  let 
    q = new
        |> (enqueue 9)
        |> (enqueue 5)
        |> (enqueue 2)
    e1 = dequeue q |> fst
  assert ((Just 9) == e1)


threeEl :: Effect Unit
threeEl = do
  log "size of three-element queue"
  let 
    q = new
     |> (enqueue 3)
     |> (enqueue 5)
     |> (enqueue 2)
  assert (3 == (size q))


dqEntire :: Effect Unit
dqEntire = do
  log "dequeue entire queue"
  let 
    q = new
     |> (enqueue 9)
     |> (enqueue 5)
     |> (enqueue 2)
     |> (ignoreResult dequeue)
     |> (ignoreResult dequeue)
     |> (ignoreResult dequeue)
     |> (enqueue 12)
  assert (1 == (size q))

mult :: Effect Unit
mult = do
  log "multiple dequeues"
  let q = new
          |> (enqueue 99)
          |> (enqueue 2)
          |> (enqueue 5)
          |> (ignoreResult dequeue)
      e1 = dequeue q |> fst
  assert ((Just 2) == e1)

pkHead :: Effect Unit
pkHead = do
  log "peek a queue returns the right head"
  let q = new
          |> (enqueue 2)
          |> (enqueue 8)
      e1 = peek q
  assert ((Just 2) == e1)

alt :: Effect Unit
alt = do
  log "alternate enqueue and dequeue"
  let q = new
          |> (enqueue 1)
          |> (enqueue 2)
          |> (ignoreResult dequeue)
          |> (enqueue 3)
          |> (ignoreResult dequeue)
          |> (ignoreResult dequeue)
          |> (enqueue 4)
      e1 = dequeue q |> fst
  assert ((Just 4) == e1)

pushFront :: Effect Unit
pushFront = do
  log "push to front of queue"
  let q = new
          |> (enqueue 1)
          |> (enqueue 2)
          |> (ignoreResult dequeue)
          |> (enqueue 3)
          |> (ignoreResult dequeue)
          |> (ignoreResult dequeue)
          |> (enqueue 4)
          |> (push 0)
          |> (push 6)
          |> (push 7)
          |> (ignoreResult dequeue)
      e1 = dequeue q |> fst
  assert ((Just 6) == e1)