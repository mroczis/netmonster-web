module Pages.NotFound exposing (title, view)

import Design.Html exposing (headline, headlineDescription, linkExternal, paragraphHtml)
import Drawer exposing (Page)
import Html exposing (Html, text)


title : String
title =
    "Not found 🙀️"


view : Page m -> Html m
view page =
    page.body
        [ headline title
        , headlineDescription "This page does not exist. To get out of this tricky situation select something from the menu on the left side."
        , paragraphHtml
            [ text "Or you can watch a video of "
            , linkExternal "a shopkeeper cat" "https://www.youtube.com/watch?v=7PoTf1QFHpo"
            , text " it's totally up to you. Meow."
            ]
        ]
