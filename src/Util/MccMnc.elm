module Util.MccMnc exposing (..)

import List exposing (range)
import Regex
import Util.Regex exposing (hasFullMatch)


isMcc : String -> Bool
isMcc string =
    let
        regex =
            Maybe.withDefault Regex.never <|
                Regex.fromString "^[1-9][0-9]{2}$"
    in
    Regex.find regex string |> hasFullMatch


isMnc : String -> Bool
isMnc string =
    let
        validRange =
            range 1 999

        mncNumber =
            String.toInt string |> Maybe.withDefault 0
    in
    String.length string <= 3 && List.member mncNumber validRange
