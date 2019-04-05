# Bowling code kata solved in elm

#### Prerequisites
Install elm: https://elm-lang.org/

#### To run unit tests:

Make sure Node.js/npm is installed.

```
$ npm install -g elm-test
$ cd fagdagen/KodeKata/bowling/elm
$ elm-test
```

#### Run from repl
```
$ cd fagdagen/KodeKata/bowling/elm
$ elm make src/Bowling.elm
$ elm repl
> import Bowling exposing (bowlingScore)
> bowlingScore "X X X X X X X X X X X X"
300 : Int
```
