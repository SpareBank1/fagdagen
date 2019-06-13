module GameOfLifeTest exposing (..)

import Array exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)

import GameOfLife exposing (..)

suite : Test
suite =
  describe "Game of life rules"
    [ gameOfLifeTest "One cell should die of underpopulation"
      [ "..."
      , ".*."
      , "..."
      ]
      [ "..."
      , "..."
      , "..."
      ]
    , gameOfLifeTest "Cells with one neighbour should die of underpopulation"
      [ "...."
      , ".**."
      , "...."
      ]
      [ "...."
      , "...."
      , "...."
      ]
    , gameOfLifeTest "Cells with three neighbours should survive"
      [ "...."
      , ".**."
      , ".**."
      , "...."
      ]
      [ "...."
      , ".**."
      , ".**."
      , "...."
      ]
    , gameOfLifeTest "Cells with two neighbours should survive, and three adjacent cells shoud spawn a new one"
      [ "........"
      , "....*..."
      , "...**..."
      , "........"
      ]
      [ "........"
      , "...**..."
      , "...**..."
      , "........"
      ]
    , gameOfLifeTest "Cells with more than 3 neighbours should die of overpopulation, and three adjacent cells shoud spawn a new one"
      [ "........"
      , "...**..."
      , "...*...."
      , "...**..."
      , "........"
      ]
      [ "........"
      , "...**..."
      , "..*....."
      , "...**..."
      , "........"
      ]
    , test "emptyGrid should create grid of given size" <|
      \_ ->
        emptyGrid 5 5
        |> gridSize
        |> Expect.equal (5, 5)
    ]

gameOfLifeTest : String -> List String -> List String -> Test
gameOfLifeTest desc sampleInput expectedOutput =
  test desc <|
  \_ ->
    sample sampleInput
    |> GameOfLife.nextGeneration
    |> Expect.equal (sample expectedOutput)

sample : List String -> Array (Array Cell)
sample grid = List.map (\s -> String.toList s |> List.map char2Cell |> Array.fromList) grid |> Array.fromList

char2Cell : Char -> Cell
char2Cell char = case char of
  '*' -> Occupied
  _ -> Empty
