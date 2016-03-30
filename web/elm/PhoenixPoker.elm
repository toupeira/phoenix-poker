module PhoenixPoker where

import Maybe exposing (..)
import String
import StartApp.Simple as StartApp

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

main : Signal Html
main =
  StartApp.start
    { model = initialModel
    , view = view
    , update = update }


--------------------------------------------------------------------------------
-- MODEL
--------------------------------------------------------------------------------

type alias Model =
  { player : Player
  , session : Maybe Session }

type alias Session =
  { id : Int
  , name : String
  , deck : String
  , cards : List Card
  , players : List Player
  , currentRound : Round
  , previousRounds : List Round
}

type alias Player =
  { id : Maybe Int
  , name : String }

type alias Deck = String
type alias Card = Points
type alias Points = Float

type alias Round =
  { picks : List CardPick
  , points : Points
}

type alias CardPick =
  { player : Player
  , card : Card }

initialModel : Model
initialModel =
  { player = { id = Nothing , name = "Anonymous" }
  , session = Nothing
  }

initialSession : Session
initialSession =
  { id = 1
  , name = "Untitled"
  , deck = "a"
  , cards = [ 1.0, 2.0, 3.0, 5.0, 8.0, 0.0 ]
  , players = []
  , currentRound = { picks = [], points = 0.0 }
  , previousRounds = []
  }

cardDecks : List Deck
cardDecks =
  [ "a", "b", "c", "d", "e", "f" ]

--------------------------------------------------------------------------------
--- UPDATE
--------------------------------------------------------------------------------

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


--------------------------------------------------------------------------------
-- VIEW
--------------------------------------------------------------------------------

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
