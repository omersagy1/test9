module Test.Main where

import Prelude
import Effect (Effect)

import Test.Queue as Queue
import Test.TimedQueue as TimedQueue


main :: Effect Unit
main = do
  Queue.suite
  TimedQueue.suite