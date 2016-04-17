module Helpers where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Models exposing (..)
import Actions exposing (..)


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


field : Signal.Address Action -> (String -> Action) -> List Attribute -> Html
field address action attrs =
  div [ class "ui input" ]
    [ input
      ([ type' "text"
      , on "change" targetValue (Signal.message address << action)
      ] ++ attrs)
      []
    ]
