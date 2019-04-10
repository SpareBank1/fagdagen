module BowlingTest exposing (..)

import Bowling exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, frequency, char)
import Shrink exposing (..)
import Test exposing (..)
import Random exposing (..)


suite : Test
suite =
    describe "Bowling score module" ((
      [ ("X X X X X X X X X X X X", 300)
      , ("9- 9- 9- 9- 9- 9- 9- 9- 9- 9-", 90)
      , ("5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/5", 150)
      , ("81 81 81 81 81 81 81 81 81 81", 90)
      , ("81 81 81 81 81 81 81 81 X 81", 100)
      , ("81 81 81 81 81 81 81 81 81 X 4 4", 99)
      , ("81 81 81 81 81 81 81 81 81 X X 4", 105)
      , ("81 81 81 81 X 8/ 81 81 81 X X 4", 125)
      ] |> List.map testFun) ++
        [ describe "Char to Roll"
            [ fuzz validRollsFuzzer "Chars to Roll" <|
                \ch -> charToRoll ch |> Expect.ok
            , fuzz invlidRollsFuzzer "wrong input to roll" <|
                \ch -> charToRoll ch |> Expect.err
            ]
        , describe ("String to rolls")
          [ test ("all strikes to rolls") <|
              \_ -> stringToRolls "X X X X X X X X X X X X" |> Expect.equalLists (List.repeat 12 Strike)
          , test ("all nines and miss to rolls") <|
            \_ -> stringToRolls "9- 9- 9- 9- 9- 9- 9- 9- 9- 9-" |> Expect.equalLists (List.repeat 10 [Pins 9, Pins 0] |> List.concatMap identity)
          , test ("all spares to rolls") <|
            \_ -> stringToRolls "5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/5" |> Expect.equalLists (((List.repeat 10 [Pins 5, Spare]) |> List.concatMap identity) ++ [Pins 5])
          ]
        , describe ("Rolls to Frames")
          [ test ("all strikes to frames") <|
             \_ -> stringToRolls "X X X X X X X X X X X X" |> rollsToFrames |> Expect.equalLists (List.repeat 10 (Frame Strike (Just Strike) (Just Strike) (Just 30)))
          , test ("all nines and miss to frames") <|
                \_ -> stringToRolls "9- 9- 9- 9- 9- 9- 9- 9- 9- 9-" |> rollsToFrames |> Expect.equalLists (List.repeat 10 (Frame (Pins 9) (Just (Pins 0)) Nothing (Just 9)))
          , test ("all spares to frames") <|
             \_ -> stringToRolls "5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/5" |> rollsToFrames |> Expect.equalLists (List.repeat 10 (Frame (Pins 5) (Just Spare) (Just (Pins 5)) (Just 15)))
          ]
        ]
      )

rollChars : List Char
rollChars = ['X', '/', '-', '1', '2', '3', '4', '5', '6', '7', '8', '9']

charGenerator : Generator Char
charGenerator = (Random.int 0 0x10FFFF |> Random.map Char.fromCode)

validRollsFuzzer : Fuzzer Char
validRollsFuzzer = List.map Fuzz.constant rollChars |> Fuzz.oneOf

invlidRollsFuzzer : Fuzzer Char
invlidRollsFuzzer = Fuzz.custom charGenerator Shrink.char

testFun : (String, Int) -> Test
testFun sample =
  let
    (sampleLine, expectedScore) = sample
  in
    test ("Line: " ++ sampleLine) (\_ -> Bowling.bowlingScore sampleLine |> Expect.equal expectedScore)
