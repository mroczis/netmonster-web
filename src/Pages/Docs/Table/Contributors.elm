module Pages.Docs.Table.Contributors exposing (table)

import Design.Html exposing (linkExternal)
import Html exposing (Html, text)
import Material.DataTable as DataTable exposing (numeric, tbody, td, tdNum, th, thead, tr, trh)
import Material.Options exposing (aria, css, styled)


table : Html m
table =
    generateTable "Contributors"
        [ line "230" "01" "🇨🇿 Czechia" "T-Mobile" "GSMWeb" "http://gsmweb.cz"
        , line "230" "02" "🇨🇿 Czechia" "O2" "GSMWeb" "http://gsmweb.cz"
        , line "230" "03" "🇨🇿 Czechia" "Vodafone" "GSMWeb" "http://gsmweb.cz"
        , line "230" "06" "🇨🇿 Czechia" "Nordic" "GSMWeb" "http://gsmweb.cz"
        , line "262" "03" "🇩🇪 Germany" "O2" "Weretis" "https://weretis.de"
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
        [ th [] [ text "MNC" ]
        , th [] [ text "MCC" ]
        , th [] [ text "Country" ]
        , th [] [ text "Operator" ]
        , th [] [ text "Source" ]
        ]


line : String -> String -> String -> String -> String -> String -> Html m
line mcc mnc country operator source sourceLink =
    tr []
        [ td [] [ text mcc ]
        , td [] [ text mnc ]
        , td [] [ text country ]
        , td [] [ text operator ]
        , td [] [ linkExternal source sourceLink ]
        ]
