module Pages.Docs.UserAboutNtm exposing (title, view)

import Design.Html exposing (..)
import Drawer exposing (Page)
import Html exposing (Html, code, text)
import Material.Options exposing (styled)
import Material.Typography as Typography
import Pages.Docs.Table.Network as Network
import String


title : String
title =
    "NetMonster cell format"


view : Page m -> Html m
view page =
    page.body
        [ headline title
        , headlineDescription "Universal format for database import & export"
        , paragraph "NetMonster database format (suffix .ntm) originates from CSV format. Each entry occupies one line and values are separated by semicolon. One entry describes one base transmitter station's sector. Supported technologies are:"
        , bullets
            [ text "GSM (= 2G ... GPRS, EDGE)"
            , text "CDMA (= CD ... CDMA, EVDO)"
            , text "WCDMA (= 3G ... UMTS, HSDPA, HSUPA, HSPA, HSPA+, HSPA+42)"
            , text "LTE (= 4G ... LTE, LTE-A)"
            , text "NR (= 5G)"
            ]
        , paragraph "Since semicolon is used to separate one field from another hence Any usage of semicolon symbol is forbidden in text entries."
        , styled Html.blockquote [ Typography.body2 ] [ text "Bounds listed for each technology are not consistent with 3GPP specifications. Some restrictions are applied due to inconsistency across Android devices. In several cases lower bound is incremented by one and upper bound decremented (compared to 3GPP rules)." ]
        , paragraphHtml
            [ text "If any value is not known, an absolute value of"
            , codeInline "2^31-1"
            , text "=="
            , codeInline "2 147 483 647"
            , text "is used."
            ]
        , section "GSM"
        , codeBlock "2G;MCC;MNC;CID;LAC;XXX;BSIC;Lat;Lon;Location;ARFCN"
        , Network.table2g
        , section "WCDMA"
        , codeBlock "3G;MCC;MNC;CID;LAC;RNC;PSC;Lat;Lon;Location;UARFCN"
        , Network.table3g
        , section "LTE"
        , codeBlock "4G;MCC;MNC;CI;TAC;eNB;PCI;Lat;Lon;Location;EARFCN"
        , Network.table4g
        , section "NR"
        , codeBlock "5G;MCC;MNC;NCI;TAC;XXX;PCI;Lat;Lon;Location;ARFCN"
        , Network.table5g
        , section "CDMA"
        , codeBlock "CD;XX1;NID;BID;XX2;XX3;SID;Lat;Lon;Loc;XX4"
        , Network.tableCdma
        , section "Examples of real cells"
        , paragraph "And finally here's how it looks when you encode your data in NetMonster format."
        , codeBlock dataExamples
        ]


dataExamples : String
dataExamples =
    String.join "\n"
        [ "2G;230;04;8136;21800;60;25;50.087411;14.421265;Prague, pylon right in the middle of Old Town Square;60"
        , "3G;230;04;35796;21800;4011;211;50.087411;14.421265;Prague, pylon right in the middle of Old Town Square;10812"
        , "4G;230;04;13;21800;141311;270;50.087411;14.421265;Prague, pylon right in the middle of Old Town Square;6200"
        , "4G;230;04;113;21800;141311;228;50.087411;14.421265;Prague, pylon right in the middle of Old Town Square;449"
        , "5G;230;04;212737;21800;;752;50.087411;14.421265;Prague, pylon right in the middle of Old Town Square;151600"
        ]
