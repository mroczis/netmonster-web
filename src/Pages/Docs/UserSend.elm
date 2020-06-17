module Pages.Docs.UserSend exposing (title, view)

import Design.Html exposing (..)
import Drawer exposing (Page)
import Html exposing (Html, text)
import Pages.Docs.Table.Contributors as Contributors
import Routing
import String


title : String
title =
    "Share cells"


view : Page m -> Html m
view page =
    page.body
        [ headline title
        , headlineDescription "A convenient way how to contribute to public databases"
        , paragraph "If you are lucky enough you may become a hunter, cell hunter! What does it actually mean? Well, some people gather information about transmitters all over their home country and you may help them improve the data."
        , section "How does it work?"
        , paragraph "It's really simple. Just keep NetMonster on and cell collection will begin automatically. Once you think that you found a new cell, you may send it to database."
        , numbers
            [ text "Go to log screen."
            , text "Tap filter icon."
            , text "Select 'Conflicted' option."
            , text "If there are cells in a log which might be sent to central database a share button will appear on the bottom-right side. Hit it!"
            , text "Select cells you want to share and press send button."
            , text "Fill your nickname and optionally way to reach you or add comment and confirm your request."
            , text "You made it! Thanks for sharing ^_^"
            ]
        , section "Contributors"
        , paragraph "Here's a small table which contains all databases that support sharing directly from NetMonster."
        , Contributors.table
        , paragraphHtml
            [ text "If you already have a database and want users of NetMonster to share their prey with you, head to "
            , link Routing.DocsOwnerReceive "receive updates"
            , text " section."
            ]
        ]
