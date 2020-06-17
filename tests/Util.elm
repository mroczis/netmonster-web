module Util exposing (hasTest)

import Expect
import Test exposing (Test, describe, test)
import Util.Regex exposing (has)


hasTest : Test
hasTest =
    describe "Does list have something matching pre-condition"
        [ test "Contains a" <|
            \_ -> has (\something -> something == "b") [ "a", "b" ] |> Expect.equal True
        , test "Plus one is eight, should succeed" <|
            \_ -> has (\something -> something + 1 == 8) [ 5, 7, 8 ] |> Expect.equal True
        , test "Plus one is eight, should fail" <|
            \_ -> has (\something -> something + 1 == 8) [ 5, 9, 14 ] |> Expect.equal False
        ]
