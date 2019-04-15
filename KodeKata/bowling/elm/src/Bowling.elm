module Bowling exposing (Line, Frame(..), Roll(..), stringToLine, charToRoll)

type alias Line =
  { frames : List Frame
  , score : Maybe Int
  }

type Frame = Frame Roll Roll (Maybe Roll) (Maybe Int)
type Roll = Strike | Spare | Pins Int

stringToLine : String -> Line
stringToLine lineStr =
  let
    frames = stringToFrames lineStr
    score = totalScore frames
  in
    Line frames score

totalScore : List Frame -> Maybe Int
totalScore frames =
  List.foldl (\frame score -> Maybe.map2 (+) (frameScore frame) score) (Just 0) frames

frameScore : Frame -> Maybe Int
frameScore frame =
  case frame of
    Frame _ _ _ score -> score

stringToFrames : String -> List Frame
stringToFrames str = str
  |> stringToRolls
  |> rollsToFrames

stringToRolls : String -> List Roll
stringToRolls str = str
  |> String.toList
  |> List.map (\c -> charToRoll c |> Result.toMaybe)
  |> List.filterMap identity

rollsToFrames : List Roll -> List Frame
rollsToFrames rolls =
  let
    bonus1 = (List.drop 1 rolls) ++ [Pins 0]
    bonus2 = (List.drop 2 rolls) ++ [Pins 0, Pins 0]
  in
    List.map3 (\r1 r2 r3 -> (r1, r2, r3)) rolls bonus1 bonus2
    |> recursiveRollsToFrames Nothing
    |> List.take 10

recursiveRollsToFrames : Maybe Roll -> List (Roll, Roll, Roll) -> List Frame
recursiveRollsToFrames lastRoll rolls =
  case (lastRoll, List.head rolls) of
    (_, Nothing) -> []
    (Nothing, Just (Strike, r2, r3)) ->
      [strike r2 r3] ++ (recursiveRollsToFrames Nothing (tail rolls))
    (Nothing, Just (r1, Spare, r3)) ->
      [spare r1 r3] ++ (recursiveRollsToFrames Nothing (tail rolls))
    (Nothing, Just (Pins n, Pins _, _)) ->
      recursiveRollsToFrames (Just(Pins n)) (tail rolls)
    (Just (Pins n1), Just (Pins n2, _, _)) ->
      [pins (Pins n1) (Pins n2)] ++ (recursiveRollsToFrames Nothing (tail rolls))
    _ -> recursiveRollsToFrames Nothing (tail rolls)

strike : Roll -> Roll -> Frame
strike bonusRoll1 bonusRoll2 = Frame Strike bonusRoll1 (Just bonusRoll2)
  (case bonusRoll2 of
    Spare -> Just 20
    _ -> Just (10 + (rollValue bonusRoll1) + (rollValue bonusRoll2))
  )

spare : Roll -> Roll -> Frame
spare firstRoll bonusRoll = Frame firstRoll Spare (Just bonusRoll) (Just (10 + (rollValue bonusRoll)))

pins : Roll -> Roll -> Frame
pins firstRoll secondRoll = Frame firstRoll secondRoll Nothing (Just ((rollValue firstRoll) + (rollValue secondRoll)))

tail : List a -> List a
tail list = List.tail list |> Maybe.withDefault []

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
