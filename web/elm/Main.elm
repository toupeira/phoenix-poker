module Main where

import StartApp
import Html
import Effects exposing (Effects)

import Models exposing (..)
import Views exposing (..)
import Actions exposing (..)


app : StartApp.App Model
app =
  StartApp.start
    { init = (init, Effects.none)
    , view = view
    , update = update
    , inputs = [] }


main : Signal Html.Html
main =
  app.html
