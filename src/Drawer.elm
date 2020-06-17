module Drawer exposing
    ( Page
    , Transition(..)
    , componentCatalogPanel
    , getExternalItem
    , getItem
    , topAppBar
    , view
    )

import Array exposing (Array)
import Html exposing (Html, section, text)
import Html.Attributes as Html
import Material
import Material.Drawer.Modal as ModalDrawer
import Material.Drawer.Permanent as PermanentDrawer
import Material.List as Lists
import Material.Options as Options exposing (cs, css, styled, when)
import Material.TopAppBar as TopAppBar
import Routing exposing (Url)


type alias Page m =
    { navigate : Url -> m
    , body : List (Html m) -> Html m
    }


type Transition
    = None
    | Enter
    | Active
    | Done


view :
    (Material.Msg m -> m)
    -> Material.Model m
    -> m
    -> (Int -> m)
    -> (Int -> m)
    -> Url
    -> Bool
    -> Bool
    -> Html m
view lift mdc close select selectExternal currentUrl fixedDrawer open =
    let
        a ( title, url, icon ) =
            listItem title url currentUrl icon

        aExternal ( title, _, icon ) =
            externalListItem title icon

        divider =
            Lists.divider [] []

        regularItems =
            List.map a (Array.toList drawerItems) ++ [ divider ]

        externalLinks =
            List.map aExternal (Array.toList drawerItemsExternal)
    in
    (if fixedDrawer then
        PermanentDrawer.view

     else
        ModalDrawer.view
    )
        lift
        "page-drawer"
        mdc
        [ ModalDrawer.open |> when open
        , ModalDrawer.onClose close
        , css "z-index" "1" |> when fixedDrawer
        ]
        [ ModalDrawer.header
            [ cs "drawer-title" ]
            [ styled Html.img
                [ Options.attribute (Html.src "./media/web_logo.svg") ]
                []
            ]
        , ModalDrawer.content
            []
            [ Lists.nav lift
                "drawer-list"
                mdc
                [ Lists.singleSelection
                , Lists.useActivated
                , Lists.onSelectListItem select
                ]
                regularItems
            , Lists.subheader [] [ text "External links" ]
            , Lists.nav lift
                "drawer-list-external"
                mdc
                [ Lists.onSelectListItem selectExternal ]
                externalLinks
            ]
        ]


drawerItems : Array ( String, Url, String )
drawerItems =
    Array.fromList
        [ ( "Home", Routing.Index, "home" )
        , ( "Operators", Routing.Operators, "call" )
        , ( "Tools", Routing.Tools, "build" )
        , ( "Documentation", Routing.DocsIndex, "description" )
        ]


drawerItemsExternal : Array ( String, String, String )
drawerItemsExternal =
    Array.fromList
        [ ( "Download", "https://play.google.com/store/apps/details?id=cz.mroczis.netmonster", "./media/icon_download.svg" )
        , ( "NetMonster Core", "https://github.com/mroczis/netmonster-core", "./media/icon_core.svg" )
        , ( "Twitter", "https://twitter.com/NetMonsterApp", "./media/icon_twitter.svg" )
        , ( "E-mail", "mailto:hello@netmonster.app", "./media/icon_mail.svg" )
        ]


getItem : Int -> Maybe ( String, Url, String )
getItem index =
    Array.get index drawerItems


getExternalItem : Int -> Maybe ( String, String, String )
getExternalItem index =
    Array.get index drawerItemsExternal


componentCatalogPanel : Transition -> List (Html m) -> Html m
componentCatalogPanel transition nodes =
    styled section
        [ cs "component-catalog-panel"
        , cs "loadComponent-enter" |> when (transition == Enter || transition == Active)
        , cs "loadComponent-enter-active" |> when (transition == Active)
        , css "margin-top" "24px"
        , css "padding-bottom" "24px"
        ]
        nodes


listItem : String -> Url -> Url -> String -> Lists.ListItem m
listItem title url currentUrl icon =
    Lists.a
        [ Lists.activated |> when (Routing.isAssignable currentUrl url)
        ]
        [ Lists.graphicIcon [ cs "material-icons-outlined" ] icon
        , text title
        ]


externalListItem : String -> String -> Lists.ListItem m
externalListItem title icon =
    Lists.a
        []
        [ Lists.graphicImage [] icon
        , text title
        ]


topAppBar : (Material.Msg m -> m) -> Material.Model m -> m -> String -> Html m
topAppBar lift mdc cmd title =
    TopAppBar.view lift
        "page-topappbar"
        mdc
        []
        [ TopAppBar.section
            [ TopAppBar.alignStart ]
            [ TopAppBar.navigationIcon lift
                "my-menu"
                mdc
                [ Options.onClick cmd ]
                "menu"
            , TopAppBar.title []
                [ text title ]
            ]
        ]
