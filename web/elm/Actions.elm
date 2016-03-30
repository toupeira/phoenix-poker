module Actions where

import Models exposing (..)

type Action
  = JoinSession Session
  | LeaveSession
  | PickCard Card
  | StartRound
  | EndRound


update : Action -> Model -> Model
update action model =
  case action of
    JoinSession session ->
      { model | session = Just session }
    LeaveSession ->
      { model | session = Nothing }
    _ ->
      case model.session of
        Nothing ->
          model
        Just session' ->
          { model | session = Just (updateSession action model.player session') }


updateSession : Action -> Player -> Session -> Session
updateSession action player session =
  case action of
    PickCard card ->
      -- pickCard session player card
      pickCard session player card
    StartRound ->
      -- add new round
      session
    EndRound ->
      -- set round points from card picks
      session
    _ ->
      session


pickCard : Session -> Player -> Card -> Session
pickCard session player card =
  -- TODO: check for existing pick
  -- TODO: replace existing pick
  let
    newPick = CardPick player card
    round = session.currentRound
    newRound = { round | picks = round.picks ++ [ newPick ] }
  in
    { session | currentRound = newRound }
