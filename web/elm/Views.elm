module Views where

import String
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Models exposing (..)
import Actions exposing (..)
import Helpers exposing (..)


view : Signal.Address Action -> Model -> Html
view address {player, session} =
  let
    mainView =
      case session of
        Nothing ->
          renderLogin address player
        Just session ->
          renderSession address player session
  in
    div [ class "ui main container" ]
      [ header []
          [ h2 [ class "ui center aligned icon header" ]
            [ i [ class "circular users icon" ] []
            , text "Planning Poker" ]
          ]
      , mainView
      ]


renderLogin : Signal.Address Action -> Player -> Html
renderLogin address player =
  div [ class "ui centered grid" ]
    [ field [ value player.name, placeholder "Enter your GitHub username" ]
        address ChangeUsername
    , button [ class "ui primary button", onClick address (JoinSession initialSession) ]
      [ text "Join session" ]
    , div [ class "ui row" ]
      [ div [ class "ui huge pointing red label" ]
        [ text ("Hello " ++ (if String.isEmpty player.name then "Anonymous" else player.name) ++ "!") ]
      ]
    ]


renderSession : Signal.Address Action -> Player -> Session -> Html
renderSession address player session =
  let previousRounds = List.map (renderRound address) session.previousRounds
      cards = List.map (renderCard address session.deck) session.cards
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
        , tbody [] [ renderRound address session.currentRound ]
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
