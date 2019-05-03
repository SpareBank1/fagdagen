module BowlingScoreCard exposing (..)

import Bowling exposing (..)

import Browser
import Html exposing (Html, Attribute, div, ul, li, text, button, input, span, table, tr, td, th, thead, tbody, p)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

main =
  Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }

type alias ScoreCardRow =
  { player : String
  , line   : Result String Line
  }

type alias Model =
  { rows : List ScoreCardRow
  , input : String
  }

init : () -> (Model, Cmd Msg)
init _ =
  ({ rows =
    [ { player = "player 1"
      , line = stringToLine "X X X X X X X X X X X X"
      }
    , { player = "player 2"
      , line = stringToLine "9- 9- 9- 9- 9- 9- 9- 9- 9- 9-"
      }
    , { player = "player 3"
      , line = stringToLine "5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/5"
      }
    ]
  , input = ""
  }, Cmd.none)

type Msg =
  Calculate
  | Change String

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
  Calculate -> ({model | rows = model.rows ++ [ ScoreCardRow "player" (stringToLine model.input) ]}, Cmd.none)
  Change s -> ({ model | input = s }, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

view : Model -> Html Msg
view model =
  div [ class "bowling-score-card" ]
    [ p [] [ text "Enter a full line of bowling rolls. Separate frames with spaces." ]
    , input [ placeholder "line", value model.input, onInput Change ] []
    , button [ onClick Calculate ] [ text "Calculate" ]
    , scoreCard model.rows
    ]

scoreCard : List ScoreCardRow -> Html Msg
scoreCard rows =
  table [ class "bowling-score-card" ]
    [ thead []
        [ tr []
            ([ th [ class "bowling-score-card" ]
                [ text "Player" ]
            ] ++ (List.map scoreCardFrameHeader (List.range 1 10)) ++ [ th [ class "bowling-score-card" ] [ text "Score" ] ])
        ]
    , tbody []
        (List.concatMap scoreCardRow rows)
    ]

scoreCardFrameHeader : Int -> Html Msg
scoreCardFrameHeader n =
  let
    span = if n == 10 then "3" else "2"
  in
    th [ class "bowling-score-card", attribute "colspan" span ]
      [ text (String.fromInt n) ]

scoreCardRow : ScoreCardRow -> List (Html Msg)
scoreCardRow row = case row.line of
  Err m ->
    [ tr []
      [ td [ class "bowling-score-card", attribute "rowspan" "2" ] [ text row.player ]
      , td [ attribute "rowspan" "2", attribute "colspan" "22"] [ text ("Error: " ++ m) ]
      ]
    , tr [] []
    ]
  Ok line -> scoreCardRowOk row.player line

scoreCardRowOk : String -> Line -> List (Html Msg)
scoreCardRowOk player line =
  [ tr []
    ([ td [ class "bowling-score-card", attribute "rowspan" "2" ] [ text player ] ] ++
       (List.indexedMap frameCellRolls line.frames |> List.concatMap identity) ++
        [ td [ class "bowling-score-card", attribute "rowspan" "2" ] [ text (Maybe.map String.fromInt line.score |> Maybe.withDefault "") ] ])
  , tr []
      (List.indexedMap frameCellScore line.frames)
  ]

frameCellRolls : Int -> Frame -> List (Html Msg)
frameCellRolls index frame =
  if index < 9 then
    case frame of
      Frame Strike _ _ _ ->
        [ td [ class "bowling-score-card roll1" ]
          [ text " " ]
        , td []
          [ text "X" ]
        ]
      Frame roll1 roll2 _ _ ->
          [ td [ class "bowling-score-card roll1" ]
            [ text (rollToString roll1) ]
          , td []
            [ text (rollToString roll2) ]
          ]
    else
      case frame of
        Frame roll1 roll2 roll3 _ ->
          let
            r1 = rollToString roll1
            r2 = rollToString roll2
            r3 = Maybe.map rollToString roll3 |> Maybe.withDefault " "
          in
            [ td [ class "bowling-score-card roll1" ]
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
         td [ class "bowling-score-card frame-score", attribute "colspan" (String.fromInt span) ]
            [ text (Maybe.map String.fromInt score |> Maybe.withDefault " ") ]
