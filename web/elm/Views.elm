module Views where

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Models exposing (..)
import Actions exposing (..)
import Widgets exposing (..)
import Util


view : Signal.Address Action -> Model -> Html
view address model =
  let
    mainView =
      if isOnline model then
        renderSession address model
      else
        renderLogin address model
  in
    div [ class "ui main container" ]
      [ header []
          [ h2 [ class "ui center aligned icon header" ]
            [ i [ class "circular users icon" ] []
            , text "Planning Poker" ]
          ]
      , mainView
      ]


renderLogin : Signal.Address Action -> Model -> Html
renderLogin address model =
  div [ class "ui centered grid" ]
    [ field address RenamePlayer
      [ value model.player.name
      , placeholder "Enter your GitHub username"
      , autofocus True ]
    , field address RenameRoom
      [ value model.room.name
      , placeholder "Enter a room name"
      , autofocus True ]
    , button
      [ class "ui primary button"
      , onClick joinRoom.address (model.room, model.player)
      ]
      [ text "Join room" ]
    ]


renderSession : Signal.Address Action -> Model -> Html
renderSession address model =
  let
    players = List.map renderPlayer (Dict.values model.players)
    cards = List.map (renderCard address model) cardPoints
  in
    div [ class "ui centered grid" ]
      [ button
        [ class "ui primary button"
        , title (":" ++ model.player.id ++ ":")
        , onClick leaveRoom.address model.player.id ]
        [ text "Leave room" ]
      , div [ class "ui row" ] players
      , div [ class "ui row" ] cards
      , table [ class "ui celled table" ]
        [ thead []
          [ tr []
            [ th [] [ text "Picks" ]
            , th [] [ text "Result" ]
            ]
          ]
        ]
      ]


renderCard : Signal.Address Action -> Model -> Card -> Html
renderCard address model card =
  let
    cardNumber = if card == 0 then "joker" else (toString card)
    cardImage = "images/cards/" ++ model.deck ++ "_" ++ cardNumber ++ ".png"
    players =
      model.picks
        |> Dict.filter (\key value -> value == card)
        |> Dict.keys
        |> Util.slice model.players
        |> List.map renderPlayer
  in
    div [ class "ui two wide column" ]
      [ a
        [ class "ui fluid card poker-card"
        , onClick pickCard.address card ]
        [ img [ src cardImage ] [] ]
      , div [ class "poker-card-players" ] players
      ]


renderPlayer : Player -> Html
renderPlayer player =
  img
    [ class "ui circular image poker-player"
    , alt player.name
    , title player.name
    , width 40
    , height 40
    , src ("https://github.com/" ++ player.name ++ ".png?size=40")
    ]
    []
