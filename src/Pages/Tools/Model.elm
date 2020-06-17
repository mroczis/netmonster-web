module Pages.Tools.Model exposing
    ( Model
    , default
    )

import Material
import Pages.Tools.Calculation.Lte as Lte
import Pages.Tools.Calculation.Wcdma as Wcdma


type alias Model m =
    { mdc : Material.Model m
    , wcdma : Wcdma.Model
    , lte : Lte.Model
    , channel : Maybe Int
    }


default : Model m
default =
    { mdc = Material.defaultModel
    , wcdma = Wcdma.default
    , lte = Lte.default
    , channel = Nothing
    }
