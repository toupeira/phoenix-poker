module Views where

import String
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Models exposing (..)
import Actions exposing (..)

view : Signal.Address Action -> Model -> Html
view address {player, session} =
  let
    mainView =
      case session of
        Nothing ->
          viewWithoutSession address player
        Just session ->
          viewWithSession address player session
  in
    div [ class "ui main container" ]
      [ header []
          [ h2 [ class "ui center aligned icon header" ]
            [ i [ class "circular users icon" ] []
            , text "Planning Poker" ]
          ]
      , mainView
      ]


viewWithoutSession : Signal.Address Action -> Player -> Html
viewWithoutSession address player =
  div [ class "ui centered grid" ]
    [ button [ class "ui primary button", onClick address (JoinSession initialSession) ]
      [ text "Join session" ] ]


viewWithSession : Signal.Address Action -> Player -> Session -> Html
viewWithSession address player session =
  let previousRounds = List.map (roundView address) session.previousRounds
      cards = List.map (cardView address session.deck) session.cards
  in
    div [ class "ui centered grid" ]
      [ button [ class "ui primary button", onClick address (LeaveSession) ]
        [ text "Leave session" ]
      , div [ class "ui row" ] cards
      , table [ class "ui celled table" ]
        [ thead []
          [ tr []
            [ th [] [ text "Picks" ]
            , th [] [ text "Result" ]
            ]
          ]
        , tbody [] [ roundView address session.currentRound ]
        , tbody [] previousRounds
        ]
      ]


roundView : Signal.Address Action -> Round -> Html
roundView address round =
  tr []
    [ td [] [ text (String.join ", " (List.map toString round.picks)) ]
    , td [] [ text (toString (pickAverage round.picks)) ]
    ]


cardView : Signal.Address Action -> Deck -> Card -> Html
cardView address deck card =
  let
    cardNumber = if card == 0 then "joker" else (toString card)
    cardImage = "images/cards/" ++ deck ++ "_" ++ cardNumber ++ ".png"
  in
    div [ class "ui two wide column" ]
      [ a [ class "ui fluid card deck-card", onClick address (PickCard card) ]
        [ img [ src cardImage ] [] ]
      ]


-- HELPERS

pluralize : number -> String -> String -> String
pluralize number singular plural =
  if number == 1 then
    singular
  else
    plural


pickAverage : List CardPick -> Int
pickAverage picks =
  case picks of
    [] ->
      0
    _ ->
      let sum = List.sum (List.map .card picks)
          length = toFloat (List.length picks)
      in
          round (sum / length)
