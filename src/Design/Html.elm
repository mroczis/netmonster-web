module Design.Html exposing (..)

import Html exposing (Html, a, code, text)
import Html.Attributes exposing (href, target)
import Material.Options exposing (cs, styled)
import Material.Typography as Typography
import Routing exposing (toString)


headline : String -> Html m
headline content =
    styled Html.h2 [ Typography.headline2 ] [ text content ]


headlineDescription : String -> Html m
headlineDescription content =
    styled Html.p [ Typography.body1, cs "mdc-typography--body1--header" ] [ text content ]


section : String -> Html m
section content =
    styled Html.h3 [ Typography.headline3 ] [ text content ]


codeInline : String -> Html m
codeInline content =
    code [] [ text content ]


codeBlock : String -> Html m
codeBlock content =
    styled Html.pre
        []
        [ styled Html.code [ cs "code-in-pre" ] [ text content ]
        ]


paragraph : String -> Html m
paragraph content =
    paragraphHtml [ text content ]


paragraphHtml : List (Html m) -> Html m
paragraphHtml html =
    styled Html.p [ Typography.body2 ] html


link : Routing.Url -> String -> Html m
link routingUrl content =
    a [ href (toString routingUrl) ] [ text content ]


linkExternal : String -> String -> Html m
linkExternal name path =
    a [ href path, target "_blank" ] [ text name ]


bullets : List (Html m) -> Html m
bullets list =
    let
        items =
            List.map (\html -> styled Html.li [ Typography.body2 ] [ html ]) list
    in
    Html.ul [] items


numbers : List (Html m) -> Html m
numbers list =
    let
        items =
            List.map (\html -> styled Html.li [ Typography.body2 ] [ html ]) list
    in
    Html.ol [] items

divider : Html m
divider =
    Html.hr [] []