package no.sb1.kata.bowling

import no.sb1.kata.BowlingGame
import org.junit.Test

import org.junit.Assert.*

data class TestCase (val testCase:String, val score: Int) {
    companion object {
        val STRIKE_ONLY = TestCase("X X X X X X X X X X X X",300)
        val NINE_MISS_ONLY = TestCase("9- 9- 9- 9- 9- 9- 9- 9- 9- 9-",90)
        val FIVE_SPEAR_ONLY = TestCase("5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/5",150)
        val MIXED_CASE = TestCase("9/ 51 51 51 x x x 1- x 9/2",128)
        val MIXED_CASE2 = TestCase("2/ 7/ 45 6/ X X X 9/ 00 x7/",169)
    }
}

class BowlingGameTest {

    @Test
    fun testStrikeOnly() { verifyCase(TestCase.STRIKE_ONLY) }

    @Test
    fun testFiveSPearOnly() { verifyCase(TestCase.FIVE_SPEAR_ONLY) }

    @Test
    fun testNineMissOnly() { verifyCase(TestCase.NINE_MISS_ONLY) }

    @Test
    fun testMixedCase() { verifyCase(TestCase.MIXED_CASE) }

    @Test
    fun testMixedCase2() { verifyCase(TestCase.MIXED_CASE2) }

    fun verifyCase(case:TestCase) {
        val score = BowlingGame.calculateGame(case.testCase)
        assertEquals(case.score,score)
    }
}