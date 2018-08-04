module Main where

import Prelude (bind, Unit, unit)

import Control.Applicative (pure)
import Data.Function (($))
import Data.Functor (void)
import Data.Maybe
import Data.Map (Map)
import Data.Map as Map
import Effect (Effect)
import Graphics.Canvas (getCanvasElementById, getContext2D)
import Partial.Unsafe (unsafePartial)


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
main = void $ unsafePartial do 
  Just canvas <- getCanvasElementById "canvas"
  ctx <- getContext2D canvas
  pure unit

something :: Int
something = 5

x :: Thing
x = A3 { a: 10, b: "hello world" }
