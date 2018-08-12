module Test.Main where

import Prelude
import Effect (Effect)

import Test.Queue as Queue


main :: Effect Unit
main = do
  Queue.main