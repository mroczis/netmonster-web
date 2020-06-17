module Wcdma exposing
    ( fromCiTests
    , fromCidTests
    , fromRncTests
    )

import Expect
import Pages.Tools.Calculation.Wcdma exposing (Model, fromCi, fromCid, fromRnc)
import Test exposing (Test, describe, test)


default : Model
default =
    { ci = Nothing, cid = Nothing, rnc = Nothing }


valid : Model
valid =
    { ci = Just 262904025, rnc = Just 4011, cid = Just 39129 }


fromCiTests : Test
fromCiTests =
    describe "CI -> CID, RNC"
        [ test "262904025" <|
            \_ -> fromCi default "262904025" |> Expect.equal valid
        , test "432" <|
            \_ ->
                fromCi default "432"
                    |> Expect.equal
                        { ci = Just 432
                        , rnc = Just 0
                        , cid = Just 432
                        }
        , test "65536" <|
            \_ ->
                fromCi default "65536"
                    |> Expect.equal
                        { ci = Just 65536
                        , rnc = Just 1
                        , cid = Just 0
                        }
        , test "-1" <|
            \_ -> fromCi default "-1" |> Expect.equal default
        , test "香蕉" <|
            \_ -> fromCi default "香蕉" |> Expect.equal default
        , test "🍵" <|
            \_ -> fromCi default "🍵" |> Expect.equal default
        , test "Remove everything when CI is empty" <|
            \_ -> fromCi valid "" |> Expect.equal default
        , test "CI overflow" <|
            \_ ->
                fromCi valid "999999999" |> Expect.equal valid
        ]


fromRncTests : Test
fromRncTests =
    describe "RNC -> CI, CID"
        [ test "RNC 1, no CID" <|
            \_ ->
                fromRnc default "1"
                    |> Expect.equal
                        { ci = Nothing
                        , rnc = Just 1
                        , cid = Nothing
                        }
        , test "RNC 1, CID 1" <|
            \_ ->
                fromRnc { default | cid = Just 1 } "1"
                    |> Expect.equal
                        { ci = Just 65537
                        , rnc = Just 1
                        , cid = Just 1
                        }
        , test "Remove CI when RNC is no longer valid" <|
            \_ ->
                fromRnc valid "" |> Expect.equal { valid | rnc = Nothing, ci = Nothing }
        , test "RNC overflow" <|
            \_ ->
                fromRnc valid "999999999" |> Expect.equal valid
        ]


fromCidTests : Test
fromCidTests =
    describe "CID -> CI, RNC"
        [ test "CID 1, no RNC" <|
            \_ ->
                fromCid default "1"
                    |> Expect.equal
                        { ci = Nothing
                        , rnc = Nothing
                        , cid = Just 1
                        }
        , test "CID 1, RNC 1" <|
            \_ ->
                fromCid { default | rnc = Just 1 } "1"
                    |> Expect.equal
                        { ci = Just 65537
                        , rnc = Just 1
                        , cid = Just 1
                        }
        , test "Remove CI when CID is no longer valid" <|
            \_ ->
                fromCid valid "" |> Expect.equal { valid | ci = Nothing, cid = Nothing }
        , test "CID overflow" <|
            \_ ->
                fromCid valid "999999999" |> Expect.equal valid
        ]
