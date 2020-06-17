module Pages.Docs.Table.Network exposing (table2g, table3g, table4g, table5g, tableCdma)

import Html exposing (Html, text)
import Material.DataTable as DataTable exposing (numeric, tbody, td, tdNum, th, thead, tr, trh)
import Material.Options exposing (aria, css)


table2g : Html m
table2g =
    generateTable "2G"
        [ line "2G" "String" "Constant value"
        , mcc
        , mnc
        , boundedLine "CID" "int" "Cell identifier" "1" "65 534"
        , boundedLine "LAC" "int" "Location area code" "1" "65 534"
        , emptyLine "XXX" "Ignored for GSM"
        , boundedLine "BSIC" "int" "Base station identity code" "0" "1 030"
        , latitude
        , longitude
        , location
        , boundedLine "ARFCN" "int" "Radio frequency channel number" "0" "1 023"
        ]


table3g : Html m
table3g =
    generateTable "3G"
        [ line "3G" "String" "Constant value"
        , mcc
        , mnc
        , boundedLine "CID" "int" "Cell identifier" "1" "268 435 455"
        , boundedLine "LAC" "int" "Location area code" "1" "65 534"
        , boundedLine "RNC" "int" "Radio network controller" "1" "65 535"
        , boundedLine "PSC" "int" "Primary scrambling code" "0" "511"
        , latitude
        , longitude
        , location
        , boundedLine "ARFCN" "int" "Radio frequency channel number" "0" "1 023"
        ]


table4g : Html m
table4g =
    generateTable "4G"
        [ line "4G" "String" "Constant value"
        , mcc
        , mnc
        , boundedLine "CI" "int" "Cell identity" "1" "1 048 575"
        , boundedLine "TAC" "int" "Tracking area code" "1" "65 534"
        , boundedLine "eNb" "int" "Evolved node B" "0" "255"
        , boundedLine "PCI" "int" "Physical cell identifier" "0" "503"
        , latitude
        , longitude
        , location
        , boundedLine "EARFCN" "int" "Radio frequency channel number" "0" "2 147 483 646"
        ]


table5g : Html m
table5g =
    generateTable "5G"
        [ line "5G" "String" "Constant value"
        , mcc
        , mnc
        , boundedLine "NCI" "long" "Cell identity" "0" "68 719 476 735"
        , boundedLine "TAC" "int" "Tracking area code" "0" "65 535"
        , emptyLine "XXX" "Ignored for NR"
        , boundedLine "PCI" "int" "Physical cell identifier" "0" "1007"
        , latitude
        , longitude
        , location
        , boundedLine "ARFCN" "int" "Radio frequency channel number" "0" "2 016 666"
        ]


tableCdma : Html m
tableCdma =
    generateTable "CD"
        [ line "CD" "String" "Constant value"
        , emptyLine "XX1" "Ignored for CDMA"
        , boundedLine "NID" "int" "Network identifier" "0" "65 535"
        , boundedLine "BID" "int" "Base station identifier" "1" "2 147 483 646"
        , emptyLine "XX2" "Ignored for CDMA"
        , emptyLine "XX3" "Ignored for CDMA"
        , boundedLine "SID" "int" "System identifier" "0" "32 767"
        , latitude
        , longitude
        , location
        , emptyLine "XX4" "Ignored for CDMA"
        ]



-- ------------
-- Static items
-- ------------


mnc : Html m
mnc =
    boundedLine "MNC" "String" "Mobile network code" "01" "99"


mcc : Html m
mcc =
    boundedLine "MCC" "String" "Mobile country code" "100" "999"


latitude : Html m
latitude =
    boundedLine "Lat" "double" "Latitude - GPS coordinate" "-90.0" "90.0"


longitude : Html m
longitude =
    boundedLine "Lon" "double" "Longitude - GPS coordinate" "-180.0" "180.0"


location : Html m
location =
    line "Location" "String" "Your description of the location"



-- ------------
-- Some logic
-- ------------


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
        , th [ numeric ] [ text "Min" ]
        , th [ numeric ] [ text "Max" ]
        ]


boundedLine : String -> String -> String -> String -> String -> Html m
boundedLine name dataType description min max =
    tr []
        [ td [] [ text name ]
        , td [] [ text dataType ]
        , td [] [ text description ]
        , tdNum [] [ text min ]
        , tdNum [] [ text max ]
        ]


line : String -> String -> String -> Html m
line name dataType description =
    tr []
        [ td [] [ text name ]
        , td [] [ text dataType ]
        , td [] [ text description ]
        , td [] []
        , td [] []
        ]


emptyLine : String -> String -> Html m
emptyLine name description =
    tr []
        [ td [] [ text name ]
        , td [] []
        , td [] [ text description ]
        , td [] []
        , td [] []
        ]
