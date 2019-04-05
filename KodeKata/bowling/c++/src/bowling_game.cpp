// Bowling Code Kata implemented in C++
// By Gunnar Kriik
//

#include <bowling_game.hpp>

BowlingGame::BowlingGame() {}
BowlingGame::~BowlingGame() {}

unsigned BowlingGame::getScore(const vector<string>& frames) {

  unsigned score = 0;

  for(unsigned i = 0 ; i < 10 ; i++) {
      const string frame = frames[i];
      score += toBaseScore(frame);

      if(isSpare(frames[i])) {
          score += getPinsDown(frames[i + 1].at(0));
      } else if(isStrike(frames[i])) {
          score += getStrikeBonus(frames, i);
      }
  }

  return score;
}

unsigned BowlingGame::getStrikeBonus(const vector<string>& frames, unsigned index) {
  string frameN1 = frames[index + 1];
  if(frameN1.length() == 2 && frameN1.at(1) == '/') {
    return 10;
  } else if(frameN1.length() == 2) {
    return getPinsDown(frameN1.at(0)) + getPinsDown(frameN1.at(1));
  } else {
    return 10 + getPinsDown(frames[index + 2].at(0));
  }
}

unsigned BowlingGame::toBaseScore(const string& frame) {
  if(BowlingGame::isStrike(frame) || BowlingGame::isSpare(frame)) {
    return 10;
  }
  return getPinsDown(frame.at(0)) + getPinsDown(frame.at(1));
}

unsigned BowlingGame::getPinsDown(char roll) {
  switch (roll) {
    case '-':
      return 0;
    case 'x':
      return 10;
    default:
      return (int)roll - '0';
  }
}

bool BowlingGame::isStrike(const string& frame) {
  return frame.length() == 1 && frame.find("x") == 0;
}

bool BowlingGame::isSpare(const string& frame) {
  return frame.length() == 2 && frame.find("/") != std::string::npos;
}
