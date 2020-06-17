module Pages.Operators.View exposing (subscriptions, title, view)

import Design.Html exposing (..)
import Drawer exposing (Page)
import Html exposing (Attribute, Html, a, div, span, text)
import Html.Events exposing (onClick)
import Http.Model exposing (Operator, OperatorResponse)
import Material
import Material.Button as Button
import Material.DataTable as DataTable exposing (tbody, td, tdNum, th, thead, tr, trh)
import Material.Icon as Icon
import Material.Menu as Menu exposing (Menu)
import Material.Options as Options exposing (Property, aria, cs, css, styled, when)
import Material.Select as Select
import Material.Snackbar as Snackbar
import Material.TextField as TextField
import Material.Typography as Typography
import Maybe.Extra
import Pages.Operators.Model exposing (Edit, Model)
import Pages.Operators.ViewEdit exposing (alertDialog)
import Pages.Operators.ViewModel as VM exposing (EditMsg(..), Msg(..))
import Util.Countries as Countries exposing (Country)
import Util.Maybe


title : String
title =
    "Operators"


view : (Msg m -> m) -> Model m -> (EditMsg m -> m) -> Edit m -> Page m -> Html m
view lift model liftEdit modelEdit page =
    let
        operators =
            case model.data of
                Just content ->
                    content.data

                Nothing ->
                    []

        htmlOperators =
            List.map (\op -> line op liftEdit) operators
    in
    page.body
        [ headline title
        , headlineDescription "List of carriers and their names used in NetMonster"
        , divider
        , paragraphHtml
            [ text "Each country has multiple operators."
            , codeInline "PLMN"
            , text " is an identifier of each. It consists of "
            , codeInline "MCC"
            , text " (mobile country code) and "
            , codeInline "MNC"
            , text " (mobile network code)."
            ]
        , paragraphHtml
            [ text "In case there's exising "
            , codeInline "PLMN"
            , text " and it's not here then feel free to "
            , a [ onClick (liftEdit StartCreate) ] [ text "suggest an addition" ]
            , text "."
            ]
        , filters lift model
        , generateTable "Operators" htmlOperators
        , pagination lift model
        , alertDialog liftEdit modelEdit
        , Snackbar.view (liftEdit << EditMdc)
            "snackbar-error"
            modelEdit.mdc
            [ Snackbar.dismissible ]
            []
        ]


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << Mdc) model


filters : (Msg m -> m) -> Model m -> Html m
filters lift model =
    styled div
        [ cs "operator-content" ]
        [ styled div [ cs "operator-country" ] [ countryMenu lift model ]
        , styled div
            [ cs "operator-search" ]
            [ TextField.view (lift << Mdc)
                "operator-name-filter"
                model.mdc
                [ TextField.label "Search"
                , Options.onInput (lift << NameChanged)
                , TextField.outlined
                ]
                []
            ]
        ]


pagination : (Msg m -> m) -> Model m -> Html m
pagination lift model =
    let
        first =
            Maybe.map (\x -> x.offset + 1) model.data |> Maybe.withDefault 0 |> String.fromInt

        last =
            Maybe.map (\x -> min (x.offset + x.limit) x.size) model.data |> Maybe.withDefault 0 |> String.fromInt

        size =
            Maybe.map (\x -> x.size) model.data

        paginationText =
            case size of
                Just number ->
                    first ++ " – " ++ last ++ " of " ++ String.fromInt number

                Nothing ->
                    ""
    in
    styled div
        [ cs "operator-pagination" ]
        [ prevButton lift model
        , styled Html.p [ Typography.caption ] [ text paginationText ]
        , nextButton lift model
        ]



--
-- Buttons
--


nextButton : (Msg m -> m) -> Model m -> Html m
nextButton lift model =
    let
        size =
            Maybe.map (\x -> x.size) model.data |> Maybe.withDefault 0

        disabled =
            model.offset + model.limit >= size

        disabledFlag =
            Util.Maybe.ifTrue disabled Button.disabled
    in
    Button.view (lift << Mdc)
        "button-next"
        model.mdc
        (Maybe.Extra.cons disabledFlag
            [ Button.ripple
            , Button.outlined
            , cs "operator-next"
            , Button.trailingIcon "navigate_next"
            , Button.onClick (lift VM.NextPage)
            ]
        )
        [ text "Next" ]


prevButton : (Msg m -> m) -> Model m -> Html m
prevButton lift model =
    let
        disabledFlag =
            Util.Maybe.ifTrue (model.offset <= 0) Button.disabled
    in
    Button.view (lift << Mdc)
        "button-prev"
        model.mdc
        (Maybe.Extra.cons disabledFlag
            [ Button.ripple
            , Button.outlined
            , cs "operator-previous"
            , Button.icon "navigate_before"
            , Button.onClick (lift VM.PreviousPage)
            ]
        )
        [ text "Previous" ]



--
-- Menu
--


countryMenu : (Msg m -> m) -> Model m -> Html m
countryMenu lift model =
    let
        items =
            List.map (countryItem selected) Countries.allWithNone

        selected =
            Countries.fromCodeOrNone model.country
    in
    Select.view (lift << Mdc)
        "selected-country"
        model.mdc
        [ Select.label "Country"
        , Select.selectedText (Countries.nameWithFlag selected)
        , Select.outlined
        , Select.onSelect (CountryChanged >> lift)
        ]
        items


countryItem : Country -> Country -> Menu.Item m
countryItem selected country =
    Select.option
        [ Select.value (country.code |> Maybe.withDefault "")
        , Select.selected |> when (selected.code == country.code)
        ]
        [ text (Countries.nameWithFlag country) ]



--
-- Table
--


generateTable : String -> List (Html m) -> Html m
generateTable label lines =
    DataTable.view [ css "width" "100%" ]
        [ DataTable.table
            [ aria "label" label, cs "operators-table" ]
            [ thead []
                [ header ]
            , tbody []
                lines
            ]
        ]


header : Html m
header =
    trh []
        [ th [ cs "operator-column-country" ] [ text "Country" ]
        , th [ cs "operator-column-plmn" ] [ text "PLMN" ]
        , th [ cs "operator-column-carrier" ] [ text "Carrier name" ]
        , th [ cs "operator-column-short" ] [ text "Short name" ]
        , th [ cs "operator-column-color" ] [ text "Color" ]
        ]


line : Operator -> (EditMsg m -> m) -> Html m
line operator lift =
    tr [ Options.onClick <| lift <| StartEdit operator ]
        [ td [] [ countryRow operator ]
        , td [] [ text <| plmnRow operator ]
        , td [] [ text operator.name ]
        , td [] [ text operator.shortName ]
        , tdNum [] [ colorRow operator.color ]
        ]


countryRow : Operator -> Html m
countryRow operator =
    let
        country =
            (Countries.fromCode <| String.toUpper operator.iso) |> Maybe.withDefault Countries.unknown
    in
    styled div
        [ cs "operator-row-name" ]
        [ styled span [ cs "operator-row-edit" ] [ Icon.view [ cs "material-icons-outlined", Icon.size18 ] "edit" ]
        , styled span [ cs "operator-row-flag" ] [ text country.flag ]
        , text country.name
        ]


plmnRow : Operator -> String
plmnRow operator =
    let
        paddedMnc =
            String.padLeft 2 '0' operator.mnc
    in
    operator.mcc ++ " " ++ paddedMnc


colorRow : String -> Html c
colorRow color =
    let
        attrs =
            if String.isEmpty color then
                [ cs "ntm-color", cs "ntm-color-undefined" ]

            else
                [ cs "ntm-color", css "background" color ]
    in
    styled span attrs []
