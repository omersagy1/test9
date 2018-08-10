module Script.Scene where

import Prelude (discard)

import Common.Annex ((<|))
import Game.Types.Story (Story)
import Game.Types.Effect
import Script.Keywords


story ∷ Story
story = begin do

  top "second" 
    occursOnceWhen never
    <| begin do
    ln "Welcome to the game!"
    ln "Another line for us to play with!"
    ln "Keep it going!"
    restrict
    di "I am speaking directly now..."
    resume
    cond unconditionally <| begin do
      ln "always show this!"
      ln "and this!"
    ln "Back to normal"
    effect <| AddToResource "wood" 1
