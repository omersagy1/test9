module Script.Scene where

import Prelude (discard)

import Common.Annex ((<|))
import Game.Types.Effect (Effect(..))
import Game.Types.Story (Story)
import Script.Keywords ((#), prompt, begin, choices, cond, di, effect, ln, never, occursOnceWhen, restrict, resume, top, unconditionally)


story ∷ Story
story = begin do

  top "first" 
    occursOnceWhen never
    # do
    ln "Welcome to the game!"
    ln "Another line for us to play with!"
    ln "Keep it going!"
    restrict
    di "I am speaking directly now..."
    resume
    cond unconditionally # do
      ln "always show this!"
      ln "and this!"
    ln "Back to normal"
    effect <| AddToResource "wood" 1
  
  top "second"
    occursOnceWhen never
    # do
    ln "another event!"
    choices # do
      prompt "Run!" # do
        ln "You run away..."
      prompt "Stay" # do
        ln "Everything is fine..."
