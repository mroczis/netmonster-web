module Util.Color exposing (isHexColor)

import Regex exposing (Match)
import Util.Regex exposing (hasFullMatch)


{-| Checks if color is in format #RGB or #RRGGBB
-}
isHexColor : String -> Bool
isHexColor string =
    let
        shortColor =
            Maybe.withDefault Regex.never <|
                Regex.fromStringWith { caseInsensitive = True, multiline = False }
                    "#?([0-9A-F])([0-9A-F])([0-9A-F])"

        fullColor =
            Maybe.withDefault Regex.never <|
                Regex.fromStringWith { caseInsensitive = True, multiline = False }
                    "#?([0-9A-F]{2})([0-9A-F]{2})([0-9A-F]{2})"
    in
    case String.length string of
        3 ->
            hasFullMatch (Regex.find shortColor string)

        4 ->
            hasFullMatch (Regex.find shortColor string)

        6 ->
            hasFullMatch (Regex.find fullColor string)

        7 ->
            hasFullMatch (Regex.find fullColor string)

        _ ->
            False
