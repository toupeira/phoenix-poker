module Main where

import Task exposing (Task)
import Effects exposing (Effects, Never)
import StartApp
import Html

import Models exposing (..)
import Views exposing (..)
import Actions exposing (..)


app : StartApp.App Model
app =
  StartApp.start
    { init = ((init playerId), Effects.none)
    , view = view
    , update = update
    , inputs =
      [ Signal.map PlayerJoined playerJoinedEvent
      , Signal.map PlayerLeft playerLeftEvent
      , Signal.map CardPicked cardPickedEvent ]
    }


main : Signal Html.Html
main =
  app.html


-- outgoing ports

port runner : Signal (Task Never ())
port runner =
  app.tasks

port joinRoomEvent : Signal (Room, Player)
port joinRoomEvent =
  joinRoom.signal

port leaveRoomEvent : Signal ID
port leaveRoomEvent =
  leaveRoom.signal

port pickCardEvent : Signal Card
port pickCardEvent =
  pickCard.signal


-- incoming ports

port playerId : ID
port playerJoinedEvent : Signal Player
port playerLeftEvent : Signal ID
port cardPickedEvent : Signal CardPick
