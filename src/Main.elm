module Main exposing (..)

-- IMPORTS
import Array exposing (..)
import Html exposing (..)
import Html.Attributes exposing ( style, type_, value )
import Html.Events exposing ( onInput )
import Svg exposing ( path, svg )
import Svg.Attributes exposing ( d, fill, viewBox )

-- APP
main : Program Never Model Msg
main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL
type Instruction = MoveTo String String | LineTo String String
type alias Model = Array Instruction

model : Model
model =
  Array.fromList
  [ MoveTo "0" "0"
  , LineTo "60" "60"
  ]


-- UPDATE
type Msg = MMM

update : Msg -> Model -> Model
update msg model =
  case msg of
    MMM ->
      model


-- VIEW
instructionToString : Instruction -> String
instructionToString instruction =
  case instruction of
    MoveTo x y ->
      "M" ++ x ++ "," ++ y

    LineTo x y ->
      "L" ++ x ++ "," ++ y

renderPath : Model -> Html Msg
renderPath model =
  let
    strings : Array String
    strings =
      Array.map (instructionToString) model

    joined : String
    joined =
      Array.foldr (\acc string -> acc ++ " " ++ string) "" strings
  in
    path [ d joined, fill "none" ] [ ]

renderInput : Int -> Instruction -> Html Msg
renderInput index instruction =
  case instruction of
    MoveTo x y ->
      p [] [ text (x ++ y) ]
    LineTo x y ->
      p [] [ text (x ++ y) ]
      -- input [ onInput (Path index), style inputStyles, value string ] [ ]

view : Model -> Html Msg
view model =
  div [ ] [
    -- div [ ] (Array.toList <| Array.indexedMap renderInput model),
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
