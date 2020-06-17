module Color exposing (colorValidation)

import Util.Color exposing (isHexColor)
import Expect
import Test exposing (Test, describe, test)


colorValidation : Test
colorValidation =
    describe "Color validation"
        [ test "black" <|
            \_ -> isHexColor "#000" |> Expect.equal True
        , test "white" <|
            \_ -> isHexColor "#FFF" |> Expect.equal True
        , test "white, no hash" <|
            \_ -> isHexColor "FFF" |> Expect.equal True
        , test "white, long" <|
            \_ -> isHexColor "#FFFFFF" |> Expect.equal True
        , test "white, long, no hash" <|
            \_ -> isHexColor "FFFFFF" |> Expect.equal True
        , test "white text" <|
            \_ -> isHexColor "white" |> Expect.equal False
        , test "non-hex" <|
            \_ -> isHexColor "#GGG" |> Expect.equal False
        , test "green" <|
            \_ -> isHexColor "#1D1" |> Expect.equal True
        , test "bag" <|
            \_ -> isHexColor "bag" |> Expect.equal False
        ]
