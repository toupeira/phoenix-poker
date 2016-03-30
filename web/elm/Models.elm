module Models where

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
