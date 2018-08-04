module Main where

import Data.List
import Data.Map (Map)
import Data.Map as Map
import Effect (Effect)
import Effect.Console (log)
import Prelude (Unit)


class Named a where
  name :: a -> String

type NameMap a = Map String a

init :: ∀ a. Named a => 
        NameMap a
init = Map.empty

insert :: ∀ a. Named a => 
          a -> NameMap a -> NameMap a
insert named m = Map.insert (name named) named m

data Item = Item
  { name :: String
  , active :: Boolean
  , amount :: Amount
  }

instance namedItem :: Named Item where
  name :: Item -> String
  name (Item i) = i.name

data Amount = Single Boolean
              | Countable Int
              | Continuous Number

data Thing = A1 
             | A2
             | A3 { a :: Int, b :: String }

main :: Effect Unit
main = do
  log "Hello sailor!"

something :: Int
something = 5

x :: Thing
x = A3 { a: 10, b: "hello world" }
