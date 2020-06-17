module Pages.Operators.ViewModel exposing
    ( EditField(..)
    , EditMsg(..)
    , Msg(..)
    , getOperators
    , update
    , updateEdit
    )

import Http
import Http.Client as Client
import Http.Model exposing (Operator, OperatorResponse, OperatorSuggestion, defaultOperatorSuggestion)
import Material
import Material.Snackbar as Snackbar
import Maybe.Extra
import Pages.Operators.Model exposing (Edit, EditMode(..), Model, ValidationError, defaultError)
import Util.Color as Color
import Util.MccMnc exposing (isMcc, isMnc)


type Msg m
    = Mdc (Material.Msg m)
    | NextPage
    | PreviousPage
    | CountryChanged String
    | NameChanged String
    | DataReceived (Result Http.Error OperatorResponse)


type EditMsg m
    = EditMdc (Material.Msg m)
    | StartEdit Operator
    | StartCreate
    | Cancel
    | Confirm
    | Retry
    | Changed EditField
    | Validate EditField
    | ClearError EditField
    | SuggestionSent OperatorSuggestion (Result Http.Error ())


type EditField
    = Name String
    | ShortName String
    | Color String
    | Mcc String
    | Mnc String
    | Email String


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        NextPage ->
            let
                newModel =
                    { model | offset = model.offset + model.limit, loading = True }
            in
            ( newModel, getOperators lift newModel )

        PreviousPage ->
            let
                newModel =
                    { model | offset = model.offset - model.limit, loading = True }
            in
            ( newModel, getOperators lift newModel )

        CountryChanged country ->
            let
                validatedCountry =
                    if String.isEmpty country then
                        Nothing

                    else
                        Just country

                newModel =
                    { model | country = validatedCountry, offset = 0, loading = True }
            in
            ( newModel, getOperators lift newModel )

        NameChanged name ->
            let
                validatedName =
                    if String.isEmpty name then
                        Nothing

                    else
                        Just name

                newModel =
                    { model | name = validatedName, offset = 0, loading = True }
            in
            ( newModel, getOperators lift newModel )

        DataReceived result ->
            case result of
                Ok data ->
                    ( { model | data = Just data, loading = False }, Cmd.none )

                Err _ ->
                    ( { model | data = Nothing, loading = False }, Cmd.none )


