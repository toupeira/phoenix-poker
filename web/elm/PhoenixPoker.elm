module PhoenixPoker where

import String
import StartApp.Simple as StartApp

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

main =
  StartApp.start
    { model = initialTable
    , view = view
    , update = update }


-- MODEL

initialTable =
  { name = "Untitled"
  , deck = "default"
  , cards = [ 1.0, 2.0, 3.0, 5.0, 8.0 ]
  , players = []
  , currentRound = { picks = [], points = 0.0 }
  , previousRounds =
      [ { picks = [ 2.0, 3.0, 5.0 ], points = 3.0 } ]
  }

type alias Model = Table

type alias Table =
  { name: String
  , deck: String
  , cards: List Card
  , players: List Player
  , currentRound: Round
  , previousRounds: List Round
}

type alias Round =
  { picks: List CardPick
  , points: Points
}

type alias Player =
  { name: String }

type alias CardPick = Card
type alias Card = Points
type alias Points = Float

-- UPDATE

type Action
  = PickCard Card
  | StartRound
  | EndRound
  | ClearTable

-- update : Action -> Model -> Model
update action model =
  case action of
    PickCard card ->
      -- TODO: check for existing pick
      -- TODO: replace existing pick
      let round = model.currentRound
          newRound = { round | picks = round.picks ++ [ card ] }
      in
        { model | currentRound = newRound }
    StartRound ->
      -- add new round
      model
    EndRound ->
      -- set round points from card picks
      model
    ClearTable ->
      initialTable


-- VIEW

-- view : Signal.Address Action -> Model -> Html
view address model =
  let previousRounds = List.map (roundView address) model.previousRounds
      cards = List.map (cardView address) model.cards
  in
    div [ class "ui container" ]
      [ h2 [ class "ui center aligned icon header" ]
        [ i [ class "circular users icon" ] []
        , text "Planning Poker" ]
      , div [ class "ui five column grid" ] cards
      , table [ class "ui celled table" ]
        [ thead []
          [ tr []
            [ th [] [ text "Picks" ]
            , th [] [ text "Result" ]
            ]
          ]
        , tbody [] [ roundView address model.currentRound ]
        , tbody [] previousRounds
        ]
      ]

roundView : Signal.Address Action -> Round -> Html
roundView address round =
  tr []
    [ td [] [ text (String.join ", " (List.map toString round.picks)) ]
    , td [] [ text (toString (pickAverage round.picks)) ]
    ]


cardView : Signal.Address Action -> Card -> Html
cardView address card =
  div [ class "column" ]
    [ a [ class ("ui fluid card card-" ++ (toString card)), onClick address (PickCard card) ]
      [ div [ class "content" ]
        [ span [ class "header" ]
          [ text ((toString card) ++ " " ++ (pluralize card "point" "points")) ]
        ]
      ]
    ]


pickAverage : List Card -> Int
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
