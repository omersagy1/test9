module Data.Builder where

import Prelude (class Applicative, class Apply, class Bind, class Functor, class Monad, class Monoid, class Semigroup, class Show, mempty, show, (<>))

import Data.Buildable
import Game.Types.Story (Story(..))
import Game.Types.StoryEvent


data Construct = S Story
                 | E StoryEvent

getStory ∷ Construct → Story 
getStory (S s) = s
getStory (E e) = default

getEvent ∷ Construct → StoryEvent
getEvent (E e) = e
getEvent (S s) = default


instance buildableConstruct ∷ Buildable Construct where
  combine ∷ Construct → Construct → Construct
  combine (S s1) (S s2) = S (combine s1 s2)
  combine (E e1) (E e2) = E (combine e1 e2)
  combine x y = x

  default ∷ Construct
  default = S default


instance showConstruct ∷ Show Construct where
  show ∷ Construct → String
  show (S s) = (show s)
  show (E e) = (show e)


data Builder a = Builder a Construct

getConstruct ∷ ∀ a. Builder a → Construct
getConstruct (Builder dum c) = c


instance bShow ∷ Show a ⇒ Show (Builder a) where
  show ∷ Builder a → String
  show (Builder dum s) = "Builder: \n" <> (show s)

instance bFunctor ∷ Functor Builder where
  map ∷ ∀ a b. (a → b) → Builder a → Builder b
  map f (Builder dum s) = Builder (f dum) s

instance bApply ∷ Apply Builder where
  apply ∷ ∀ a b. Builder (a → b) → Builder a → Builder b
  apply (Builder f s1) (Builder dum s2) = (Builder (f dum) (combine s1 s2))

instance bApplicative ∷ Applicative Builder where
  pure ∷ ∀ a. a → Builder a
  pure dum = Builder dum default

instance sBind ∷ Bind Builder where
  bind ∷ ∀ a b. Builder a → (a → Builder b) → Builder b
  bind (Builder d1 s1) fn = 
    let
      (Builder d2 s2) = fn d1
    in
      (Builder d2 (s1 `combine` s2))
    
instance sMonad ∷ Monad Builder
