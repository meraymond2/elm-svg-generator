module Main exposing (..)

-- IMPORTS
import Html exposing (..)
import Html.Attributes exposing ( style )
import Html.Events exposing ( onInput )
import Svg exposing ( path, svg )
import Svg.Attributes exposing ( d, fill, viewBox )

-- APP
main : Program Never Model Msg
main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL
type alias Model = String

model : Model
model = "M0,0 L120,60"


-- UPDATE
type Msg = Path String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Path newPath -> newPath


-- VIEW
renderPath : Model -> Html Msg
renderPath model =
  path [ d model, fill "none" ] [ ]

view : Model -> Html Msg
view model =
  div [ ] [
    input [ onInput Path, style inputStyles ] [ ],
    div [ style boxStyles ] [
      svg [ style svgStyles, viewBox "0 0 120 120" ] [
        renderPath model
      ]
    ]
  ]

  -- CSS Styles
inputStyles : List ( String, String )
inputStyles =
  [ ("margin-bottom", "20px")
  ]

boxStyles : List ( String, String )
boxStyles =
  [ ("background-color", "navy")
  , ("height", "200px")
  , ("width", "200px")
  ]

svgStyles : List ( String, String )
svgStyles =
  [ ("stroke", "white")
  , ("stroke-linecap", "round")
  , ("stroke-width", "5px")
  ]
