module BowlingTest exposing (..)

import Bowling exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, frequency, char)
import Shrink exposing (..)
import Test exposing (..)
import Random exposing (..)
import Random.Extra
import Random.Char

type alias BowlingTestCase =
  { line   : String
  , score  : Int
  , frames : List Frame
  }

bowlingTestCases : List BowlingTestCase
bowlingTestCases =
  [ BowlingTestCase "X X X X X X X X X X X X" 300 (List.repeat 10 (Frame Strike Strike (Just Strike) (Just 30)))
  , BowlingTestCase "9- 9- 9- 9- 9- 9- 9- 9- 9- 9-" 90 (List.repeat 10 (Frame (Pins 9) (Pins 0) Nothing (Just 9)))
  , BowlingTestCase "5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/5" 150 (List.repeat 10 (Frame (Pins 5) Spare (Just (Pins 5)) (Just 15)))
  , BowlingTestCase "81 81 81 81 81 81 81 81 81 81" 90 (List.repeat 10 (Frame (Pins 8) (Pins 1) Nothing (Just 9)))
  , BowlingTestCase "81 81 81 81 81 81 81 81 X 81" 100 (List.repeat 8 (Frame (Pins 8) (Pins 1) Nothing (Just 9)) ++ [Frame Strike (Pins 8) (Just (Pins 1)) (Just 19)] ++ [Frame (Pins 8) (Pins 1) Nothing (Just 9)])
  , BowlingTestCase "81 81 81 81 81 81 81 81 81 X 4 4" 99 ((List.repeat 9 (Frame (Pins 8) (Pins 1) Nothing (Just 9))) ++ [Frame Strike (Pins 4) (Just (Pins 4)) (Just 18)])
  , BowlingTestCase "81 81 81 81 81 81 81 81 81 X X 4" 105 ((List.repeat 9 (Frame (Pins 8) (Pins 1) Nothing (Just 9))) ++ [Frame Strike Strike (Just (Pins 4)) (Just 24)])
  , BowlingTestCase "81 81 81 81 X 8/ 81 81 81 X X 4" 125 ((List.repeat 4 (Frame (Pins 8) (Pins 1) Nothing (Just 9))) ++ [Frame Strike (Pins 8) (Just Spare) (Just 20)] ++ [Frame (Pins 8) Spare (Just (Pins 8)) (Just 18)] ++ (List.repeat 3 (Frame (Pins 8) (Pins 1) Nothing (Just 9))) ++ [Frame Strike Strike (Just (Pins 4)) (Just 24)])
  ]

suite : Test
suite =
    describe "Bowling score module" (
      (List.map testFramesFun bowlingTestCases)
      ++ (List.map testTotalScoreFun bowlingTestCases)
      ++ [
        fuzz validLineFuzzer "Valid lines" <|
          \randomLine ->
            randomLine
              |> Bowling.stringToLine
              |> Expect.ok
      ]
    )

testFramesFun : BowlingTestCase -> Test
testFramesFun testCase =
  test ("Frames: " ++ testCase.line) (
    \_ ->
      case Bowling.stringToLine testCase.line of
        Err s -> Expect.fail s
        Ok line -> Expect.equalLists testCase.frames line.frames
  )

testTotalScoreFun : BowlingTestCase -> Test
testTotalScoreFun testCase =
    test ("Score: " ++ testCase.line) (
      \_ ->
        case Bowling.stringToLine testCase.line of
          Err s -> Expect.fail s
          Ok line -> Expect.equal testCase.score (Maybe.withDefault 0 line.score)
    )

firstRollGenerator : Generator Char
firstRollGenerator = Random.uniform 'X' ['-', '1', '2', '3', '4', '5', '6', '7', '8', '9']

secondRollChars : Char -> List Char
secondRollChars char =
  let
    rolls = ['9', '8', '7', '6', '5', '4', '3', '2', '1', '-']
  in
    case char of
      '-' -> rolls
      _ -> char
        |> String.fromChar
        |> String.toInt
        |> Maybe.map (\i -> List.drop i rolls)
        |> Maybe.withDefault []

secondRollGenerator : Generator Char -> Generator Char
secondRollGenerator firstRoll = firstRoll |> Random.andThen (\r1 -> Random.uniform '/' (secondRollChars r1))

--invalidRollCharsGenerator : Generator Char
--invalidRollCharsGenerator = Random.Char.unicode |> Random.Extra.filter (\c -> not (List.member c rollChars))

validFrameGenerator : Generator String
validFrameGenerator =
  let
    roll1 = firstRollGenerator
    roll2 = secondRollGenerator roll1
  in
    Random.map2 (\r1 r2 -> (String.fromChar r1) ++ (String.fromChar r2)) roll1 roll2

validFrameFuzzer : Fuzzer String
validFrameFuzzer =
  Fuzz.custom validFrameGenerator Shrink.noShrink

validLineFuzzer : Fuzzer String
validLineFuzzer =
  let
    gen = Random.list 10 validFrameGenerator
      |> Random.map (\l -> List.foldr (++) "" l)
  in
    Fuzz.custom gen Shrink.string
