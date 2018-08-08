module Data.Builder where

import Prelude (class Applicative, class Apply, class Bind, class Functor, class Monad, class Show, show, (<>))

import Data.Buildable (class Buildable, combine, default)


data Builder s a = BD s a

getConstruct ∷ ∀ s a. Builder s a → s
getConstruct (BD built dum) = built

instance bShow ∷ (Show s, Show a) ⇒ Show (Builder s a) where
  show ∷ Builder s a → String
  show (BD s a) = "Builder: \n" <> (show s)

instance bFunctor ∷ Buildable s ⇒ Functor (Builder s) where
  map f (BD s dum) = BD s (f dum)

instance bApply ∷ Buildable s ⇒ Apply (Builder s) where
  apply ∷ ∀ a b. Builder s (a → b) → Builder s a → Builder s b
  apply (BD s1 f) (BD s2 dum) = (BD (combine s1 s2) (f dum))

instance bApplicative ∷ Buildable s ⇒ Applicative (Builder s) where
  pure ∷ ∀ a. a → Builder s a
  pure dum = BD default dum

instance sBind ∷ Buildable s ⇒ Bind (Builder s) where
  bind ∷ ∀ a b. Builder s a → (a → Builder s b) → Builder s b
  bind (BD s1 d1) fn = 
    let
      (BD s2 d2) = fn d1
    in
      (BD (s1 `combine` s2) d2)
    
instance sMonad ∷ Buildable s ⇒ Monad (Builder s)
