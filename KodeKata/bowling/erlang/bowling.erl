%% Bowling Code Kata implemented in Erlang
%% By Gunnar Kriik
%%

-module(bowling).
-export([score/1]).

to_integer(Str) -> {Int, _} = string:to_integer(Str), Int.

%% Split string to array. "12" -> ["1", "2"]
to_array(Frame) -> [[X] || X <- Frame].

%% Calculate base frame score
frame_score(["-", "-"]) -> 0;
frame_score(["x"]) -> 10;
frame_score([_, "/"]) -> 10;
frame_score(["-", Number]) -> to_integer(Number);
frame_score([Number, "-"]) -> to_integer(Number);
frame_score([Number1, Number2]) -> to_integer(Number1) + to_integer(Number2).

%% Calculate spare bonus
spare_bonus(["-", _]) -> 0;
spare_bonus(["x"]) -> 10;
spare_bonus([Number, _]) -> to_integer(Number);
spare_bonus([Number]) -> to_integer(Number).

%% Calculate strike bonus
strike_bonus(["-", "-"], _) -> 0;
strike_bonus(["x"], ["-", _]) -> 10;
strike_bonus(["x"], ["x"]) -> 20;
strike_bonus([_, "/"], _) -> 10;
strike_bonus(["-", Number], _) -> to_integer(Number);
strike_bonus(["x"], [Number, _]) -> to_integer(Number) + 10;
strike_bonus([Number, "-"], _) -> to_integer(Number);
strike_bonus([Number1, Number2], _) -> to_integer(Number1) + to_integer(Number2).

%% Calculate bonus score
bonus_score([_, "/"], [Frame1|_]) -> spare_bonus(to_array(Frame1));
bonus_score(["x"], [Frame1, Frame2|_]) -> strike_bonus(to_array(Frame1), to_array(Frame2));
bonus_score(["x"], [Frame1]) -> frame_score(to_array(Frame1));
bonus_score(_, _) -> 0.
  
%% Calculate base score
base_score(Frames) -> base_score(Frames, 0, 0).
base_score([Head|Tail], Acc, Index) when Index < 10 ->
  Frame = to_array(Head),
  base_score(Tail, Acc + frame_score(Frame) + bonus_score(Frame, Tail), Index + 1);
base_score(_, Acc, _) -> Acc.

%% Main entry point
%% Examples:
%%   bowling:score("x x x x x x x x x x x x")   -> 300
%%   bowling:score("x x x x x x x x x 36")      -> 261
%%   bowling:score("x 1/ x 2/ -- x 42 x 1/ --") -> 122
score(ScoreStr) -> 
  base_score(string:tokens(ScoreStr, " ")).
