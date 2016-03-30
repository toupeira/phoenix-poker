module Main where

import StartApp.Simple as StartApp
import Html

import Models exposing (..)
import Views exposing (..)
import Actions exposing (..)

main : Signal Html.Html
main =
  StartApp.start
    { model = initialModel
    , view = view
    , update = update }
