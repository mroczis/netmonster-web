module Util.Regex exposing (..)

import Regex exposing (Match)

has : (a -> Bool) -> List a -> Bool
has filter list =
    List.filter filter list |> List.isEmpty |> not


hasFullMatch : List Match -> Bool
hasFullMatch matches =
    has (\result -> String.isEmpty result.match |> not) matches