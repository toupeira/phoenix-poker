module Models where

import Dict exposing (Dict)


type alias ID = String

type alias Model =
  { player : Player
  , room : Room
  , deck : String
  , players : Dict ID Player
  , picks : Dict ID Card
  }

type alias Room =
  { id : ID
  , name : String }

type alias Player =
  { id : ID
  , name : String }

type alias Deck = String
type alias Card = Points
type alias Points = Float

type alias CardPick =
  { playerId : ID
  , card : Card }


init : ID -> Model
init playerId =
  { player = (initPlayer playerId)
  , room = initRoom
  , deck = "a"
  , players = Dict.empty
  , picks = Dict.empty
  }

initPlayer : ID -> Player
initPlayer playerId =
  { id = playerId, name = "" }

initRoom : Room
initRoom =
  { id = "", name = "" }

cardPoints : List Card
cardPoints =
  [ 1.0, 2.0, 3.0, 5.0, 8.0, 0.0 ]

cardDecks : List Deck
cardDecks =
  [ "a", "b", "c", "d", "e", "f" ]

isOnline : Model -> Bool
isOnline model =
  Dict.member model.player.id model.players
