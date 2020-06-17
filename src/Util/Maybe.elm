module Util.Maybe exposing (..)


ifTrue : Bool -> a -> Maybe a
ifTrue bool value =
    if bool then
        Just value

    else
        Nothing
