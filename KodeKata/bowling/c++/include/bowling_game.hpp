// Bowling Code Kata implemented in C++
// By Gunnar Kriik
//

#include <string>
#include <vector>

using std::string;
using std::vector;

class BowlingGame {

public:
  BowlingGame();
  ~BowlingGame();

  static unsigned getScore(const vector<string>& frames);

private:
  static unsigned toBaseScore(const string& frame);
  static unsigned getStrikeBonus(const vector<string>& frames, unsigned index);
  static unsigned getPinsDown(char roll);
  static bool isSpare(const string& frame);
  static bool isStrike(const string& frame);

};
