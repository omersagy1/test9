module Script.Scene where

import Game.Types.Effect (Effect(..))
import Game.Types.Story (Story)
import Prelude (discard, ($))
import Script.Keywords (gameTimePassed, seconds, weighted, unweighted, rand, cases, when, (#), prompt, promptIf, begin, choices, cond, di, effect, ln, never, occursOnceWhen, restrict, resume, top, unconditionally)


story ∷ Story
story = begin do

  top "first" 
    occursOnceWhen never # do
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
    effect $ AddToResource "wood" 1
  
  top "second"
    occursOnceWhen (gameTimePassed $ seconds 60) # do
    ln "another event!"
    choices # do
      prompt "Run!" 
        # do
        ln "You run away..."
      prompt "Stay" 
        # do
        ln "Everything is fine..."
      promptIf unconditionally "Whistle" 
        # do
        ln "Sounds nice!"
        cases # do
          when never # do
            ln "first line here..."
            ln "second line here..."
          when unconditionally # do
            ln "another possiblity..."
        rand # do
          unweighted # do 
            ln "randchoice 1"
          unweighted # do 
            ln "randchoice 2"
            ln "doubling up!"
          weighted 3 # do 
            ln "randchoice 3"
