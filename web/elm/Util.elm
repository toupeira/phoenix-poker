module Util where

import Dict exposing (Dict)


slice : Dict comparable b -> List comparable -> List b
slice dict keys =
  List.foldr (\key values ->
    let
      value = Dict.get key dict
    in
      case value of
        Just value -> value :: values
        Nothing    -> values
    ) [] keys
