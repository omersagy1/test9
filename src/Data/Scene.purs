module Data.Scene where

import Common.Annex ((<|), (|>))
import Data.Buildable (class Buildable)
import Game.Types.Condition (Condition(..), PureCondition(..))

import Data.Builder (Builder(..), getConstruct)
import Game.Types.Story (Story(..))
import Game.Types.StoryEvent (AtomicEvent(..), StoryEvent(..))
import Game.Types.TopLevelEvent (body, reoccurring, trigger)
import Game.Types.TopLevelEvent as TopLevelEvent
import Prelude (Unit, identity, unit, discard)


begin ∷ ∀ s. Builder s Unit → s
begin = getConstruct

build ∷ ∀ a. Buildable a ⇒ a → Builder a Unit
build x = BD x unit

ln ∷ String → Builder StoryEvent Unit
ln text = build (Atomic (Narration text))

restrict ∷ Builder StoryEvent Unit
restrict = build (Atomic StartInteraction)

never ∷ Condition
never = Pure Never

reoccuring ∷ Boolean
reoccuring = true

onlyOnce ∷ Boolean
onlyOnce = false

top ∷ String → Boolean → Condition → StoryEvent → Builder Story Unit
top n r c e =
  let 
    tl = TopLevelEvent.new n
               |> (if r then reoccurring else identity)
               |> (trigger c)
               |> (body e)
  in
    build (Story [tl])

story ∷ Story
story = begin do

  top "second" 
    onlyOnce
    never
    <| begin do
    ln "Welcome to the game!"
    ln "Another line for us to play with!"
    ln "Keep it going!"
