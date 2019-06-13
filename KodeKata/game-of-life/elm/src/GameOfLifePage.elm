module GameOfLifePage exposing (..)

import GameOfLife exposing (..)

import Browser
import Html exposing (Html, Attribute, div, button, text, select, option, i, textarea)
import Html.Attributes
import Html.Events exposing (onClick)
import Svg exposing (svg, rect)
import Svg.Attributes exposing (..)
import Svg.Events

import Random exposing (..)
import Array exposing (..)
import Task
import Time

main =
  Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }

type alias Model =
  { grid: Grid
  , running: Bool
  , selected: String
  , input: String
  }

init : () -> (Model, Cmd Msg)
init _ = ({ grid = Array.empty, running = False, selected = "", input = "" }, Random.generate NewGrid (randomGrid 50 50))

type Msg = UpdateGrid | NewGrid Grid | Tick Time.Posix | Select String | Start | Stop | Click (Int, Int) | Input String | Apply

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
  UpdateGrid -> ({ model | grid = (nextGeneration model.grid) }, Cmd.none)
  NewGrid grid -> ({ model | grid = grid }, Cmd.none)
  Tick time ->
    let
      updatedGrid = if model.running then (nextGeneration model.grid) else model.grid
    in
      ({ model | grid = updatedGrid }, Cmd.none)
  Select value ->
    case value of
      "empty" -> ({model | grid = (emptyGrid 50 50)}, Cmd.none)
      "random" -> ({ model | grid = Array.empty}, Random.generate NewGrid (randomGrid 50 50))
      _ -> (model, Cmd.none)
  Start -> ({ model | running = True }, Cmd.none)
  Stop -> ({ model | running = False }, Cmd.none)
  Click (r,c) -> ({ model | grid = occupyCell (r, c) (Ok model.grid) |> Result.toMaybe |> Maybe.withDefault model.grid }, Cmd.none)
  Input s -> ({ model | input = s }, Cmd.none)
  Apply -> ({ model | grid = parseInput model.input }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model = Time.every 100 Tick

view : Model -> Html Msg
view model =
  div []
    [ div []
      [ svg
        [ width "600", height "600", viewBox "0 0 600 600" ]
        (Array.toList model.grid |> List.indexedMap (\row rows -> Array.toList rows |> List.indexedMap (\col cells ->
          rect [onClick (Click (row, col)), x (String.fromInt (col * 10)), y (String.fromInt (row * 10)), width "10", height "10", fill (if cells == Occupied then "#444444" else "#cccccc"), stroke "#000000", strokeWidth "1"] [])
        ) |> flatMap identity)
      ]
    , div [ class "controls"]
      [ button [ Html.Events.onClick UpdateGrid ] [ i [ Html.Attributes.class "material-icons" ] [Html.text "arrow_forward" ] ]
      , button [ Html.Events.onClick Start ] [ i [ Html.Attributes.class "material-icons" ] [ Html.text "play_arrow" ] ]
      , button [ Html.Events.onClick Stop ] [ i [ Html.Attributes.class "material-icons" ] [ Html.text "pause" ] ]
      ]
    , div [class "select"]
      [ select [ Html.Events.onInput Select ]
        [ option [ Html.Attributes.selected True ] [ Html.text "" ]
        , option [ Html.Attributes.value "empty" ] [ Html.text "Empty" ]
        , option [ Html.Attributes.value "random" ] [ Html.text "Random" ]
        ]
      ]
    , div [class "input"]
      [ textarea [ Html.Attributes.value model.input, Html.Events.onInput Input, Html.Attributes.rows 25, Html.Attributes.cols 40] []
      , button [ Html.Events.onClick Apply ] [ Html.text "Use"]
      ]
    ]

join : List (List a) -> List a
join =
    List.foldr (++) []

flatMap : (a -> List b) -> List a -> List b
flatMap f list =
    List.map f list
        |> join

parseInput : String -> Grid
parseInput str =
  String.split "\n" str
  |> List.map (\s -> String.toList s
    |> List.map (\c -> case c of
      '.' -> Empty
      '*' -> Occupied
      _ -> Empty
      )
    |> Array.fromList
  )
  |> Array.fromList
