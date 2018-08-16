module Game.StateMutators where


update :: Time -> GameState -> GameState
update t s = 
  { s | gameTime = s.gameTime + t }
  |> updateActionCooldowns t
  |> (\s -> { s | fire = Fire.update t s.fire })


initRandomizer :: Time -> GameState -> GameState
initRandomizer t = updateRandomizer (Randomizer.init t)


updateRandomizer :: Randomizer -> GameState -> GameState
updateRandomizer randomizer s = { s | randomizer = randomizer}


addResource :: Resource -> GameState -> GameState
addResource r s =
  { s | resources = s.resources ++ [r] }


initFire :: Time -> Time -> GameState -> GameState
initFire burnTime stokeCooldown s =
  { s | fire = Fire.init burnTime 
      , actions = ActionSet.addAction (Action.fireAction stokeCooldown) s.actions
  }


updateActionCooldowns :: Time -> GameState -> GameState
updateActionCooldowns t s =
  { s | actions = ActionSet.map (Action.updateCooldown t) s.actions }


activeResources :: GameState -> List Resource
activeResources s =
  List.filter (\r -> r.active) s.resources

resourceActive :: String -> GameState -> Bool
resourceActive name s =
  List.member name (List.map .name (activeResources s))


getResourceNamed :: String -> GameState -> Maybe Resource
getResourceNamed name state =
  List.filter (\r -> r.name == name) state.resources
  |> List.head


applyToResource :: String -> (Resource -> Resource) -> GameState -> GameState
applyToResource name fn s =
  { s | resources = List.map (\r -> if r.name == name then
                                      fn r
                                    else r) 
                             s.resources}


resourceAmount :: String -> GameState -> Int
resourceAmount name s =
  getResourceNamed name s
  |> Maybe.map .amount
  |> Maybe.withDefault 0


addAction :: Action -> GameState -> GameState
addAction a s = { s | actions = ActionSet.addAction a s.actions}


actionPerformed :: ActionName.Name -> GameState -> Bool
actionPerformed a s = ActionSet.hasActionNamed a s.actionHistory


addActionToHistory :: Action -> GameState -> GameState
addActionToHistory a s = { s | actionHistory = ActionSet.addAction a s.actionHistory }


clearActionHistory :: GameState -> GameState
clearActionHistory s = { s | actionHistory = ActionSet.clearActions }


milestoneReached :: String -> GameState -> Bool
milestoneReached name s = Milestones.hasReached name s.milestones


setMilestoneReached :: String -> GameState -> GameState
setMilestoneReached name s =
  { s | milestones = Milestones.setReached name s.gameTime s.milestones }


incrementMilestone :: String -> GameState -> GameState
incrementMilestone name s =
  { s | milestones = Milestones.increment name s.gameTime s.milestones }


milestoneCounter :: String -> GameState -> Int
milestoneCounter name s = Milestones.counter name s.milestones


timeSince :: String -> GameState -> Maybe Time
timeSince name s = Milestones.timeSince name s.gameTime s.milestones


applyToAction :: ActionName.Name -> (Action -> Action) -> GameState -> GameState
applyToAction n f s =
  { s | actions = ActionSet.applyToNamed n f s.actions }


applyEffect :: Effect -> GameState -> GameState
applyEffect e s =
  case e of
    Effect.NoEffect -> s 

    Effect.ActivateResource name -> 
      applyToResource name (Resource.activate) s

    Effect.AddToResource name x -> 
      addToResource name x s

    Effect.AddToResourceRand name x y -> 
      addToResourceRand name x y s 

    Effect.SubtractResource name x ->
      applyToResource name (Resource.subtract x) s

    Effect.SetResourceAmount name x ->
      applyToResource name (Resource.mutate (\_ -> x)) s

    Effect.SetMilestoneReached name -> 
      setMilestoneReached name s

    Effect.IncrementMilestone name -> 
      incrementMilestone name s

    Effect.ActivateAction name -> 
      let x = Debug.log "ACTIVATING ACTION" name
          y = Debug.log "ACTIONS" s.actions 
      in (applyToAction name (Action.activate) s)

    Effect.DeactivateAction name -> 
      applyToAction name (Action.deactivate) s
    
    Effect.StokeFire ->
      { s | fire = Fire.stoke s.fire }
    
    Effect.GameOver ->
      gameOver s

    Effect.Compound effects -> 
      List.foldl applyEffect s effects

    Effect.Compound2 e1 e2 -> 
      List.foldl applyEffect s [e1, e2]


addToResource :: String -> Int -> GameState -> GameState
addToResource name x s = 
  let stateWithActiveResource =
    if not (resourceActive name s) then
      applyToResource name (Resource.activate) s
    else
      s
  in
    applyToResource 
      name (Resource.add x) stateWithActiveResource


addToResourceRand :: String -> Int -> Int -> GameState -> GameState
addToResourceRand name x y s =
  let
    (val, r) = Randomizer.int x y s.randomizer
  in
    addToResource name val s
    |> (\s -> { s | randomizer = r })


gameOver :: GameState -> GameState
gameOver s = { s | gameOver = True }