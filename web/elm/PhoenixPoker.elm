module PhoenixPoker where

import String
import StartApp.Simple as StartApp

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

main : Signal Html
main =
  StartApp.start
    { model = initialTable
    , view = view
    , update = update }


-- MODEL

initialTable : Table
initialTable =
  { name = "Untitled"
  , deck = "a"
  , cards = [ 1.0, 2.0, 3.0, 5.0, 8.0, 0.0 ]
  , players = []
  , currentRound = { picks = [], points = 0.0 }
  , previousRounds =
      [ { picks = [ 2.0, 3.0, 5.0 ], points = 3.0 } ]
  }

type alias Model = Table

type alias Player =
  { name: String }

type alias Table =
  { name: String
  , deck: String
  , cards: List Card
  , players: List Player
  , currentRound: Round
  , previousRounds: List Round
}

type alias Points = Float
type alias Card = Points
type alias CardPick = Card

type alias Round =
  { picks: List CardPick
  , points: Points
}

type alias Deck = String

cardDecks : List Deck
cardDecks =
  [ "a", "b", "c", "d", "e", "f" ]

type Action
  = PickCard Card
  | StartRound
  | EndRound
  | ClearTable

update : Action -> Model -> Model
update action currentTable =
  case action of
    PickCard card ->
      -- TODO: check for existing pick
      -- TODO: replace existing pick
      let round = currentTable.currentRound
          newRound = { round | picks = round.picks ++ [ card ] }
      in
        { currentTable | currentRound = newRound }
    StartRound ->
      -- add new round
      currentTable
    EndRound ->
      -- set round points from card picks
      currentTable
    ClearTable ->
      initialTable

-- VIEW

view : Signal.Address Action -> Model -> Html
view address currentTable =
  let previousRounds = List.map (roundView address) currentTable.previousRounds
      cards = List.map (cardView address currentTable.deck) currentTable.cards
  in
    div [ class "ui main container" ]
      [ h2 [ class "ui center aligned icon header" ]
        [ i [ class "circular users icon" ] []
        , text "Planning Poker" ]
      , div [ class "ui eight column centered grid" ] cards
      , table [ class "ui celled table" ]
        [ thead []
          [ tr []
            [ th [] [ text "Picks" ]
            , th [] [ text "Result" ]
            ]
          ]
        , tbody [] [ roundView address currentTable.currentRound ]
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
    div [ class "column" ]
      [ a [ class "ui fluid card deck-card", onClick address (PickCard card) ]
        [ img [ src cardImage ] [] ]
      ]


pickAverage : List CardPick -> Int
pickAverage picks =
  case picks of
    [] ->
      0
    _ ->
      let sum = List.sum picks
          length = toFloat (List.length picks)
      in
          round (sum / length)


-- HELPERS

pluralize : number -> String -> String -> String
pluralize number singular plural =
  if number == 1 then
    singular
  else
    plural
