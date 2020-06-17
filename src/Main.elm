module Main exposing (..)

import Browser
import Browser.Dom
import Browser.Events
import Browser.Navigation
import Drawer
import FormatNumber.Locales exposing (Locale, fromString)
import Html exposing (Html, div, text)
import Material
import Material.Options exposing (cs, css, styled)
import Maybe
import Pages.Docs.Index
import Pages.Docs.OwnerPublish
import Pages.Docs.OwnerReceive
import Pages.Docs.UserAboutNtm
import Pages.Docs.UserSend
import Pages.Index
import Pages.NotFound
import Pages.Operators.Model
import Pages.Operators.View
import Pages.Operators.ViewEdit
import Pages.Operators.ViewModel
import Pages.Tools.Index
import Pages.Tools.Model
import Pages.Tools.ViewModel
import Routing
import Task
import Url


type alias Model =
    { mdc : Material.Model Msg
    , key : Browser.Navigation.Key
    , url : Routing.Url
    , useFixedDrawer : Bool
    , isDrawerOpen : Bool
    , navigateToUrl : Maybe Routing.Url
    , transition : Drawer.Transition
    , operators : Pages.Operators.Model.Model Msg
    , operatorEdit : Pages.Operators.Model.Edit Msg
    , tools : Pages.Tools.Model.Model Msg
    , locale : Locale
    }


defaultModel : Browser.Navigation.Key -> Model
defaultModel key =
    let
        locale =
            fromString "424242"

        separatorLocale =
            if locale.thousandSeparator == "" then
                { locale | thousandSeparator = " " }

            else
                locale
    in
    { mdc = Material.defaultModel
    , key = key
    , url = Routing.Index
    , useFixedDrawer = True
    , isDrawerOpen = False
    , navigateToUrl = Nothing
    , transition = Drawer.None
    , operators = Pages.Operators.Model.default
    , operatorEdit = Pages.Operators.Model.defaultEdit
    , tools = Pages.Tools.Model.default
    , locale = separatorLocale
    }


