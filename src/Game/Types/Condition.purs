module Game.Types.Condition where


import Game.Types.ActionName (Name)


data Condition = Pure PureCondition
                 | Chance Number
                 | And Condition Condition
                 | Or Condition Condition
                 | Not Condition

data PureCondition = GameTimePassed Number -- TODO: Time
                     | Never
                     | Always
                     | ResourceAmountAbove String Int 
                     | ResourceActive String
                     | FireExtinguished
                     | FireStoked
                     | ActionPerformed Name
                     | MilestoneReached String
                     | TimeSinceMilestone String Number -- TODO: Time
                     | MilestoneAtCount String Int
                     | MilestoneGreaterThan String Int