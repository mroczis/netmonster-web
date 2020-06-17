module Http.Client exposing (operatorsUrl, suggestionUrl)

import Constants
import Maybe.Extra
import Pages.Operators.Model
import Url.Builder exposing (QueryParameter, int, string)


buildUrl : List String -> List QueryParameter -> String
buildUrl path query =
    Url.Builder.crossOrigin Constants.apiUrl path query


operatorsUrl : Pages.Operators.Model.Model m -> String
operatorsUrl model =
    buildUrl [ "operators", "web" ] (operatorsQuery model)


suggestionUrl : String
suggestionUrl =
    buildUrl [ "operators", "suggest", "index.php" ] []


operatorsQuery : Pages.Operators.Model.Model m -> List QueryParameter
operatorsQuery model =
    let
        limit =
            Just (int "limit" model.limit)

        offset =
            Just (int "offset" model.offset)

        name =
            Maybe.map (\n -> string "name" n) model.name

        country =
            Maybe.map (\c -> string "iso" c) model.country
    in
    Maybe.Extra.values [ limit, offset, name, country ]
