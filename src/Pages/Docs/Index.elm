module Pages.Docs.Index exposing (..)

import Design.Html exposing (bullets, divider, headline, headlineDescription, link, paragraph, section)
import Drawer exposing (Page)
import Html exposing (Html)
import Routing


title : String
title =
    "Documentation"


view : Page m -> Html m
view page =
    page.body
        [ headline title
        , headlineDescription "Searching for a help with NetMonster? You are on the right spot!"
        , divider
        , section "NetMonster user"
        , paragraph "Information useful for all NetMonster users"
        , bullets
            [ link Routing.DocsUserAbout "About NetMonster cell format (.ntm)"
            , link Routing.DocsUserSend "Send your cells to database"
            ]
        , divider
        , section "Database owner"
        , paragraph "If you have your database you can make it available for other users. Optionally you can also receive updates from them and update your database accordingly."
        , bullets
            [ link Routing.DocsOwnerPublish "Add database to NetMonster"
            , link Routing.DocsOwnerReceive "Receive updates from users"
            ]
        ]
