module Pages.Tools.Calculation.Lte exposing
    ( Model
    , Msg(..)
    , default
    , fromCid
    , fromEci
    , fromEnb
    , update
    )


type alias Model =
    { eci : Maybe Int
    , cid : Maybe Int
    , enb : Maybe Int
    }


type Msg
    = Eci String
    | Cid String
    | Enb String


default : Model
default =
    { eci = Nothing
    , cid = Nothing
    , enb = Nothing
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Eci eci ->
            fromEci model eci

        Cid cid ->
            fromCid model cid

        Enb rnc ->
            fromEnb model rnc


fromEci : Model -> String -> Model
fromEci defaultModel input =
    if input == "" then
        default

    else
        fromEciNonEmpty defaultModel input


fromEciNonEmpty : Model -> String -> Model
fromEciNonEmpty defaultModel =
    String.toInt >> Maybe.andThen fromEciInt >> Maybe.withDefault defaultModel


fromEciInt : Int -> Maybe Model
fromEciInt eci =
    let
        cid =
            modBy 256 eci

        enb =
            eci // 256
    in
    if eci > 0 && eci < 268435456 then
        Just { eci = Just eci, cid = Just cid, enb = Just enb }

    else
        Nothing


fromCid : Model -> String -> Model
fromCid defaultModel input =
    if input == "" then
        { defaultModel | cid = Nothing, eci = Nothing }

    else
        fromCidNonEmpty defaultModel input


fromCidNonEmpty : Model -> String -> Model
fromCidNonEmpty defaultModel =
    String.toInt >> Maybe.andThen (fromCidInt defaultModel) >> Maybe.withDefault defaultModel


fromCidInt : Model -> Int -> Maybe Model
fromCidInt current cid =
    let
        eci =
            Maybe.map (\enb -> enb * 256 + cid) current.enb
    in
    if cid > 0 && cid < 256 then
        Just { eci = eci, cid = Just cid, enb = current.enb }

    else
        Just current


fromEnb : Model -> String -> Model
fromEnb defaultModel input =
    if input == "" then
        { defaultModel | enb = Nothing, eci = Nothing }

    else
        fromEnbNonEmpty defaultModel input


fromEnbNonEmpty : Model -> String -> Model
fromEnbNonEmpty defaultModel =
    String.toInt >> Maybe.andThen (fromEnbInt defaultModel) >> Maybe.withDefault defaultModel


fromEnbInt : Model -> Int -> Maybe Model
fromEnbInt current enb =
    let
        eci =
            Maybe.map (\cid -> enb * 256 + cid) current.cid
    in
    if enb > 0 && enb < 1048576 then
        Just { eci = eci, cid = current.cid, enb = Just enb }

    else
        Just current
