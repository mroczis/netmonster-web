module MccMnc exposing (..)

import Expect
import Test exposing (Test, describe, test)
import Util.MccMnc exposing (isMcc, isMnc)


mccTest : Test
mccTest =
    describe "Mobile country code"
        [ test "0" <|
            \_ -> isMcc "0" |> Expect.equal False
        , test "1" <|
            \_ -> isMcc "1" |> Expect.equal False
        , test "01" <|
            \_ -> isMcc "01" |> Expect.equal False
        , test "99" <|
            \_ -> isMcc "99" |> Expect.equal False
        , test "1 with whitespace" <|
            \_ -> isMcc " 1" |> Expect.equal False
        , test "100" <|
            \_ -> isMcc "100" |> Expect.equal True
        , test "033" <|
            \_ -> isMcc "033" |> Expect.equal False
        , test "1000" <|
            \_ -> isMcc "1000" |> Expect.equal False
        , test "Orangutan" <|
            \_ -> isMnc "Orangutan" |> Expect.equal False
        ]


mncTest : Test
mncTest =
    describe "Mobile network code"
        [ test "0" <|
            \_ -> isMnc "0" |> Expect.equal False
        , test "1" <|
            \_ -> isMnc "1" |> Expect.equal True
        , test "01" <|
            \_ -> isMnc "01" |> Expect.equal True
        , test "99" <|
            \_ -> isMnc "99" |> Expect.equal True
        , test "1 with whitespace" <|
            \_ -> isMnc " 1" |> Expect.equal False
        , test "100" <|
            \_ -> isMnc "100" |> Expect.equal True
        , test "033" <|
            \_ -> isMnc "033" |> Expect.equal True
        , test "1000" <|
            \_ -> isMnc "1000" |> Expect.equal False
        , test "Orangutan" <|
            \_ -> isMnc "Orangutan" |> Expect.equal False
        ]
