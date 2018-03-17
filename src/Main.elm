module Main exposing (..)

-- IMPORTS
import Array exposing (..)
import Html exposing (..)
import Html.Attributes exposing ( style, type_, value )
import Html.Events exposing ( onClick, onInput )
import Svg exposing ( path, svg )
import Svg.Attributes exposing ( d, fill, viewBox )

-- APP
main : Program Never Model Msg
main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL
type alias MoveCoords =
  { x : String
  , y : String
  }

type alias LineCoords =
  { x : String
  , y : String
  }

type Instruction = MoveTo MoveCoords | LineTo LineCoords
type alias Model = Array Instruction

model : Model
model =
  Array.fromList
  [ MoveTo { x = "0", y = "0" }
  ]


-- UPDATE
type Msg =
  UpdateMoveX Int String String
  | UpdateMoveY Int String String
  | UpdateLineX Int String String
  | UpdateLineY Int String String
  | NewMove
  | NewLine
  | Remove Int

update : Msg -> Model -> Model
update msg model =
  case msg of
    UpdateMoveX index y x ->
      Array.set index (MoveTo { x = x, y = y }) model

    UpdateMoveY index x y ->
      Array.set index (MoveTo { x = x, y = y }) model

    UpdateLineX index y x ->
      Array.set index (LineTo { x = x, y = y }) model

    UpdateLineY index x y ->
      Array.set index (LineTo { x = x, y = y }) model

    NewMove ->
      Array.push (MoveTo { x = "0", y = "0" }) model

    NewLine ->
      Array.push (LineTo { x = "0", y = "0" }) model

    Remove index ->
      Array.append (Array.slice 0 index model) (Array.slice (index + 1) (Array.length model) model)

-- VIEW
instructionToString : Instruction -> String
instructionToString instruction =
  case instruction of
    MoveTo { x, y } ->
      "M" ++ x ++ "," ++ y

    LineTo { x, y } ->
      "L" ++ x ++ "," ++ y

generatePath : Model -> String
generatePath model =
  let
    strings : Array String
    strings =
      Array.map (instructionToString) model
  in
    Array.foldr (\acc string -> acc ++ " " ++ string) "" strings

renderInput : Int -> Instruction -> Html Msg
renderInput index instruction =
  case instruction of
    MoveTo { x, y } ->
      div [ ] [
        span [ ] [ text "Move" ]
        , input [ onInput (UpdateMoveX index y), type_ "number", value (x) ] [ ]
        , input [ onInput (UpdateMoveY index x), type_ "number", value (y) ] [ ]
        , button [ onClick (Remove index), type_ "button" ] [ text "X" ]
      ]
    LineTo { x, y } ->
      div [ ] [
        span [ ] [ text "Line" ]
        , input [ onInput (UpdateLineX index y), type_ "number", value (x) ] [ ]
        , input [ onInput (UpdateLineY index x), type_ "number", value (y) ] [ ]
        , button [ onClick (Remove index), type_ "button" ] [ text "X" ]
      ]

view : Model -> Html Msg
view model =
  div [ ] [
    div [ ] (Array.toList <| Array.indexedMap renderInput model)
    , button [ onClick NewMove ] [ text "Add Move" ]
    , button [ onClick NewLine ] [ text "Add Line" ]
    , div [ style boxStyles ] [
      svg [ style svgStyles, viewBox "0 0 120 120" ] [
        path [ d (generatePath model), fill "none" ] [ ]
      ]
    ]
    , p [ ] [ text (generatePath model) ]
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
