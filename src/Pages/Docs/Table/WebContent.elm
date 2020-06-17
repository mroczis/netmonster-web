module Pages.Docs.Table.WebContent exposing (..)

import Html exposing (Html, text)
import Material.DataTable as DataTable exposing (numeric, tbody, td, tdNum, th, thead, tr, trh)
import Material.Options exposing (aria, css, styled)


table : Html m
table =
    generateTable "Contributors"
        [ line "area" "String" "LAC, TAC"
        , line "caught" "String" "Last occurrence of the cell (ISO 8601 format)"
        , line "cid" "int" "CID (GSM), CI (UMTS), LCID (LTE), NCI (NR)"
        , line "code" "int" "BSIC, PSC, PCI"
        , line "frequency" "int" "ARFCN, UARFCN, EARFCN"
        , line "latitude" "int" "Latitude - GPS coordinate"
        , line "location" "String" "Description of location from user"
        , line "longitude" "double" "Longidute - GPS coordinate"
        , line "network" "Object" "Contains MCC, MNC"
        , line "technology" "String" "One of: GSM, UMTS, LTE, NR"
        ]


generateTable : String -> List (Html m) -> Html m
generateTable label lines =
    DataTable.view [ css "width" "100%" ]
        [ DataTable.table
            [ aria "label" label ]
            [ thead []
                [ header ]
            , tbody []
                lines
            ]
        ]


header : Html m
header =
    trh []
        [ th [] [ text "Parameter" ]
        , th [] [ text "Type" ]
        , th [] [ text "Comment" ]
        ]


line : String -> String -> String -> Html m
line parameter fieldType comment =
    tr []
        [ td [] [ text parameter ]
        , td [] [ text fieldType ]
        , td [] [ text comment ]
        ]
