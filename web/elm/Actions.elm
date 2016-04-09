module Actions where

import Effects exposing (Effects)

import Models exposing (..)


type Action
  = JoinSession Player
  | LeaveSession
  | ChangeUsername String
  | PickCard Card
  | StartRound
  | EndRound


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    JoinSession player ->
      ( { model | session = Just initSession }
      , Effects.none )
    LeaveSession ->
      ( { model | session = Nothing }
      , Effects.none )
    ChangeUsername name ->
      let
        newPlayer = changeUsername model.player name
      in
        ( { model | player = newPlayer }
        , Effects.none )
    _ ->
      case model.session of
        Nothing ->
          ( model, Effects.none )
        Just session' ->
          ( { model | session = Just (updateSession action model.player session') }
          , Effects.none )


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


changeUsername : Player -> String -> Player
changeUsername player name =
  { player | name = name }


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
