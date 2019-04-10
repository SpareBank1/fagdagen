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

#### How to build the demo
```
$ cd fagdagen/KodeKata/bowling/elm
$ elm make --output BowlingScoreCard.js src/BowlingScoreCard.elm
Success!
$ elm reactor
Go to <http://localhost:8000> to see your project dashboard.
```
Navigate to http://localhost:8000/index.html
