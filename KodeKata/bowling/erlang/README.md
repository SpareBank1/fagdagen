# Bowling code kata in Erlang

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

