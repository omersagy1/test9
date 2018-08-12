module Common.NumCompat where

import Prelude as P
import Data.Int

class NumberCompatible a where
  makeNumber :: a -> Number


instance compatInt :: NumberCompatible Int where
  makeNumber :: Int -> Number
  makeNumber = toNumber


instance compatNum :: NumberCompatible Number where
  makeNumber :: Number -> Number
  makeNumber = P.identity


mult :: forall a b. NumberCompatible a => NumberCompatible b => a -> b -> Number
mult x y = (makeNumber x) `P.mul` (makeNumber y)
infixl 7 mult as *