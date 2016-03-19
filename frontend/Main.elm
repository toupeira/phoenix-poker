import Html exposing (Html, div, button, text)
import StartApp.Simple as StartApp

main =
  StartApp.start {
    model = initialModel,
    view = view,
    update = update
  }

-- MODEL

initialModel = {
    cards = [ 1, 2, 3, 5, 8 ],
    players = [],
    rounds = [],
    deck = "default"
  }

type alias Model = Table

type alias Table = {
  cards: List Card,
  players: List Player,
  rounds: List Round,
  deck: String
}

type alias Round = {
  picks: List CardPick,
  points: Points
}

type alias Player = {
  name: String
}

type alias CardPick = Card
type alias Card = Points
type alias Points = Int

-- UPDATE

type Action = PickCard | StartRound | EndRound | ClearTable

update : Action -> Model -> Model
update action model =
  case action of
    PickCard ->
      -- add card to current round's list of picks
      model
    StartRound ->
      -- add new round
      model
    EndRound ->
      -- set round points from card picks
      model
    ClearTable ->
      initialModel

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  text "hi there"
