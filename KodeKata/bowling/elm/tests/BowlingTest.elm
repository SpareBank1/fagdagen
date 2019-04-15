module BowlingTest exposing (..)

import Bowling exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, frequency, char)
import Shrink exposing (..)
import Test exposing (..)
import Random exposing (..)

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
    (List.map testFramesFun bowlingTestCases) ++
      (List.map testTotalScoreFun bowlingTestCases))

testFramesFun : BowlingTestCase -> Test
testFramesFun testCase =
  test ("Frames: " ++ testCase.line) (
    \_ ->
      let
        line = Bowling.stringToLine testCase.line
      in
        Expect.equalLists testCase.frames line.frames
    )

testTotalScoreFun : BowlingTestCase -> Test
testTotalScoreFun testCase =
    test ("Score: " ++ testCase.line) (
      \_ ->
        let
          line = Bowling.stringToLine testCase.line
        in
          Expect.equal testCase.score (Maybe.withDefault 0 line.score)
      )

rollChars : List Char
rollChars = ['X', '/', '-', '1', '2', '3', '4', '5', '6', '7', '8', '9']

charGenerator : Generator Char
charGenerator = (Random.int 0 0x10FFFF |> Random.map Char.fromCode)

validRollsFuzzer : Fuzzer Char
validRollsFuzzer = List.map Fuzz.constant rollChars |> Fuzz.oneOf

invlidRollsFuzzer : Fuzzer Char
invlidRollsFuzzer = Fuzz.custom charGenerator Shrink.char
