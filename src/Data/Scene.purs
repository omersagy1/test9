module Data.Scene where

import Prelude (discard)

import Common.Annex ((<|))
import Data.Keywords
import Game.Types.Story (Story)


story ∷ Story
story = begin do

  top "second" 
    onlyOnce
    never
    <| begin do
    ln "Welcome to the game!"
    ln "Another line for us to play with!"
    ln "Keep it going!"