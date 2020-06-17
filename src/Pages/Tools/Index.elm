module Pages.Tools.Index exposing (subscriptions, title, view)

import Design.Html exposing (codeBlock, codeInline, divider, headline, headlineDescription, paragraph, paragraphHtml, section)
import Drawer exposing (Page)
import Html exposing (Html, div, text)
import Material
import Material.Options as Options exposing (cs, styled)
import Material.TextField as TextField
import Pages.Tools.Calculation.Lte as Lte exposing (Msg(..))
import Pages.Tools.Calculation.Wcdma as Wcdma exposing (Msg(..))
import Pages.Tools.Model exposing (Model)
import Pages.Tools.ViewModel as VM exposing (Msg(..))


title : String
title =
    "Tools"


subscriptions : (VM.Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << Mdc) model


view : (VM.Msg m -> m) -> Model m -> Page m -> Html m
view lift model page =
    page.body
        [ headline title
        , headlineDescription "List of useful tools to help you better understand data your phone shows"
        , divider
        , section "WCDMA Cell identity"
        , paragraphHtml
            [ text "Each WCDMA cell has it's own unique UTRAN cell identifier. In most of the cases this number is unique and can be transformed into "
            , codeInline "CID"
            , text " and "
            , codeInline "RNC"
            , text ". Numbers are positive, maximal "
            , codeInline "CID"
            , text " is "
            , codeInline "65535"
            , text ", maximal RNC is "
            , codeInline "4095"
            , text "."
            ]
        , paragraph "Following formula describes how to construct cell identity from both of them:"
        , codeBlock "CI = 65536 * RNC + CID"
        , paragraph "Enter or edit one of values to calculate the rest."
        , styled div
            [ cs "three-columns" ]
            [ styled div
                [ cs "three-columns-one" ]
                [ TextField.view (lift << Mdc)
                    "field-wcdma-ci"
                    model.mdc
                    [ TextField.label "CI"
                    , Options.onInput (lift << VM.Wcdma << Wcdma.Ci)
                    , TextField.outlined
                    , TextField.value (Maybe.map String.fromInt model.wcdma.ci |> Maybe.withDefault "")
                    ]
                    []
                ]
            , styled div
                [ cs "three-columns-two" ]
                [ TextField.view (lift << Mdc)
                    "field-wcdma-cid"
                    model.mdc
                    [ TextField.label "CID"
                    , Options.onInput (lift << VM.Wcdma << Wcdma.Cid)
                    , TextField.outlined
                    , TextField.value (Maybe.map String.fromInt model.wcdma.cid |> Maybe.withDefault "")
                    ]
                    []
                ]
            , styled div
                [ cs "three-columns-three" ]
                [ TextField.view (lift << Mdc)
                    "field-wcdma-rnc"
                    model.mdc
                    [ TextField.label "RNC"
                    , Options.onInput (lift << VM.Wcdma << Wcdma.Rnc)
                    , TextField.outlined
                    , TextField.value (Maybe.map String.fromInt model.wcdma.rnc |> Maybe.withDefault "")
                    ]
                    []
                ]
            ]
        , divider
        , section "LTE Cell identity"
        , paragraphHtml
            [ text "Similarly as for WCDMA we can divide LTE's E-UTRAN cell identifier into two separate numbers "
            , codeInline "CID"
            , text " and "
            , codeInline "eNB"
            , text ". Both are also positive, maximal "
            , codeInline "CID"
            , text " is "
            , codeInline "1048575"
            , text ", maximal eNb is "
            , codeInline "255"
            , text "."
            ]
        , paragraph "Following formula describes how to construct cell identity from both of them:"
        , codeBlock "ECI = 256 * eNB + CID"
        , paragraph "Enter or edit one of values to calculate the rest."
        , styled div
            [ cs "three-columns" ]
            [ styled div
                [ cs "three-columns-one" ]
                [ TextField.view (lift << Mdc)
                    "field-lte-eci"
                    model.mdc
                    [ TextField.label "ECI"
                    , Options.onInput (lift << VM.Lte << Lte.Eci)
                    , TextField.outlined
                    , TextField.value (Maybe.map String.fromInt model.lte.eci |> Maybe.withDefault "")
                    ]
                    []
                ]
            , styled div
                [ cs "three-columns-two" ]
                [ TextField.view (lift << Mdc)
                    "field-lte-enb"
                    model.mdc
                    [ TextField.label "eNB"
                    , Options.onInput (lift << VM.Lte << Lte.Enb)
                    , TextField.outlined
                    , TextField.value (Maybe.map String.fromInt model.lte.enb |> Maybe.withDefault "")
                    ]
                    []
                ]
            , styled div
                [ cs "three-columns-three" ]
                [ TextField.view (lift << Mdc)
                    "field-lte-cid"
                    model.mdc
                    [ TextField.label "CID"
                    , Options.onInput (lift << VM.Lte << Lte.Cid)
                    , TextField.outlined
                    , TextField.value (Maybe.map String.fromInt model.lte.cid |> Maybe.withDefault "")
                    ]
                    []
                ]
            ]
        ]
