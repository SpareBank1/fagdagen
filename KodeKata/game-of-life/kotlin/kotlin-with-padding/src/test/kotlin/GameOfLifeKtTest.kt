import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Test
import kotlin.math.exp

internal class GameOfLifeKtTest {

    @Test
    fun `read initial state with one live cell`() {
        val world = createWorld(listOf("Generation: 1", "1 1", "*"))
        checkSumAndDimension(world, 1, Pair(3, 3))
    }

    @Test
    fun `read initial state with one dead cell`() {
        val world = createWorld(listOf("Generation: 1", "1 1", "."))
        checkSumAndDimension(world, 0, Pair(3, 3))
    }

    @Test
    fun `read initial state with kata board`() {
        val world = createWorld(
            listOf(
                "Generation: 1", "4 8",
                "........",
                "....*...",
                "...**...",
                "........"
            )
        )
        checkSumAndDimension(world, 3, Pair(6, 10))
    }

    private fun checkSumAndDimension(board: List<IntArray>, expectedTotal: Int, expectedDimension: Pair<Int, Int>) {
        var total = 0
        assertEquals(expectedDimension.first, board.size)
        board.forEach {
            assertEquals(expectedDimension.second, it.size)
            total += it.sum()
        }
        assertEquals(expectedTotal, total)
    }

    // Rule 1
    @Test
    fun `cell with zero live neighbours dies`() {
        assertEquals(0, liveOrLetDie(1, intArrayOf(0, 0, 0, 0, 0, 0, 0, 0)))
    }

    @Test
    fun `any live cell with less than two live neighbours, dies`() {
        assertEquals(0, liveOrLetDie(1, intArrayOf(0, 0, 0, 0, 0, 0, 1, 0)))
    }

    // Rule 2
    @Test
    fun `a live cell with more than three live neighbours, dies`() {
        assertEquals(0, liveOrLetDie(1, intArrayOf(0, 0, 1, 1, 1, 0, 1, 0)))
    }

    // Rule 3
    @Test
    fun `live cell with exactly two live neighbours survives`() {
        assertEquals(1, liveOrLetDie(1, intArrayOf(0, 0, 0, 0, 0, 0, 1, 1)))
    }

    @Test
    fun `live cell with exactly three live neighbours survives`() {
        assertEquals(1, liveOrLetDie(1, intArrayOf(0, 0, 1, 1, 0, 0, 1, 0)))
    }

    // Rule 4
    @Test
    fun `any dead cell with exactly three live neighbours becomes a live cell`() {
        assertEquals(1, liveOrLetDie(0, intArrayOf(0, 0, 1, 1, 0, 0, 1, 0)))
    }

    @Test
    fun `dead cell with exactly two live neighbours is still dead`() {
        assertEquals(0, liveOrLetDie(0, intArrayOf(0, 0, 0, 0, 0, 0, 1, 1)))
    }

    @Test
    fun `slice`() {
        val world = createWorld(
            listOf(
                "Generation: 1", "4 8",
                "........",
                "....*...",
                "...**...",
                "........"
            )
        )
        val slice = extractSlice(world, Pair(1, 1))
        val expected = Pair(0, intArrayOf(0, 0, 0, 0, 0, 0, 0, 0))
        assertEquals(expected.first, slice.first)
        assertTrue(expected.second.contentEquals(slice.second))
    }

    @Test
    fun `slice with live cells`() {
        val world = createWorld(
            listOf(
                "Generation: 1", "4 8",
                "........",
                "....*...",
                "...**...",
                "........"
            )
        )
        val slice = extractSlice(world, Pair(2, 5))
        val expected = Pair(1, intArrayOf(0, 0, 0, 0, 0, 1, 1, 0))
        assertEquals(expected.first, slice.first)
        assertTrue(expected.second.contentEquals(slice.second))
    }

    @Test
    fun `next generation`() {
        val world = createWorld(
            listOf(
                "Generation: 1", "4 8",
                "........",
                "....*...",
                "...**...",
                "........"
            )
        )
        checkSumAndDimension(nextGeneration(world), 4, Pair(6, 10))
    }

    @Test
    fun `next generation content compare`() {
        val world = nextGeneration(createWorld(
            listOf(
                "Generation: 1", "4 8",
                "........",
                "....*...",
                "...**...",
                "........"
            )
        ))
        val expected =
            listOf(
                intArrayOf(0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                intArrayOf(0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                intArrayOf(0, 0, 0, 0, 1, 1, 0, 0, 0, 0),
                intArrayOf(0, 0, 0, 0, 1, 1, 0, 0, 0, 0),
                intArrayOf(0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                intArrayOf(0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
            )
        world.forEachIndexed { i, _ ->
            print(i)
            println(":")
            expected[i].forEach { print(it) }
            println("/")
            world[i].forEach { print(it) }
            println()
            assertTrue(expected[i].contentEquals(world[i]))
        }
    }

    @Test
    fun `next generation content compare 2`() {
        val world = nextGeneration(createWorld(
            listOf(
                "Generation: 1", "2 2",
                "..",
                ".*"
            )
        ))
        val expected =
            listOf(
                intArrayOf(0, 0, 0, 0),
                intArrayOf(0, 0, 0, 0),
                intArrayOf(0, 0, 0, 0),
                intArrayOf(0, 0, 0, 0)
            )
        world.forEachIndexed { i, _ ->
            print(i)
            println(":")
            expected[i].forEach { print(it) }
            println("/")
            world[i].forEach { print(it) }
            println()
            assertTrue(expected[i].contentEquals(world[i]))
        }
    }

}