updateEdit : (EditMsg m -> m) -> EditMsg m -> Edit m -> ( Edit m, Cmd m )
updateEdit lift msg model =
    case msg of
        EditMdc msg_ ->
            Material.update (lift << EditMdc) msg_ model

        StartEdit operator ->
            ( { model | model = toSuggestion operator |> Just, mode = Update }, Cmd.none )

        StartCreate ->
            ( { model | model = Just defaultOperatorSuggestion, mode = Create }, Cmd.none )

        Cancel ->
            ( { model | model = Nothing, errors = Nothing }, Cmd.none )

        Confirm ->
            case ( model.errors, model.model ) of
                ( Nothing, Just op ) ->
                    ( { model | model = Nothing }, sendSuggestion lift op )

                ( _, _ ) ->
                    ( model, Cmd.none )

        Retry ->
            case model.failed of
                Just request ->
                    ( { model | failed = Nothing }, sendSuggestion lift request )

                _ ->
                    ( model, Cmd.none )

        {- Changes block -> user changed content of inputs -}
        Changed (Name name) ->
            ( replace model (\it -> { it | name = name }), Cmd.none )

        Changed (ShortName shortName) ->
            ( replace model (\it -> { it | shortName = shortName }), Cmd.none )

        Changed (Color color) ->
            ( replace model (\it -> { it | color = color }), Cmd.none )

        Changed (Mcc mcc) ->
            ( replace model (\it -> { it | mcc = mcc }), Cmd.none )

        Changed (Mnc mnc) ->
            ( replace model (\it -> { it | mnc = mnc }), Cmd.none )

        Changed (Email email) ->
            ( replace model (\it -> { it | email = email }), Cmd.none )

        {- Validation block -> user lost focus on give field -}
        Validate (Name name) ->
            let
                validated =
                    setError model (String.isEmpty name) "Name is required" (\e m -> { e | name = m })
            in
            ( validated, Cmd.none )

        Validate (Color color) ->
            let
                validated =
                    setError model (not (String.isEmpty color || Color.isHexColor color)) "Color is invalid" (\e m -> { e | color = m })
            in
            ( validated, Cmd.none )

        Validate (Mcc mcc) ->
            let
                validated =
                    setError model (isMcc mcc |> not) "Must be in rage from 100 to 999" (\e m -> { e | mcc = m })
            in
            ( validated, Cmd.none )

        Validate (Mnc mnc) ->
            let
                validated =
                    setError model (isMnc mnc |> not) "Must be in rage from 1 to 999" (\e m -> { e | mnc = m })
            in
            ( validated, Cmd.none )

        Validate _ ->
            ( model, Cmd.none )

        {- Clearing block -> user focused block once again -}
        ClearError (Name _) ->
            ( clearError model (\e -> { e | name = Nothing }), Cmd.none )

        ClearError (Color _) ->
            ( clearError model (\e -> { e | color = Nothing }), Cmd.none )

        ClearError (Mcc _) ->
            ( clearError model (\e -> { e | mcc = Nothing }), Cmd.none )

        ClearError (Mnc _) ->
            ( clearError model (\e -> { e | mnc = Nothing }), Cmd.none )

        ClearError _ ->
            ( model, Cmd.none )

        SuggestionSent request result ->
            case result of
                Err _ ->
                    let
                        contents =
                            let
                                snack =
                                    Snackbar.snack
                                        (Just <| lift <| Retry)
                                        "Sending failed"
                                        "Retry"
                            in
                            { snack | dismissOnAction = True, stacked = False }

                        ( mdc, effects ) =
                            Snackbar.add (lift << EditMdc) "snackbar-error" contents model.mdc
                    in
                    ( { model | failed = Just request, mdc = mdc }, effects )

                _ ->
                    ( { model | failed = Nothing }, Cmd.none )


replace : Edit m -> (OperatorSuggestion -> OperatorSuggestion) -> Edit m
replace model op =
    { model | model = Maybe.map op model.model }


getOperators : (Msg m -> m) -> Pages.Operators.Model.Model m -> Cmd m
getOperators lift model =
    Http.get
        { url = Client.operatorsUrl model
        , expect = Http.expectJson (lift << DataReceived) Http.Model.decoderOperatorList
        }


sendSuggestion : (EditMsg m -> m) -> OperatorSuggestion -> Cmd m
sendSuggestion lift model =
    Http.post
        { url = Client.suggestionUrl
        , expect = Http.expectWhatever (lift << SuggestionSent model)
        , body = Http.jsonBody <| Http.Model.encoderOperatorSuggestion model
        }


setError : Edit m -> Bool -> String -> (ValidationError -> Maybe String -> ValidationError) -> Edit m
setError model validationFailed errorMessage callback =
    let
        message =
            if validationFailed then
                Just errorMessage

            else
                Nothing

        editedErrors =
            case model.errors of
                Just something ->
                    callback something message

                Nothing ->
                    callback defaultError message
    in
    { model | errors = editedErrors |> sanitize }


clearError : Edit m -> (ValidationError -> ValidationError) -> Edit m
clearError model callback =
    let
        errors =
            Maybe.map callback model.errors
    in
    { model | errors = Maybe.withDefault defaultError errors |> sanitize }


sanitize : ValidationError -> Maybe ValidationError
sanitize errors =
    if Maybe.Extra.isJust errors.name || Maybe.Extra.isJust errors.mcc || Maybe.Extra.isJust errors.mnc || Maybe.Extra.isJust errors.color then
        Just errors

    else
        Nothing


toSuggestion : Operator -> OperatorSuggestion
toSuggestion op =
    { mcc = op.mcc
    , mnc = op.mnc
    , name = op.name
    , shortName = op.shortName
    , color = op.color
    , email = ""
    }
