module Lte exposing
    ( fromCidTests
    , fromEciTests
    , fromEnbTests
    )

import Expect
import Pages.Tools.Calculation.Lte exposing (Model, fromCid, fromEci, fromEnb)
import Test exposing (Test, describe, test)


default : Model
default =
    { eci = Nothing, cid = Nothing, enb = Nothing }


valid : Model
valid =
    { eci = Just 123415387, enb = Just 482091, cid = Just 91 }


fromEciTests : Test
fromEciTests =
    describe "CI -> CID, RNC"
        [ test "123415387" <|
            \_ -> fromEci default "123415387" |> Expect.equal valid
        , test "179" <|
            \_ ->
                fromEci default "179"
                    |> Expect.equal
                        { eci = Just 179
                        , enb = Just 0
                        , cid = Just 179
                        }
        , test "256" <|
            \_ ->
                fromEci default "256"
                    |> Expect.equal
                        { eci = Just 256
                        , enb = Just 1
                        , cid = Just 0
                        }
        , test "-1" <|
            \_ -> fromEci default "-1" |> Expect.equal default
        , test "香蕉" <|
            \_ -> fromEci default "香蕉" |> Expect.equal default
        , test "🍵" <|
            \_ -> fromEci default "🍵" |> Expect.equal default
        , test "Remove everything when CI is empty" <|
            \_ -> fromEci valid "" |> Expect.equal default
        , test "CI overflow" <|
            \_ ->
                fromEci valid "99999999999" |> Expect.equal valid
        ]


fromEnbTests : Test
fromEnbTests =
    describe "eNb -> CI, CID"
        [ test "eNb 1, no CID" <|
            \_ ->
                fromEnb default "1"
                    |> Expect.equal
                        { eci = Nothing
                        , enb = Just 1
                        , cid = Nothing
                        }
        , test "eNb 1, CID 1" <|
            \_ ->
                fromEnb { default | cid = Just 1 } "1"
                    |> Expect.equal
                        { eci = Just 257
                        , enb = Just 1
                        , cid = Just 1
                        }
        , test "Remove CI when eNb is no longer valid" <|
            \_ ->
                fromEnb valid "" |> Expect.equal { valid | enb = Nothing, eci = Nothing }
        , test "eNb overflow" <|
            \_ ->
                fromEnb valid "99999999999" |> Expect.equal valid
        ]


fromCidTests : Test
fromCidTests =
    describe "CID -> CI, eNb"
        [ test "CID 1, no eNb" <|
            \_ ->
                fromCid default "1"
                    |> Expect.equal
                        { eci = Nothing
                        , enb = Nothing
                        , cid = Just 1
                        }
        , test "CID 1, eNb 1" <|
            \_ ->
                fromCid { default | enb = Just 1 } "1"
                    |> Expect.equal
                        { eci = Just 257
                        , enb = Just 1
                        , cid = Just 1
                        }
        , test "Remove CI when CID is no longer valid" <|
            \_ ->
                fromCid valid "" |> Expect.equal { valid | eci = Nothing, cid = Nothing }
        , test "CID overflow" <|
            \_ ->
                fromCid valid "99999999999" |> Expect.equal valid
        ]
