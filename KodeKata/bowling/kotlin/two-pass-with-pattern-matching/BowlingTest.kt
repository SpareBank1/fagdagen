import org.junit.jupiter.api.Test
import org.junit.jupiter.api.TestInstance
import kotlin.test.assertEquals

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class BowlingTest {

    @Test
    fun `score a game of 300 correctly`() {
        val aGame = arrayListOf("X", "X", "X", "X", "X", "X", "X", "X", "X", "XXX")
        assertEquals(300, Game(aGame).totalScore())
    }

    @Test
    fun `score a game of 9s correctly`() {
        val aGame = arrayListOf("9-", "9-", "9-", "9-", "9-", "9-", "9-", "9-", "9-", "9-")
        assertEquals(90, Game(aGame).totalScore())
    }

    @Test
    fun `score a game of spares correctly`() {
        val aGame = arrayListOf("5/", "5/", "5/", "5/", "5/", "5/", "5/", "5/", "5/", "5/-")
        assertEquals(145, Game(aGame).totalScore())
    }

    @Test
    fun `score an arbitrary game with strikes, spares and numbers correctly`() {
        val aGame = arrayListOf("X", "50", "5/", "X", "X", "05", "6/", "70", "9/", "XX9")
        assertEquals(153, Game(aGame).totalScore())
    }
}

