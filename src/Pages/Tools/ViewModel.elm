module Pages.Tools.ViewModel exposing (..)

import Material
import Pages.Tools.Calculation.Lte as Lte
import Pages.Tools.Calculation.Wcdma as Wcdma
import Pages.Tools.Model exposing (Model)


type Msg m
    = Mdc (Material.Msg m)
    | Wcdma Wcdma.Msg
    | Lte Lte.Msg


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        Wcdma msg_ ->
            ( { model | wcdma = Wcdma.update msg_ model.wcdma }, Cmd.none )

        Lte msg_ ->
            ( { model | lte = Lte.update msg_ model.lte }, Cmd.none )