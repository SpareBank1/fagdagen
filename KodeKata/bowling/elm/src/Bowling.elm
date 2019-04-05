module Bowling exposing (bowlingScore)

{-| Calculate the total score of a bowling line. Line is given as a String.
Each frame must be separated by a space. Spaces between last frame and bonus
rolls are optional.

    bowlingScore "12 9- 3/ X X 45 67 89 9- X99"

-}
bowlingScore : String -> Int
bowlingScore line =
  let
    frameRolls = String.split " " line |> List.take 10 |>
      List.concatMap (\s -> String.split "" <| if (String.left 1 s) == "X" then "X" else String.left 2 s)
    allRolls = String.replace " " "" line |> String.split ""
    firstBonus = (List.drop 1 allRolls) ++ ["-"]
    secondBonus = (List.drop 2 allRolls) ++ ["-", "-"]
  in
    List.map3 score frameRolls firstBonus secondBonus |> List.sum

score : String -> String -> String -> Int
score r1 r2 r3 = case (r1, r2, r3) of
  ("X", _, "/") -> 20
  ("X", s2, s3) -> 10 + (pins s2) + (pins s3)
  (_, "/", s3) -> 10 + (pins s3)
  (s1, _, _) -> pins(s1)

pins : String -> Int
pins str = case str of
  "X" -> 10
  "/" -> 0 -- Spare is handled in score function, ignore it here
  "-" -> 0
  s   -> String.toInt s |> Maybe.withDefault 0 -- Ignore illegal input
