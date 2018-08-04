module Main where

import Button as B
import Data.Function (($))
import Data.Functor (void)
import Data.Maybe (Maybe(..))
import Data.Maybe as Maybe
import Effect (Effect)
import Graphics.Canvas (fillRect, getCanvasElementById, getContext2D, setFillStyle)
import Halogen.Aff (awaitLoad, selectElement)
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Partial.Unsafe (unsafePartial)
import Prelude (bind, Unit, unit, discard)
import Web.DOM.ParentNode (QuerySelector(..))


manualEntryPoint :: Effect Unit
manualEntryPoint = void $ unsafePartial do 
  Just canvas <- getCanvasElementById "canvas"
  ctx <- getContext2D canvas
  _ <- setFillStyle ctx "#0000FF"
  fillRect ctx { x: 0.0 , y: 0.0 , width: 100.0 , height: 100.0 }
  halogenLoop
  fillRect ctx { x: 100.0 , y: 0.0 , width: 100.0 , height: 100.0 }


halogenLoop :: Effect Unit
halogenLoop = HA.runHalogenAff do
  awaitLoad
  halogenDiv <- selectElement (QuerySelector "#halogen")
  body <- HA.awaitBody
  runUI B.component unit (Maybe.fromMaybe body halogenDiv)
