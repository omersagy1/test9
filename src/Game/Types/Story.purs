module Data.Story where

import Prelude


data Story = Story (Array String)

instance semigroupStory ∷ Semigroup Story where
  append ∷ Story → Story → Story
  append (Story s1) (Story s2) = (Story (s1 <> s2))

instance showStory ∷ Show Story where
  show ∷ Story → String
  show (Story s) = "Story: " <> (show s)

instance monoidStory ∷ Monoid Story where
  mempty ∷ Story
  mempty = Story []
