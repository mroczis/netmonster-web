module Pages.Docs.OwnerPublish exposing (title, view)

import Design.Html exposing (..)
import Drawer exposing (Page)
import Html exposing (Html, text)
import String


title : String
title =
    "Publish database"


view : Page m -> Html m
view page =
    page.body
        [ headline title
        , headlineDescription "When you already have database that covers certain area."
        , paragraph "Do you already have database? Manual importing every time really grinds your gears? You are in the right section."
        , section "Two steps"
        , numbers
            [ text "Place your database somewhere on the internet and update it periodically."
            , text "Contact me. Send me information about your database and where it's located."
            ]
        , paragraph "There are no limits when it comes to format of your database. However, NetMonster format is strongly recommended"
        , paragraph "Once integration is done, NetMonster will automatically check if new data are available and offer update to all users who imported it."
        ]
