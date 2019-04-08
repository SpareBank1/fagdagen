package no.sb1.kata

class BowlingGame {
    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            val score = BowlingGame.calculateGame(args.joinToString(separator = ""))
            println("Calculated score: " + score + "\n")
        }

        fun calculateGame(input: String): Int {
            val game = input.replace(Regex("\\s+"), "").toCharArray()
            val lastOrdinaryRoll = game.size - 1 - if (isStrike(game[game.size - 3])) 2 else if (isSpear(game[game.size - 2])) 1 else 0

            var carry = Pair(0, 0)
            var roll = 0
            var total = 0
            game.forEachIndexed { rollCount, chr ->
                roll = parseRollValue(chr, roll)
                val multiplier = carry.first.incrementIf(rollCount <= lastOrdinaryRoll) //Add carry over from previous roll.
                carry = Pair(carry.second, 0) //Slide carry window
                total += multiplier * roll //Update sum so far
                if (rollCount <= lastOrdinaryRoll) carry = incrementCarry(carry, chr) //Increment carry on regular frames only
            }
            return total
        }

        private fun parseRollValue(c: Char, previous: Int): Int {
            when (c) {
                'x', 'X' -> return 10
                '/' -> return 10 - previous
                '-', '_' -> return 0
                else -> return Character.getNumericValue(c)
            }
        }

        private fun incrementCarry(m: Pair<Int, Int>, chr: Char): Pair<Int, Int> {
            return Pair(m.first.incrementIf(isStrike(chr) || isSpear(chr)),m.second.incrementIf(isStrike(chr)))
        }

        private fun isStrike(c: Char): Boolean { return Character.toLowerCase(c) == 'x' }

        private fun isSpear(c: Char): Boolean { return c == '/' }

        fun Int.incrementIf(b:Boolean) : Int { return if(b) this.inc() else this }
    }
}