module Pages.Operators.Model exposing
    ( Edit
    , EditMode(..)
    , Model
    , ValidationError
    , default
    , defaultEdit
    , defaultError
    )

import Http.Model exposing (Operator, OperatorResponse, OperatorSuggestion)
import Material


type alias Model m =
    { mdc : Material.Model m
    , data : Maybe OperatorResponse
    , loading : Bool
    , limit : Int
    , offset : Int
    , country : Maybe String
    , name : Maybe String
    }


default : Model m
default =
    { mdc = Material.defaultModel
    , data = Nothing
    , loading = True
    , limit = 10
    , offset = 0
    , country = Nothing
    , name = Nothing
    }


type EditMode
    = Create
    | Update


type alias Edit m =
    { mdc : Material.Model m

    {- Current operation: either creating a new one or editing existing entry -}
    , mode : EditMode

    {- Model that is currently being edited -}
    , model : Maybe OperatorSuggestion

    {- Validation error messages -}
    , errors : Maybe ValidationError

    {- User hit send when creating/updating operator and request failed -}
    , failed : Maybe OperatorSuggestion
    }


defaultEdit : Edit m
defaultEdit =
    { mdc = Material.defaultModel
    , mode = Create
    , model = Nothing
    , errors = Nothing
    , failed = Nothing
    }


type alias ValidationError =
    { mcc : Maybe String
    , mnc : Maybe String
    , name : Maybe String
    , color : Maybe String
    }


defaultError : ValidationError
defaultError =
    { mcc = Nothing
    , mnc = Nothing
    , name = Nothing
    , color = Nothing
    }
