module Main where

import Data.Function (($))
import Data.Functor (void)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Graphics.Canvas (fillRect, getCanvasElementById, getContext2D, setFillStyle)
import Partial.Unsafe (unsafePartial)
import Prelude (bind, Unit, unit, discard)

import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)

import Button as B


main :: Effect Unit
main = void $ unsafePartial do 
  Just canvas <- getCanvasElementById "canvas"
  ctx <- getContext2D canvas
  _ <- setFillStyle ctx "#0000FF"
  fillRect ctx { x: 0.0 , y: 0.0 , width: 100.0 , height: 100.0 }
  hal

hal :: Effect Unit
hal = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI B.component unit body
