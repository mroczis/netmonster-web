module Pages.Docs.OwnerReceive exposing (title, view)

import Design.Html exposing (..)
import Drawer exposing (Page)
import Html exposing (Html, text)
import Pages.Docs.Table.WebContent as WebContent
import Routing
import String


title : String
title =
    "Receive updates"


view : Page m -> Html m
view page =
    page.body
        [ headline title
        , headlineDescription "Get new cells directly from other users"
        , paragraphHtml
            [ text "NetMonster has an ability to send you selected cells from users. This process is not automatic and must be always confirmed by user. After that a "
            , codeInline "POST"
            , text " request is made to your server with body which looks like this:"
            ]
        , codeBlock codeExample
        , paragraph "Array of cells contains these parameters:"
        , WebContent.table
        , paragraphHtml
            [ text "For more information about bounds of each value head to "
            , link Routing.DocsUserAbout "NetMonster format"
            , text " page."
            ]
        , section "Opt in"
        , paragraph "If you want to receive updates from NetMonster users, you must implement a public endpoint which will accept following JSON object. After that feel free to contact me!"
        ]


codeExample : String
codeExample =
    """{
   "cells":[
      {
         "area":29510,
         "caught":"2018-03-21T23:27:56Z",
         "cid":44041,
         "code":2147483647,
         "frequency":2147483647,
         "latitude":49.467547,
         "location":"VS Rožnov pod Radhoštěm, 5. května 1556, panelák",
         "longituide":18.138875,
         "network":{
            "mcc":230,
            "mnc":1
         },
         "technology":"GSM"
      },
      {
         "area":31055,
         "caught":"2018-03-23T16:25:21Z",
         "cid":1060353,
         "code":27,
         "frequency":449,
         "latitude":49.467342,
         "location":"VS Rožnov pod Radhoštěm, Horská 1731, panelák",
         "longituide":18.137336,
         "network":{
            "mcc":230,
            "mnc":3
         },
         "technology":"LTE"
      },
      {
         "area":29510,
         "caught":"2018-03-22T13:24:37Z",
         "cid":242606150,
         "code":259,
         "frequency":10787,
         "latitude":49.466908,
         "location":"VS Rožnov pod Radhoštěm, Horská 1732, panelák",
         "longituide":18.137264,
         "network":{
            "mcc":230,
            "mnc":1
         },
         "technology":"UMTS"
      }
   ],
   "size":3,
   "date":"2018-03-26T20:31:37Z",
   "author":"Name that was filled by the sender",
   "contact":"Optional way to reach sender",
   "comment":"Optional comment by the sender",
   "manufacturer":"Google",
   "model":"Pixel 9 XL"
}"""
