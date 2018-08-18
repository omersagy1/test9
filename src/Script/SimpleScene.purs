module Script.SimpleScene where

import Script.Keywords

import Game.Types.Story (Story)
import Prelude (discard)


story ∷ Story
story = begin do
  top occursOnceWhen unconditionally # do
    ln "First line"
    ln "Second line"
    ln "..."
    di "speaking!"
