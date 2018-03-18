module Main exposing (..)

-- IMPORTS
import Array exposing (..)
import Html exposing (..)
import Html.Attributes exposing ( class, type_, value )
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

type alias ControlPoint = Point

type Instruction = MoveTo Point | LineTo Point | CubicCurve ControlPoint Point

type alias Model = Array Instruction


bin : Model
bin =
  Array.fromList [
    MoveTo { x = "48", y = "18" }
    , CubicCurve { x = "48", y = "6" } { x = "60", y = "6" }
    , CubicCurve { x = "72", y = "6" } { x = "72", y = "18" }
    , MoveTo { x = "24", y = "18" }
    , LineTo { x = "96", y = "18" }
    , CubicCurve { x = "102", y = "18" } { x = "102", y = "24" }
    , LineTo { x = "102", y = "30" }
    , CubicCurve { x = "102", y = "36" } { x = "96", y = "36" }
    , LineTo { x = "24", y = "36" }
    , CubicCurve { x = "18", y = "36" } { x = "18", y = "30" }
    , LineTo { x = "18", y = "24" }
    , CubicCurve { x = "18", y = "18" } { x = "24", y = "18" }
    , MoveTo { x = "48", y = "48" }
    , LineTo { x = "48", y = "102" }
    , MoveTo { x = "60", y = "48" }
    , LineTo { x = "60", y = "102" }
    , MoveTo { x = "72", y = "48" }
    , LineTo { x = "72", y = "102" }
    , MoveTo { x = "30", y = "36" }
    , LineTo { x = "30", y = "108" }
    , CubicCurve { x = "30", y = "114" } { x = "36", y = "114" }
    , LineTo { x = "84", y = "114" }
    , CubicCurve { x = "90", y = "114" } { x = "90", y = "108" }
    , LineTo { x = "90", y = "36" }
  ]


model : Model
model =
  Array.fromList [
    MoveTo startingPoint
  ]


-- UPDATE
type alias Index = Int

type alias Coord = String

type alias Shift = Int

type Msg
  = UpdateX Index Coord
  | UpdateY Index Coord
  | UpdateCPX Index Coord
  | UpdateCPY Index Coord
  | NewMove
  | NewLine
  | NewCubicCurve
  | Remove Index
  | Reorder Index Shift


startingPoint : Point
startingPoint =
  { x = "0"
  , y = "0"
  }


updateX : Coord -> Maybe Instruction -> Instruction
updateX newX instruction =
  case instruction of
    Just (MoveTo coords) ->
      MoveTo { coords | x = newX }

    Just (LineTo coords) ->
      LineTo { coords | x = newX }

    Just (CubicCurve controlCoords destCoords) ->
      CubicCurve controlCoords { destCoords | x = newX }

    Nothing ->
      MoveTo startingPoint


updateY : Coord -> Maybe Instruction -> Instruction
updateY newY instruction =
  case instruction of
    Just (MoveTo coords) ->
      MoveTo { coords | y = newY }

    Just (LineTo coords) ->
      LineTo { coords | y = newY }

    Just (CubicCurve controlCoords destCoords) ->
      CubicCurve controlCoords { destCoords | y = newY }

    Nothing ->
      MoveTo startingPoint


updateCPX : Coord -> Maybe Instruction -> Instruction
updateCPX newX instruction =
  case instruction of
    Just (CubicCurve contP destP) ->
      CubicCurve { contP | x = newX } destP

    _ ->
      MoveTo startingPoint


updateCPY : Coord -> Maybe Instruction -> Instruction
updateCPY newY instruction =
  case instruction of
    Just (CubicCurve contP destP) ->
      CubicCurve { contP | y = newY } destP

    _ ->
      MoveTo startingPoint


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

    UpdateCPX index x ->
      let
        next : Instruction
        next = updateCPX x (Array.get index model)
      in
        Array.set index next model

    UpdateCPY index y->
      let
        next : Instruction
        next = updateCPY y (Array.get index model)
      in
        Array.set index next model

    NewMove ->
      Array.push (MoveTo startingPoint) model

    NewLine ->
      Array.push (LineTo startingPoint) model

    NewCubicCurve ->
      Array.push (CubicCurve startingPoint startingPoint) model

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

    CubicCurve contP destP ->
      "Q" ++ contP.x ++ "," ++ contP.y ++ " " ++ destP.x ++ "," ++ destP.y


generatePath : Model -> String
generatePath model =
  let
    strings : Array String
    strings =
      Array.map (instructionToString) model
  in
    Array.foldr (\acc string -> acc ++ " " ++ string) "" strings


renderInput : Index -> Instruction -> Html Msg
renderInput index instruction =
  case instruction of
    MoveTo { x, y } ->
      div [ class "instruction" ] [
        span [ ] [ text "Move" ]
        , input [ onInput (UpdateX index), type_ "number", value (x) ] [ ]
        , input [ onInput (UpdateY index), type_ "number", value (y) ] [ ]
        , button [ onClick (Remove index), type_ "button" ] [ text "X" ]
        , button [ onClick (Reorder index -1), type_ "button" ] [ text "Up" ]
        , button [ onClick (Reorder index 1), type_ "button" ] [ text "Down" ]
      ]

    LineTo { x, y } ->
      div [ class "instruction" ] [
        span [ ] [ text "Line" ]
        , input [ onInput (UpdateX index), type_ "number", value (x) ] [ ]
        , input [ onInput (UpdateY index), type_ "number", value (y) ] [ ]
        , button [ onClick (Remove index), type_ "button" ] [ text "X" ]
        , button [ onClick (Reorder index -1), type_ "button" ] [ text "Up" ]
        , button [ onClick (Reorder index 1), type_ "button" ] [ text "Down" ]
      ]

    CubicCurve contP destP ->
      div [ class "instruction" ] [
        span [ ] [ text "Cubic Bezier Curve" ]
        , input [ onInput (UpdateCPX index), type_ "number", value (contP.x) ] [ ]
        , input [ onInput (UpdateCPY index), type_ "number", value (contP.y) ] [ ]
        , input [ onInput (UpdateX index), type_ "number", value (destP.x) ] [ ]
        , input [ onInput (UpdateY index), type_ "number", value (destP.y) ] [ ]
        , button [ onClick (Remove index), type_ "button" ] [ text "X" ]
        , button [ onClick (Reorder index -1), type_ "button" ] [ text "Up" ]
        , button [ onClick (Reorder index 1), type_ "button" ] [ text "Down" ]
      ]


view : Model -> Html Msg
view model =
  div [ class "layout" ] [
    div [ class "left" ] [
      div [ class "buttons" ] [
          button [ onClick NewMove ] [ text "Add Move" ]
        , button [ onClick NewLine ] [ text "Add Line" ]
        , button [ onClick NewCubicCurve ] [ text "Add CubicCurve" ]
      ]
      , div [ ] (Array.toList <| Array.indexedMap renderInput model)
    ]
    , div [ class "right" ] [
      div [ class "viewBox" ] [
        svg [ viewBox "0 0 120 120" ] [
          path [ d (generatePath model), fill "none" ] [ ]
        ]
      ]
      , div [ class "codeBox" ] [
        p [ ] [ text "<svg class=\"svg\" viewBox=\"0 0 120 120\">" ]
        , p [ ] [ text ("<path d=\"" ++ (generatePath model) ++ "\" />") ]
        , p [ ] [ text "</svg>"]
      ]
    ]
  ]
