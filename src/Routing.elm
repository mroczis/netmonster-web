module Routing exposing
    ( Url(..)
    , fromString
    , fromUrl
    , isAssignable
    , toString
    )

import Url


type Url
    = Index
    | Operators
    | Tools
    | Bands
    | DocsIndex
    | DocsUserAbout
    | DocsUserSend
    | DocsOwnerPublish
    | DocsOwnerReceive
    | Error404 String


toString : Url -> String
toString url =
    case url of
        Index ->
            "#"

        Operators ->
            "#operators"

        Tools ->
            "#tools"

        Bands ->
            "#bands"

        DocsIndex ->
            "#docs"

        DocsUserAbout ->
            "#docs-user-about-ntm"

        DocsUserSend ->
            "#docs-user-send"

        DocsOwnerPublish ->
            "#docs-owner-publish"

        DocsOwnerReceive ->
            "#docs-owner-receive"

        Error404 path ->
            path


fromUrl : Url.Url -> Url
fromUrl url =
    fromString (Maybe.withDefault "" url.fragment)


fromString : String -> Url
fromString url =
    case url of
        "" ->
            Index

        "operators" ->
            Operators

        "tools" ->
            Tools

        "bands" ->
            Bands

        "docs" ->
            DocsIndex

        "docs-user-about-ntm" ->
            DocsUserAbout

        "docs-user-send" ->
            DocsUserSend

        "docs-owner-publish" ->
            DocsOwnerPublish

        "docs-owner-receive" ->
            DocsOwnerReceive

        _ ->
            Error404 url


{-| Checks if one URL can be marked as another.
This is used to highlight proper item in navigation drawer -> when user goes deeper
in navigation. Hence sub-paths always start with same prefix (example: 'docs')
-}
isAssignable : Url -> Url -> Bool
isAssignable which what =
    let
        whichClear =
            String.dropLeft 1 (toString which)

        whatClear =
            String.dropLeft 1 (toString what)
    in
    whatClear == whichClear || (not (String.isEmpty whatClear) && String.contains whatClear whichClear)
