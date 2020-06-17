module Pages.Tools.Calculation.Wcdma exposing
    ( Model
    , Msg(..)
    , default
    , fromCi
    , fromCid
    , fromRnc
    , update
    )


type alias Model =
    { ci : Maybe Int
    , cid : Maybe Int
    , rnc : Maybe Int
    }


type Msg
    = Ci String
    | Cid String
    | Rnc String


default : Model
default =
    { ci = Nothing
    , cid = Nothing
    , rnc = Nothing
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Ci ci ->
            fromCi model ci

        Cid cid ->
            fromCid model cid

        Rnc rnc ->
            fromRnc model rnc


fromCi : Model -> String -> Model
fromCi defaultModel input =
    if input == "" then
        default

    else
        fromCiNonEmpty defaultModel input


fromCiNonEmpty : Model -> String -> Model
fromCiNonEmpty defaultModel =
    String.toInt >> Maybe.andThen fromCiInt >> Maybe.withDefault defaultModel


fromCiInt : Int -> Maybe Model
fromCiInt ci =
    let
        cid =
            modBy 65536 ci

        rnc =
            ci // 65536
    in
    if ci > 0 && ci < 268435455 then
        Just { ci = Just ci, cid = Just cid, rnc = Just rnc }

    else
        Nothing


fromCid : Model -> String -> Model
fromCid defaultModel input =
    if input == "" then
        { defaultModel | cid = Nothing, ci = Nothing }

    else
        fromCidNonEmpty defaultModel input


fromCidNonEmpty : Model -> String -> Model
fromCidNonEmpty defaultModel =
    String.toInt >> Maybe.andThen (fromCidInt defaultModel) >> Maybe.withDefault defaultModel


fromCidInt : Model -> Int -> Maybe Model
fromCidInt current cid =
    let
        ci =
            Maybe.map (\rnc -> rnc * 65536 + cid) current.rnc
    in
    if cid > 0 && cid < 65536 then
        Just { ci = ci, cid = Just cid, rnc = current.rnc }

    else
        Just current


fromRnc : Model -> String -> Model
fromRnc defaultModel input =
    if input == "" then
        { defaultModel | rnc = Nothing, ci = Nothing }

    else
        fromRncNonEmpty defaultModel input


fromRncNonEmpty : Model -> String -> Model
fromRncNonEmpty defaultModel =
    String.toInt >> Maybe.andThen (fromRncInt defaultModel) >> Maybe.withDefault defaultModel


fromRncInt : Model -> Int -> Maybe Model
fromRncInt current rnc =
    let
        ci =
            Maybe.map (\cid -> rnc * 65536 + cid) current.cid
    in
    if rnc > 0 && rnc < 4096 then
        Just { ci = ci, cid = current.cid, rnc = Just rnc }

    else
        Just current
