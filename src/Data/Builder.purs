module Data.Builder where

import Prelude

import Game.Types.Story
import Game.Types.StoryEvent
import Game.Types.TopLevelEvent


data Construct = S Story
                 | TL TopLevelEvent
                 | E StoryEvent

instance semigroupConstruct ∷ Semigroup Construct where
  append ∷ Construct → Construct → Construct
  append (S s1) (S s2) = S (s1 <> s2)
  append (TL t1) (TL t2) = TL (t1 <> t2)
  append (E e1) (E e2) = E (e1 <> e2)
  append x y = x

instance monoidConstruct ∷ Monoid Construct where
  mempty ∷ Story
  mempty = Story []


data Builder a = Builder a Construct

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