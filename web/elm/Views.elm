module Views where

import String
import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Models exposing (..)
import Actions exposing (..)
import Helpers exposing (..)


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
  let previousRounds = List.map (renderRound address) model.previousRounds
      players = List.map renderPlayer (Dict.values model.players)
      cards = List.map (renderCard address model.deck) cardPoints
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
        , tbody [] [ renderRound address model.currentRound ]
        , tbody [] previousRounds
        ]
      ]


renderRound : Signal.Address Action -> Round -> Html
renderRound address round =
  tr []
    [ td [] [ text (String.join ", " (List.map toString round.picks)) ]
    , td [] [ text (toString (pickAverage round.picks)) ]
    ]


renderCard : Signal.Address Action -> Deck -> Card -> Html
renderCard address deck card =
  let
    cardNumber = if card == 0 then "joker" else (toString card)
    cardImage = "images/cards/" ++ deck ++ "_" ++ cardNumber ++ ".png"
  in
    div [ class "ui two wide column" ]
      [ a [ class "ui fluid card deck-card", onClick address (PickCard card) ]
        [ img [ src cardImage ] [] ]
      ]


renderPlayer : Player -> Html
renderPlayer player =
  img
    [ class "ui circular image"
    , alt player.name
    , title player.name
    , width 40
    , height 40
    , src ("https://github.com/" ++ player.name ++ ".png?size=40")
    ]
    []
