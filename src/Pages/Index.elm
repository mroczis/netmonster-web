module Pages.Index exposing (..)

import Design.Html exposing (bullets, divider, headline, headlineDescription, linkExternal, paragraph, paragraphHtml)
import Drawer exposing (Page)
import Html exposing (Html, text)


title : String
title =
    "Home"


view : Page m -> Html m
view page =
    page.body
        [ headline title
        , headlineDescription "NetMonster is Android network monitoring app which shows information about mobile networks."
        , divider
        , paragraph "It delivers all the data that your smartphone provides via Android SDK. It's free and without annoying adverts."
        , paragraphHtml
            [ text "NetMonster is partially open-source cause it's based on "
            , linkExternal "NetMonster Core" "https://github.com/mroczis/netmonster-core"
            , text ", library build over Android Telephony SDK."
            ]
        , paragraph "Main application functionalities:"
        , bullets
            [ text "logging of cells that your phone connects to,"
            , text "guessing transmitter's location based on publicly available data,"
            , text "manual editing of cells,"
            , text "postprocessing of logged data, bringing more data to neighbouring cells,"
            , text "downloading precise location data for transmitters in supported countries and regions,"
            , text "manual upload of your data to location managers."
            ]
        ]
