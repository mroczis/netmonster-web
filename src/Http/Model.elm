module Http.Model exposing
    ( Operator
    , OperatorResponse
    , OperatorSuggestion
    , decoderOperatorList
    , defaultOperatorSuggestion
    , encoderOperatorSuggestion
    )

import Json.Decode exposing (Decoder, field, int, list, map4, map6, string)
import Json.Encode as Encode


type alias OperatorResponse =
    { limit : Int
    , offset : Int
    , size : Int
    , data : List Operator
    }


type alias Operator =
    { mcc : String
    , mnc : String
    , iso : String
    , name : String
    , shortName : String
    , color : String
    }


type alias OperatorSuggestion =
    { mcc : String
    , mnc : String
    , name : String
    , shortName : String
    , color : String
    , email : String
    }


defaultOperatorSuggestion : OperatorSuggestion
defaultOperatorSuggestion =
    { mcc = ""
    , mnc = ""
    , name = ""
    , shortName = ""
    , color = ""
    , email = ""
    }


decoderOperatorList : Decoder OperatorResponse
decoderOperatorList =
    map4 OperatorResponse
        (field "limit" int)
        (field "offset" int)
        (field "size" int)
        (field "data" (list decoderOperator))


decoderOperator : Decoder Operator
decoderOperator =
    map6 Operator
        (field "mcc" string)
        (field "mnc" string)
        (field "iso" string)
        (field "network" string)
        (field "short_network" string)
        (field "color" string)


encoderOperatorSuggestion : OperatorSuggestion -> Encode.Value
encoderOperatorSuggestion op =
    Encode.object
        [ ( "mcc", Encode.string op.mcc )
        , ( "mnc", Encode.string op.mnc )
        , ( "name", Encode.string op.name )
        , ( "shortName", Encode.string op.shortName )
        , ( "color", Encode.string op.color )
        , ( "email", Encode.string op.email )
        ]
