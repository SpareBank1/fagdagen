-module(tests).
-compile([export_all, debug_info]).
-include_lib("eunit/include/eunit.hrl").

truth_test() ->
  ?assert(true).

bowling_1_test() ->
  ?assertEqual(300, bowling:score("x x x x x x x x x x x x")).

bowling_2_test() ->
  ?assertEqual(261, bowling:score("x x x x x x x x x 36")).

bowling_3_test() ->
  ?assertEqual(0, bowling:score("-- -- -- -- -- -- -- -- -- --")).

bowling_4_test() ->
  ?assertEqual(122, bowling:score("x 1/ x 2/ -- x 42 x 1/ --")).
