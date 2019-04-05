#define CATCH_CONFIG_MAIN  // This tells Catch to provide a main() - only do this in one cpp file
#include "catch.hpp"

#include <bowling_game.hpp>

#include <memory>
#include <string>

using std::shared_ptr;
using std::string;

TEST_CASE( "BowlingGame Test 0", "[game]") {
  unsigned score = BowlingGame::getScore({"--","--","--","--","--","--","--","--","--","--"});
  REQUIRE( score == 0 );
}

TEST_CASE( "BowlingGame Test 1", "[game]") {
  unsigned score = BowlingGame::getScore({"x", "x", "x", "x", "x", "x", "x", "x", "x", "36"});
  REQUIRE( score == 261 );
}

TEST_CASE( "BowlingGame Test 2", "[game]") {
  unsigned score = BowlingGame::getScore({"x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"});
  REQUIRE( score == 300 );
}

TEST_CASE( "BowlingGame Test 3", "[game]") {
  unsigned score = BowlingGame::getScore({"9-", "9-", "9-", "9-", "9-", "9-", "9-", "9-", "9-", "9-"});
  REQUIRE( score == 90 );
}

TEST_CASE( "BowlingGame Test 4", "[game]") {
  unsigned score = BowlingGame::getScore({"5/", "5/", "5/", "5/", "5/", "5/", "5/", "5/", "5/", "5/", "5"});
  REQUIRE( score == 150 );
}

TEST_CASE( "BowlingGame Test 5", "[game]") {
  unsigned score = BowlingGame::getScore({"x","1/","x","2/","--","x","42","x","1/","--"});
  REQUIRE( score == 122 );
}
