module Bowling exposing (..)

{-| Calculate the total score of a bowling line. Line is given as a String.
Each frame must be separated by a space. Spaces between last frame and bonus
rolls are optional.

    bowlingScore "12 9- 3/ X X 45 67 89 9- X99"

-}
type Line = Line (List Frame) (Maybe Int)
type Frame = Frame Roll (Maybe Roll) (Maybe Roll) (Maybe Int)
type Roll = Strike | Spare | Pins Int

charToRoll : Char -> Result String Roll
charToRoll c =
  let
    err = "Not a valid bowling roll"
  in
    case c of
      '-' -> Ok (Pins 0)
      'X' -> Ok Strike
      '/' -> Ok Spare
      p   ->
        case String.toInt (String.fromChar p) of
          Just n -> if n >= 1 && n <=9 then Ok (Pins n) else Err err
          Nothing -> Err err

rollValue : Roll -> Int
rollValue roll = case roll of
  Strike -> 10
  Spare -> 10
  Pins n -> n

stringToFrames : String -> List Frame
stringToFrames str = rollsToFrames <| stringToRolls str

stringToRolls : String -> List Roll
stringToRolls str = String.toList str |> List.map (\c -> Result.toMaybe <| charToRoll c) |> List.filterMap identity

rollsToFrames : List Roll -> List Frame
rollsToFrames rolls =
  let
    bonus1 = (List.drop 1 rolls) ++ [Pins 0]
    bonus2 = (List.drop 2 rolls) ++ [Pins 0, Pins 0]
  in
    List.map3 (\r1 r2 r3 -> (r1, r2, r3)) rolls bonus1 bonus2 |> rollsToFrame Nothing |> List.take 10

rollsToFrame : Maybe Roll -> List (Roll, Roll, Roll) -> List Frame
rollsToFrame lastRoll rolls =
  case (lastRoll, List.head rolls) of
    (_, Nothing) -> []
    (Just (Pins n1), Just (Pins n2, _, _)) -> [Frame (Pins n1) (Just (Pins n2)) Nothing (Just (n1 + n2))] ++ (rollsToFrame Nothing (tail rolls))
    (Nothing, Just (Strike, r2, r3)) -> [Frame Strike (Just r2) (Just r3) (Just (10 + (rollValue r2) + (rollValue r3)))] ++ (rollsToFrame Nothing (tail rolls))
    (Nothing, Just (r1, Spare, r3)) -> [Frame r1 (Just Spare) (Just r3) (Just (10 + (rollValue r3)))] ++ (rollsToFrame Nothing (tail rolls))
    (Nothing, Just (Pins n, Pins _, _)) -> rollsToFrame (Just(Pins n)) (tail rolls)
    _ -> rollsToFrame Nothing (tail rolls)

tail : List a -> List a
tail list = List.tail list |> Maybe.withDefault []

bowlingScore : String -> Int
bowlingScore line = bowlingFrameScores line |> List.sum

bowlingFrameScores : String -> List Int
bowlingFrameScores line =
  let
    frameRolls = String.split " " line |> List.take 10 |>
      List.concatMap (\s -> String.split "" <| if (String.left 1 s) == "X" then "X" else String.left 2 s)
    allRolls = String.replace " " "" line |> String.split ""
    firstBonus = (List.drop 1 allRolls) ++ ["-"]
    secondBonus = (List.drop 2 allRolls) ++ ["-", "-"]
  in
    List.map3 score frameRolls firstBonus secondBonus

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
