module Main exposing (..)

-- IMPORTS
import Array exposing (..)
import Html exposing (..)
import Html.Attributes exposing ( style, value )
import Html.Events exposing ( onInput )
import Svg exposing ( path, svg )
import Svg.Attributes exposing ( d, fill, viewBox )

-- APP
main : Program Never Model Msg
main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL
type alias Model = Array String

model : Model
model =
  Array.fromList
  [ "M0,0"
  , "L120,120"
  ]


-- UPDATE
type Msg = Path Int String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Path index newPath -> Array.set index newPath model


-- VIEW
renderPath : Model -> Html Msg
renderPath model =
  path [ d ( Array.foldr ( \acc str -> acc ++ " " ++ str ) "" model ), fill "none" ] [ ]

renderInput : Int -> String -> Html Msg
renderInput index string =
  input [ onInput (Path index), style inputStyles, value string ] [ ]

view : Model -> Html Msg
view model =
  div [ ] [
    div [ ] (Array.toList <| Array.indexedMap renderInput model),
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
