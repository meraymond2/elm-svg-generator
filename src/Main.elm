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
type alias Point =
  { x : String
  , y : String
  }


type Instruction = MoveTo Point | LineTo Point
type alias Model = Array Instruction


model : Model
model =
  Array.fromList
  [ MoveTo { x = "0", y = "0" }
  ]


-- UPDATE
type alias Index = Int
type alias Shift = Int
type Msg =
  UpdateX Int String
  | UpdateY Int String
  | NewMove
  | NewLine
  | Remove Int
  | Reorder Index Shift


updateX : String -> Maybe Instruction -> Instruction
updateX newX instruction =
  case instruction of
    Just (MoveTo coords) ->
      MoveTo { coords | x = newX }

    Just (LineTo coords) ->
      LineTo { coords | x = newX }

    Nothing ->
      MoveTo { x = "0", y = "0" }

updateY : String -> Maybe Instruction -> Instruction
updateY newY instruction =
  case instruction of
    Just (MoveTo coords) ->
      MoveTo { coords | y = newY }

    Just (LineTo coords) ->
      LineTo { coords | y = newY }

    Nothing ->
      MoveTo { x = "0", y = "0" }




update : Msg -> Model -> Model
update msg model =
  case msg of
    UpdateX index x ->
      let
        next : Instruction
        next =
          updateX x (Array.get index model)
      in
        Array.set index next model

    UpdateY index y ->
      let
        next : Instruction
        next = updateY y (Array.get index model)
      in
        Array.set index next model

    NewMove ->
      Array.push (MoveTo { x = "0", y = "0" }) model

    NewLine ->
      Array.push (LineTo { x = "0", y = "0" }) model

    Remove index ->
      Array.append (Array.slice 0 index model) (Array.slice (index + 1) (Array.length model) model)

    Reorder index shift ->
      let
        before : Maybe Instruction
        before = Array.get index model
        after : Maybe Instruction
        after = Array.get (index + shift) model
        newModel =
          case (before, after) of
            (Just beforeVal, Just afterVal) ->
              Array.set index afterVal (Array.set (index + shift) beforeVal model)
            _ ->
              model
      in
        newModel

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
        , input [ onInput (UpdateX index), type_ "number", value (x) ] [ ]
        , input [ onInput (UpdateY index), type_ "number", value (y) ] [ ]
        , button [ onClick (Remove index), type_ "button" ] [ text "X" ]
        , button [ onClick (Reorder index -1), type_ "button" ] [ text "U" ]
        , button [ onClick (Reorder index 1), type_ "button" ] [ text "D" ]
      ]
    LineTo { x, y } ->
      div [ ] [
        span [ ] [ text "Line" ]
        , input [ onInput (UpdateX index), type_ "number", value (x) ] [ ]
        , input [ onInput (UpdateY index), type_ "number", value (y) ] [ ]
        , button [ onClick (Remove index), type_ "button" ] [ text "X" ]
        , button [ onClick (Reorder index -1), type_ "button" ] [ text "U" ]
        , button [ onClick (Reorder index 1), type_ "button" ] [ text "D" ]
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
