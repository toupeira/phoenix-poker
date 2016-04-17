module Actions where

import Dict
import Effects exposing (Effects)

import Models exposing (..)


type Action
  = PlayerJoined Player
  | PlayerLeft ID
  | RenamePlayer String
  | RenameRoom String
  | PickCard Card
  | StartRound
  | EndRound


joinRoom : Signal.Mailbox (Room, Player)
joinRoom =
  Signal.mailbox (initRoom, initPlayer "")

leaveRoom : Signal.Mailbox ID
leaveRoom =
  Signal.mailbox ""


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    PlayerJoined player ->
      let
        players = Dict.insert player.id player model.players
        newModel = { model | players = players }
      in
        ( newModel, Effects.none )
    PlayerLeft playerId ->
      let
        players = if playerId == model.player.id then
          Dict.empty
        else
          Dict.remove playerId model.players
        newModel = { model | players = players }
      in
        ( newModel, Effects.none )
    RenamePlayer name ->
      let
        newModel = { model | player = renamePlayer model.player name }
      in
        ( newModel, Effects.none )
    RenameRoom name ->
      let
        newModel = { model | room = renameRoom model.room name }
      in
        ( newModel, Effects.none )
    _ ->
      if isOnline model then
        updateSession action model
      else
        ( model, Effects.none )


updateSession : Action -> Model -> (Model, Effects Action)
updateSession action model =
  case action of
    PickCard card ->
      ( (pickCard model card), Effects.none )
    StartRound ->
      -- add new round
      ( model, Effects.none )
    EndRound ->
      -- set round points from card picks
      ( model, Effects.none )
    _ ->
      ( model, Effects.none )


renamePlayer : Player -> String -> Player
renamePlayer player name =
  { player | name = name }


renameRoom : Room -> String -> Room
renameRoom room name =
  { room | name = name }


pickCard : Model -> Card -> Model
pickCard model card =
  -- TODO: check for existing pick
  -- TODO: replace existing pick
  let
    newPick = CardPick model.player card
    round = model.currentRound
    newRound = { round | picks = round.picks ++ [ newPick ] }
  in
    { model | currentRound = newRound }
