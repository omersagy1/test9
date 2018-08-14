module Game.Types.ActionName where

import Prelude


data Name = StokeFire 
            | UserDefined String


instance eqName ∷ Eq Name where
  eq ∷ Name → Name → Boolean
  eq StokeFire StokeFire = true
  eq (UserDefined x) (UserDefined y) = (eq x y)
  eq _ _ = false


instance ordName ∷ Ord Name where
  compare ∷ Name → Name → Ordering
  compare StokeFire StokeFire = EQ
  compare StokeFire _ = GT
  compare _ StokeFire = LT
  compare (UserDefined x) (UserDefined y) = (compare x y)