type Msg
    = Mdc (Material.Msg Msg)
    | GotViewportWidth Browser.Dom.Viewport
    | WindowResized Int Int
    | UrlChanged Url.Url
    | UrlRequested Browser.UrlRequest
    | Navigate Routing.Url
    | AnimationTick Float
    | DrawerOpen
    | DrawerClose
    | DrawerToggle
    | DrawerItemClick Int
    | DrawerExternalItemClick Int
    | OperatorMsg (Pages.Operators.ViewModel.Msg Msg)
    | OperatorEditMsg (Pages.Operators.ViewModel.EditMsg Msg)
    | ToolsMsg (Pages.Tools.ViewModel.Msg Msg)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        initialModel =
            defaultModel key
    in
    ( { initialModel | url = Routing.fromUrl url }
    , Cmd.batch
        [ Material.init Mdc
        , Task.perform GotViewportWidth Browser.Dom.getViewport
        , Pages.Operators.ViewModel.getOperators OperatorMsg initialModel.operators
        ]
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Material.subscriptions Mdc model
        , Browser.Events.onResize WindowResized
        , if model.navigateToUrl == Nothing then
            Sub.none

          else
            Browser.Events.onAnimationFrameDelta AnimationTick
        , Pages.Operators.View.subscriptions OperatorMsg model.operators
        , Pages.Tools.Index.subscriptions ToolsMsg model.tools
        , Pages.Operators.ViewEdit.subscriptions OperatorEditMsg model.operatorEdit
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        useFixedDrawer x =
            x > 900
    in
    case msg of
        Mdc msg_ ->
            Material.update Mdc msg_ model

        GotViewportWidth viewport ->
            ( { model | useFixedDrawer = useFixedDrawer viewport.scene.width }, Cmd.none )

        WindowResized x _ ->
            ( { model | useFixedDrawer = useFixedDrawer x }, Cmd.none )

        UrlChanged url ->
            ( { model | url = Routing.fromUrl url }, Cmd.none )

        UrlRequested (Browser.Internal url) ->
            ( { model | url = Routing.fromUrl url, isDrawerOpen = False }
            , Browser.Navigation.load (Routing.toString (Routing.fromUrl url))
            )

        UrlRequested (Browser.External url) ->
            if url /= "" then
                ( model, Browser.Navigation.load url )

            else
                ( model, Cmd.none )

        DrawerOpen ->
            ( { model | isDrawerOpen = True }, Cmd.none )

        DrawerClose ->
            ( { model | isDrawerOpen = False }, Cmd.none )

        DrawerToggle ->
            ( { model | isDrawerOpen = not model.isDrawerOpen }, Cmd.none )

        DrawerItemClick index ->
            let
                item =
                    Drawer.getItem index
            in
            case item of
                Just ( _, url, _ ) ->
                    ( { model | navigateToUrl = Just url, transition = Drawer.Enter }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        DrawerExternalItemClick index ->
            let
                item =
                    Drawer.getExternalItem index
            in
            case item of
                Just ( _, url, _ ) ->
                    ( model, Browser.Navigation.load url )

                Nothing ->
                    ( model, Cmd.none )

        Navigate url ->
            ( { model
                | url = url
                , isDrawerOpen =
                    if not model.useFixedDrawer then
                        False

                    else
                        model.isDrawerOpen
                , transition =
                    if model.navigateToUrl /= Nothing then
                        Drawer.Active

                    else
                        Drawer.None
                , navigateToUrl = Nothing
              }
            , Cmd.batch
                [ Browser.Navigation.pushUrl model.key (Routing.toString url) ]
            )

        AnimationTick _ ->
            case model.navigateToUrl of
                Just url ->
                    update (Navigate url) model

                Nothing ->
                    ( model, Cmd.none )

        OperatorMsg msg_ ->
            let
                ( operators, effects ) =
                    Pages.Operators.ViewModel.update OperatorMsg msg_ model.operators
            in
            ( { model | operators = operators }, effects )

        OperatorEditMsg msg_ ->
            let
                ( edit, effects ) =
                    Pages.Operators.ViewModel.updateEdit OperatorEditMsg msg_ model.operatorEdit
            in
            ( { model | operatorEdit = edit }, effects )

        ToolsMsg msg_ ->
            let
                ( edit, effects ) =
                    Pages.Tools.ViewModel.update ToolsMsg msg_ model.tools
            in
            ( { model | tools = edit }, effects )

view : Model -> Browser.Document Msg
view model =
    { title = title model
    , body = [ body model ]
    }


title : Model -> String
title model =
    case model.url of
        Routing.Index ->
            Pages.Index.title

        Routing.DocsIndex ->
            Pages.Docs.Index.title

        Routing.DocsUserAbout ->
            Pages.Docs.UserAboutNtm.title

        Routing.DocsOwnerPublish ->
            Pages.Docs.OwnerPublish.title

        Routing.DocsOwnerReceive ->
            Pages.Docs.OwnerReceive.title

        Routing.DocsUserSend ->
            Pages.Docs.UserSend.title

        Routing.Operators ->
            Pages.Operators.View.title

        Routing.Tools ->
            Pages.Tools.Index.title

        _ ->
            "NetMonster"


body : Model -> Html Msg
body model =
    let
        drawer =
            Drawer.view Mdc model.mdc DrawerClose DrawerItemClick DrawerExternalItemClick model.url model.useFixedDrawer model.isDrawerOpen

        topAppBar =
            if model.useFixedDrawer then
                text ""

            else
                Drawer.topAppBar Mdc model.mdc DrawerOpen "NetMonster"

        page =
            { navigate = Navigate
            , body =
                \nodes ->
                    styled div
                        [ css "display" "flex"
                        , css "flex-flow" "column"
                        , css "height" "100%"
                        ]
                        [ styled div
                            [ cs "web-panel" ]
                            [ drawer
                            , styled div
                                [ cs "web-content" ]
                                [ topAppBar
                                , styled div
                                    [ cs "web-content-transition"
                                    , cs "inner-content"
                                    ]
                                    [ Drawer.componentCatalogPanel model.transition nodes ]
                                ]
                            ]
                        ]
            }
    in
    case model.url of
        Routing.Index ->
            Pages.Index.view page

        Routing.DocsIndex ->
            Pages.Docs.Index.view page

        Routing.DocsUserAbout ->
            Pages.Docs.UserAboutNtm.view page

        Routing.DocsUserSend ->
            Pages.Docs.UserSend.view page

        Routing.DocsOwnerPublish ->
            Pages.Docs.OwnerPublish.view page

        Routing.DocsOwnerReceive ->
            Pages.Docs.OwnerReceive.view page

        Routing.Operators ->
            Pages.Operators.View.view OperatorMsg model.operators OperatorEditMsg model.operatorEdit page

        Routing.Tools ->
            Pages.Tools.Index.view ToolsMsg model.tools page

        _ ->
            Pages.NotFound.view page
