module GameOfLife exposing (..)

import Array exposing (..)
import Random exposing (..)
import Random.Array exposing (array)

type Cell = Empty | Occupied
type alias Grid = Array (Array Cell)

nextGeneration : Grid -> Grid
nextGeneration grid = Array.indexedMap (\row columns -> Array.indexedMap (\col cell ->
  let
    n = neighbours (row, col) grid
  in
    case cell of
      Empty -> if n == 3 then Occupied else Empty
      Occupied -> if n < 2 || n > 3 then Empty else Occupied
  ) columns) grid

neighbours : (Int, Int) -> Grid -> Int
neighbours coord grid =
  let
    (row, column) = coord
  in
    List.map (\(r, c) -> (row + r, column + c)) [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1)]
    |> List.map (\(r, c) -> Array.get r grid |> Maybe.map (\columns -> Array.get c columns |> Maybe.withDefault Empty))
    |> List.filter (\c -> c == Just Occupied)
    |> List.length

emptyGrid : Int -> Int -> Grid
emptyGrid rows columns =
  Array.repeat rows (Array.repeat columns Empty)

randomGrid : Int -> Int -> Generator Grid
randomGrid rows columns = array rows (array columns cellGenerator)

preDefGrid : Int -> Int -> Array (Int, Int) -> Result String Grid
preDefGrid rows columns occupiedCells =
  let
    grid = emptyGrid rows columns
  in
    Array.foldl occupyCell (Ok grid) occupiedCells

occupyCell : (Int, Int) -> Result String Grid -> Result String Grid
occupyCell coord grid =
  let
    (row, col) = coord
  in
    flatMap (\g ->
      Array.get row g
      |> Result.fromMaybe ("row " ++ (String.fromInt row) ++ " is out of bounds")
      |> flatMap (\r ->
        case Array.get col r of
          Nothing -> Err ("column " ++ (String.fromInt col) ++ "is out of bounds")
          Just _ -> Ok r
        )
      |> Result.map (\r -> Array.set row (Array.set col Occupied r) g)
      ) grid


cellGenerator : Generator Cell
cellGenerator = Random.weighted (70, Empty) [ (30, Occupied) ]

gridSize : Grid -> (Int, Int)
gridSize grid = (Array.length grid, (Array.get 0 grid) |> Maybe.map Array.length |> Maybe.withDefault 0)

join : Result x (Result x a) -> Result x a
join mx =
    case mx of
        Ok x ->
            x

        Err err ->
            Err err

flatMap : (a -> Result x b) -> Result x a -> Result x b
flatMap f result =
    Result.map f result
        |> join
