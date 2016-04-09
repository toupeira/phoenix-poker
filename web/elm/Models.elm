module Models where


type alias Model =
  { player : Player
  , session : Maybe Session }

type alias Session =
  { id : Int
  , name : String
  , deck : String
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

init : Model
init =
  { player = { id = Nothing , name = "" }
  , session = Nothing
  }

initSession : Session
initSession =
  { id = 1
  , name = "Untitled"
  , deck = "a"
  , players = []
  , currentRound = { picks = [], points = 0.0 }
  , previousRounds = []
  }

cardPoints : List Card
cardPoints =
  [ 1.0, 2.0, 3.0, 5.0, 8.0, 0.0 ]

cardDecks : List Deck
cardDecks =
  [ "a", "b", "c", "d", "e", "f" ]
