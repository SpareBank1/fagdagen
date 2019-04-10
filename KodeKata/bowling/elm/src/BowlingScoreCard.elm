module BowlingScoreCard exposing (..)

import Bowling exposing (bowlingScore, Frame(..), Roll(..), stringToFrames)

import Browser
import Html exposing (Html, Attribute, div, ul, li, text, button, input, span, table, tr, td, th, thead, tbody, p)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

main =
  Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }

type alias Line =
  { player : String
  , frames : List Frame
  , score  : Int
  }

type alias Model =
  { lines : List Line
  , input : String
  }

init : () -> (Model, Cmd Msg)
init _ =
  ({ lines =
    [ { player = "player 1"
      , frames = stringToFrames "X X X X X X X X X X X X"
      , score = bowlingScore "X X X X X X X X X X X X"
      }
    , { player = "player 2"
      , frames = stringToFrames "9- 9- 9- 9- 9- 9- 9- 9- 9- 9-"
      , score = bowlingScore "9- 9- 9- 9- 9- 9- 9- 9- 9- 9-"
      }
    , { player = "player 3"
      , frames = stringToFrames "5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/5"
      , score = bowlingScore "5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/5"
      }
    ]
  , input = ""
  }, Cmd.none)

type Msg =
  Calculate
  | Change String

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
  Calculate -> ({model | lines = model.lines ++ [ Line "player" (stringToFrames model.input) (bowlingScore model.input) ]}, Cmd.none)
  Change s -> ({ model | input = s }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

view : Model -> Html Msg
view model =
  div [ style "width" "60%"]
    [ p [] [ text "Enter a full line of bowling rolls. Separate frames with spaces." ]
    , input [ placeholder "line", value model.input, onInput Change ] []
    , button [ onClick Calculate ] [ text "Calculate" ]
    , scoreCard model.lines
    ]

scoreCard : List Line -> Html Msg
scoreCard lines =
  table [ attribute "border" "1", style "width" "100%", style "text-align" "center"]
    [ thead []
        [ tr []
            ([ th []
                [ text "Player" ]
            ] ++ (List.map frameHeader (List.range 1 10)) ++ [ th [] [ text "Score" ] ])
        ]
    , tbody []
        (List.concatMap frameCells lines)
    ]

frameHeader : Int -> Html Msg
frameHeader n =
  let
    span = if n == 10 then "3" else "2"
  in
    th [ attribute "colspan" span ]
      [ text (String.fromInt n) ]

frameCells : Line -> List (Html Msg)
frameCells line =
    [ tr []
      ([ td [ attribute "rowspan" "2" ] [ text line.player ] ] ++
        (List.indexedMap frameCellRolls line.frames |> List.concatMap identity) ++
          [ td [ attribute "rowspan" "2" ] [ text (String.fromInt line.score) ] ])
    , tr []
        (List.indexedMap frameCellScore line.frames)
    ]

frameCellRolls : Int -> Frame -> List (Html Msg)
frameCellRolls index frame =
  if index < 9 then
    case frame of
      Frame Strike _ _ _ ->
        [ td []
          [ text " " ]
        , td []
          [ text "X" ]
        ]
      Frame roll1 roll2 _ _ ->
          [ td []
            [ text (rollToString roll1) ]
          , td []
            [ text (Maybe.map rollToString roll2 |> Maybe.withDefault " ") ]
          ]
    else
      case frame of
        Frame roll1 roll2 roll3 _ ->
          let
            r1 = rollToString roll1
            r2 = Maybe.map rollToString roll2 |> Maybe.withDefault " "
            r3 = Maybe.map rollToString roll3 |> Maybe.withDefault " "
          in
            [ td []
              [ text r1 ]
            , td []
              [ text r2 ]
            , td []
              [ text r3 ]
            ]

rollToString : Roll -> String
rollToString roll = case roll of
  Strike -> "X"
  Spare -> "/"
  Pins 0 -> "-"
  Pins n -> String.fromInt n

frameCellScore : Int -> Frame -> Html Msg
frameCellScore index frame =
  let
    span = if index < 9 then 2 else 3
  in
    case frame of
      Frame _ _ _ score ->
         td [ attribute "colspan" (String.fromInt span) ]
            [ text (Maybe.map String.fromInt score |> Maybe.withDefault " ") ]
