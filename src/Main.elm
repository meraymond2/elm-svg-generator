module Main exposing (..)
import Html exposing (..)

-- APP
main : Program Never Model Msg
main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL
type alias Model = Int

model : Model
model = 0


-- UPDATE
type Msg = NoOp | Increment

update : Msg -> Model -> Model
update msg model =
  case msg of
    NoOp -> model
    Increment -> model + 1


-- VIEW
view : Model -> Html Msg
view model =
  p [] [ text "Hello from Elm." ]
