module Game.Types.Story where

import Prelude

import Game.Types.TopLevelEvent (TopLevelEvent)


data Story = Story (Array TopLevelEvent)

new ∷ Story
new = mempty

instance showStory ∷ Show Story where
  show ∷ Story → String
  show (Story s) = "Story: \n" <> (show s)

instance semigroupStory ∷ Semigroup Story where
  append ∷ Story → Story → Story
  append (Story s1) (Story s2) = (Story (s1 <> s2))

instance monoidStory ∷ Monoid Story where
  mempty ∷ Story
  mempty = Story []
