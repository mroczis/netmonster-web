module Pages.Operators.ViewEdit exposing (alertDialog, subscriptions)

import Design.Html exposing (..)
import Html exposing (Attribute, Html, div, span, text)
import Http.Model exposing (Operator, OperatorResponse, OperatorSuggestion)
import Material exposing (Index)
import Material.Button as Button
import Material.Dialog as Dialog
import Material.Options as Options exposing (Property, cs, css, styled, when)
import Material.TextField as TextField
import Material.TextField.HelperLine as TextField
import Material.TextField.HelperText as TextField
import Maybe.Extra
import Pages.Operators.Model exposing (Edit, EditMode(..), Model)
import Pages.Operators.ViewModel exposing (EditField(..), EditMsg(..), Msg(..))
import Util.Color


subscriptions : (EditMsg m -> m) -> Edit m -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << EditMdc) model


alertDialog : (EditMsg m -> m) -> Edit m -> Html m
alertDialog lift model =
    let
        index =
            "edit-operator"

        title =
            case model.mode of
                Create ->
                    "Suggest addition"

                Update ->
                    "Suggest edit"
    in
    case model.model of
        Just op ->
            Dialog.view (lift << EditMdc)
                index
                model.mdc
                [ Dialog.open |> when (Maybe.Extra.isJust model.model)
                , Dialog.onClose (lift Cancel)
                ]
                [ Dialog.content []
                    [ section title
                    , paragraph "Changes you make will be visible once they are verified by admin."
                    , paragraph "You can optionally add your e-mail. We'll let you know once the request will be processed."
                    , mccMncHeader lift index model op
                    , inputField lift
                        model.mdc
                        (index ++ "-name")
                        op.name
                        "Name"
                        Name
                        (Maybe.andThen .name model.errors)
                        []
                        []
                    , inputField lift
                        model.mdc
                        (index ++ "-short-name")
                        op.shortName
                        "Short Name"
                        ShortName
                        Nothing
                        []
                        []
                    , inputField lift
                        model.mdc
                        (index ++ "-color")
                        op.color
                        "Color"
                        Color
                        (Maybe.andThen .color model.errors)
                        [ colorRow [ cs "ntm-color-edit" ] op.color ]
                        []
                    , inputField lift
                        model.mdc
                        (index ++ "-email")
                        op.email
                        "E-mail"
                        Email
                        Nothing
                        []
                        []
                    ]
                , Dialog.actions []
                    [ Button.view (lift << EditMdc)
                        (index ++ "-button-cancel")
                        model.mdc
                        [ Button.ripple
                        , Dialog.cancel
                        , Options.onClick (lift Cancel)
                        ]
                        [ text "Cancel" ]
                    , Button.view (lift << EditMdc)
                        (index ++ "-button-accept")
                        model.mdc
                        [ Button.ripple
                        , Dialog.accept
                        , Options.onClick (lift Confirm)
                        ]
                        [ text "Save" ]
                    ]
                ]

        Nothing ->
            div [] []


mccMncHeader : (EditMsg m -> m) -> Index -> Edit m -> OperatorSuggestion -> Html m
mccMncHeader lift index model op =
    let
        extraParams =
            case model.mode of
                Create ->
                    []

                Update ->
                    [ TextField.disabled ]

        mccField =
            inputField lift
                model.mdc
                (index ++ "-mcc")
                op.mcc
                "MCC"
                Mcc
                (Maybe.andThen .mcc model.errors)
                []
                extraParams

        mncField =
            inputField lift
                model.mdc
                (index ++ "-mnc")
                op.mnc
                "MNC"
                Mnc
                (Maybe.andThen .mnc model.errors)
                []
                extraParams
    in
    styled div
        [ cs "operator-edit-content" ]
        [ styled div
            [ cs "operator-edit-mcc" ]
            [ mccField ]
        , styled div
            [ cs "operator-edit-mnc" ]
            [ mncField ]
        ]


inputField : (EditMsg m -> m) -> Material.Model m -> Index -> String -> String -> (String -> EditField) -> Maybe String -> List (Html m) -> List (TextField.Property m) -> Html m
inputField lift mdc index rawValue label message error innerHtml extraProperties =
    let
        isInvalid =
            Maybe.map (\_ -> TextField.invalid) error

        value =
            if String.isEmpty rawValue then
                Nothing

            else
                TextField.value rawValue |> Just

        attrs =
            Maybe.Extra.values [ isInvalid, value ]

        errorLabel =
            case error of
                Just string ->
                    TextField.helperLine []
                        [ TextField.helperText
                            [ TextField.persistent, TextField.validationMsg ]
                            [ text string
                            ]
                        ]

                Nothing ->
                    span [] []
    in
    styled div
        [ cs "text-field-container" ]
        [ TextField.view (lift << EditMdc)
            index
            mdc
            (attrs
                ++ extraProperties
                ++ [ TextField.label label
                   , Options.onInput (lift << Changed << message)
                   , TextField.nativeControl
                        [ Options.onBlur (lift (message rawValue |> Validate))
                        , Options.onFocus (lift (message rawValue |> ClearError))
                        ]
                   , TextField.outlined
                   , cs "operator-edit-property"
                   ]
            )
            innerHtml
        , errorLabel
        ]


colorRow : List (Property m c) -> String -> Html c
colorRow baseAttrs color =
    let
        attrs =
            if Util.Color.isHexColor color then
                [ cs "ntm-color", css "background" color ]

            else
                []
    in
    styled span (baseAttrs ++ attrs) []
