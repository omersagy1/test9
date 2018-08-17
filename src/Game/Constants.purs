module Game.Constants where

import Common.Time (Time, seconds)


-- Default delay for enqueued messages.
defaultMessageDelay ∷ Time
defaultMessageDelay = seconds 2

-- Delay for the first message in an event.
firstMessageDelay ∷ Time
firstMessageDelay = seconds 0.3

-- Delay for the first message if there are
-- already other events waiting in the queue
-- to be executed. This is long in order to
-- space out events so they don't feel jumbled 
-- together.
firstMessageNonEmptyQueueDelay ∷ Time
firstMessageNonEmptyQueueDelay = seconds 2

-- Delay before the appearance of choice
-- buttons. This is in between the message
-- hinting to the user a choice might be made,
-- and the availability of the choice buttons
-- themselves.
choiceButtonsDelay ∷ Time
choiceButtonsDelay = seconds 0.35

-- The delay after the user makes a choice,
-- before the consequence record's message
-- appears.
-- TODO: This is not being used yet.
postChoiceMessageDelay ∷ Time
postChoiceMessageDelay = seconds 0.5

-- Delay before running the effect of an
-- event.
mutatorDelay ∷ Time
mutatorDelay = seconds 0.5

-- Delay before a story event triggered 
-- by a goto statement.
triggerStoryEventDelay ∷ Time
triggerStoryEventDelay = seconds 1.0


fastForwardFactor ∷ Number
fastForwardFactor = 5.0
