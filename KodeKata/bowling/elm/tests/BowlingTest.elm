module BowlingTest exposing (..)

import Bowling

import Expect exposing (Expectation)
import Test exposing (..)


suite : Test
suite =
    describe "Bowling score module" (
      [ ("X X X X X X X X X X X X", 300)
      , ("9- 9- 9- 9- 9- 9- 9- 9- 9- 9-", 90)
      , ("5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/5", 150)
      , ("81 81 81 81 81 81 81 81 81 81", 90)
      , ("81 81 81 81 81 81 81 81 X 81", 100)
      , ("81 81 81 81 81 81 81 81 81 X 4 4", 99)
      , ("81 81 81 81 81 81 81 81 81 X X 4", 105)
      , ("81 81 81 81 X 8/ 81 81 81 X X 4", 125)
      ] |> List.map testFun)

testFun : (String, Int) -> Test
testFun sample =
  let
    (sampleLine, expectedScore) = sample
  in
    test ("Line: " ++ sampleLine) (\_ -> Bowling.bowlingScore sampleLine |> Expect.equal expectedScore)
