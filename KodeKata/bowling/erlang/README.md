# Bowling code kata in Erlang

## Prerequisites
Install [Erlang](https://www.erlang.org/downloads) on your machine. Then enter the Erlang emulator using the ```erl``` command and enter the commands below to execute the code.

```
erl
> c(bowling).
> c(tests).
> eunit:test(tests).

> bowling:score("x x x x x x x x x x x x").
> bowling:score("x x x x x x x x x 36").
> bowling:score("x -- -- -- -- -- -- -- -- --").

> eunit:test(tests). %% or tests:test().
```

By [Gunnar Kriik](https://github.com/GKR)
