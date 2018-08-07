module Game.Types.Condition where

import Data.Time (Time)

import Game.Types.ActionName (Name)


data Condition = Pure PureCondition
                 | Chance Number
                 | And Condition Condition
                 | Or Condition Condition
                 | Not Condition

data PureCondition = GameTimePassed Time
                     | Never
                     | Always
                     | ResourceAmountAbove String Int 
                     | ResourceActive String
                     | FireExtinguished
                     | FireStoked
                     | ActionPerformed Name
                     | MilestoneReached String
                     | TimeSinceMilestone String Time
                     | MilestoneAtCount String Int
                     | MilestoneGreaterThan String Int
