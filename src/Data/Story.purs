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


data Builder a = Builder a Story

instance bShow ∷ Show a ⇒ Show (Builder a) where
  show ∷ Builder a → String
  show (Builder dum s) = "Builder: " <> (show s)

instance bFunctor ∷ Functor Builder where
  map ∷ ∀ a b. (a → b) → Builder a → Builder b
  map f (Builder dum s) = Builder (f dum) s

instance bApply ∷ Apply Builder where
  apply ∷ ∀ a b. Builder (a → b) → Builder a → Builder b
  apply (Builder f s1) (Builder dum s2) = (Builder (f dum) (s1 <> s2))

instance bApplicative ∷ Applicative Builder where
  pure ∷ ∀ a. a → Builder a
  pure dum = Builder dum mempty

instance sBind ∷ Bind Builder where
  bind ∷ ∀ a b. Builder a → (a → Builder b) → Builder b
  bind (Builder d1 s1) fn = 
    let
      (Builder d2 s2) = fn d1
    in
      (Builder d2 (s1 <> s2))
    
instance sMonad ∷ Monad Builder


dummy ∷ Builder Unit
dummy = pure unit

addLine ∷ String → Builder Unit
addLine l = Builder unit (Story [l])

q ∷ Builder Unit
q = do
  addLine "hello"
  addLine "world!"
