module Widgets where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Actions exposing (..)


field : Signal.Address Action -> (String -> Action) -> List Attribute -> Html
field address action attrs =
  div [ class "ui input" ]
    [ input
      ([ type' "text"
      , on "change" targetValue (Signal.message address << action)
      ] ++ attrs)
      []
    ]
