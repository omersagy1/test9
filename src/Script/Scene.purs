module Script.Scene where

import Script.Keywords

import Common.Time (seconds)
import Game.Types.Effect (Effect(..))
import Game.Types.Story (Story)
import Prelude (discard, show)


asString ∷ String
asString = show story


story ∷ Story
story = begin do
  top occursOnceWhen (gameTimePassed (seconds 1.5)) # do
    ln "The room is cold."
    ln "Foul water drips from the ceiling."
    ln "..."
    ln "You shiver."
    choices # do
      prompt "meditate" # do
        ln "You breathe deeply."
        ln "The freezing air bites your face."
      prompt "look up" # do
        ln "A thick haze clouds your vision."
        ln "But pale white letters speak to you..."
        ln "FUMIGATION CHAMBER"
    ln "..."
    ln "The cold is unbearable."
    effect (activateAction "search for wood")

  top occursOnceWhen (and (actionPerformed "search for wood")
                          (milestoneAtCount "wood-searched" 1)) # do
    ln "The ground is covered in grass..."
    ln "And dry little twigs."
    ln "They're meager, but they'll feed a fire."

  top occursOnceWhen fireStoked # do
    ln "Embers hatch in the brush."
    ln "You hover your hands over the flame."
    ln "..."
    ln "The fire is roaring."
    effect (IncrementMilestone "fire-stoked")
  
  top occursOnceWhen (and fireStoked (milestoneAtCount "fire-stoked" 1)) # do
    ln "You bring your face close to the flames."
    ln "A foreign smile stretches your lips."
    effect (IncrementMilestone "fire-stoked")

  top reoccuringWhen (and fireStoked (milestoneGreaterThan "fire-stoked" 1)) # do
    rand # do
      weighted 4 # do ln "The fire is roaring."
      unweighted # do ln "The flames double in height."
      unweighted # do ln "The fire crackles with a human voice."
      unweighted # do ln "You shiver with warmth."
      unweighted # do ln "The flames rise."
      unweighted # do ln "The fire dances with primitive urgency."
    effect (IncrementMilestone "fire-stoked")

  top occursOnceWhen (milestoneAtCount "wood-searched" 2) # do
    ln "The false starlight illuminates a rotting log."

  top reoccuringWhen (and (milestoneGreaterThan "wood-searched" 2)
                          (actionPerformed "search for wood")) # do
    rand # do
      unweighted # do ln "A few more twigs for the fire..."
      unweighted # do ln "The twigs are dirty, but dry enough..."
      unweighted # do ln "From your dark wandering you return with a small bounty..."

  top occursOnceWhen (timeSinceMilestone "fire-stoked" (seconds 5)) # do
    ln "..."
    ln "There is something artificial about this place."
    effect (activateAction "investigate")

  top occursOnceWhen (milestoneAtCount "did-investigate" 1) # do
    ln "The grass seems to stretch on for miles..."
    restrict
    ln "And the stars look false."
    choices # do
      prompt "call out" # do
        ln "Your own voice returns to you from every direction..."
        ln "Even from above."
      prompt "stay silent" # do
        ln "The haze congeals on your face..."
        ln "But your eyes see better in silence."
        ln "The haze hangs heavily over the surrounding forest."
        ln "You return to the fire."
    resume

  top occursOnceWhen (milestoneAtCount "did-investigate" 2) # do
    restrict
    ln "You find a body lying in the grass."
    ln "It's not moving."
    ln "The mud-stained dress on its back is speckled with flowers."
    choices # do
      prompt "turn it over" # do
        ln "A skull stares back up at you, framed by long blonde hair."
        ln "Its teeth are small and rotted."
        goto "defile-corpse-choice"
      prompt "crush its neck" # do
        ln "Its bony blonde head snaps from its shoulders..."
        ln "And rolls into the grass."
        ln "..."
        effect (SetMilestoneReached "corpse-defiled")
        goto "defile-corpse-choice"

  named "defile-corpse-choice" # do
    ln "Your hunger demands compense."
    choices # do
      prompt "search body" # do
        ln "You rip off the corpse's dress..."
        ln "But only find an insect den among its fleshy bones."
        ln "There is nothing of value here."
        ln "Except the dress."
        effect (SetMilestoneReached "corpse-dress-taken")
      prompt "return to fire" # do
        ln "You leave the weeping skull be."
        ln "The body fades into the haze..."
        ln "But not your memory of its flowery dress."
    resume

  top occursOnceWhen (milestoneAtCount "did-investigate" 3) # do
    restrict
    ln "It's raining..."
    ln "The drops sting your body."
    ln "You go back inside."
    ln "There is a someone sitting by the fire."
    choices # do
      prompt "Who are you?" # do
        ln "..."
        ln "The man looks up."
        di "Didn't expect to ever find another soul up here on AL 50."
        di "Except for ol' Cathy."
        cond (milestoneReached "corpse-dress-taken") # do
          ln "...whose dress I see you've taken to wearing."
          di "An original look, I can give you that."
          ln "The man chuckles to himself."
        cond (milestoneReached "corpse-defiled") # do
          ln "Poor girl's head came right off her poor head."
          di "Wonder what kind of nasty critter would do something like that..."
        goto "visitor-intro"
      prompt "Get out!" # do
        ln "..."
        ln "The man is unfazed."
        di "You ought to relax, stranger."
        cases # do
          when (milestoneReached "corpse-dress-taken") # do
            ln "I ain't afraid of a haggard man in a flowery dress."
          when (milestoneReached "corpse-defiled") # do
            ln "You aren't going to be able to crush my bony head like you did poor Cathy's."
            di "Ain't nobody up here on AL 50 except me..."
            di "And you."
            goto "visitor-intro"
  
  named "visitor-intro" # do
    ln "The man reaches out his hand."
    ln "You shake it."
    di "You look like you need some food, friend."
    di "Have a critter."
    ln "The man plops a dead rat into your trembling palm."
    effect (AddToResource "rats" 1)
    di "I tell you I never seen rats on the whole Ark like I seen 'em here."
    di "Name's Don."
    resume
    di "Mine, not the rat's."
    effect (activateAction "hunt rats")

  top occursOnceWhen (milestoneAtCount "rats-hunted" 1) # do
    ln "You scramble in the mud and dig your nails into a writhing mass."

  top occursOnceWhen (timeSinceMilestone "rats-hunted" (seconds 10)) # do
    goto "game-over"
  
  named "game-over" # do
    ln "..."
    ln " ~ TO BE CONTINUED ~ "
    effect GameOver
