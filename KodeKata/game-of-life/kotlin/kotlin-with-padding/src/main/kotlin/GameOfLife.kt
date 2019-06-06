import java.io.File

const val PADDING_SIZE = 2
const val PADDING_VALUE = 0
const val ALIVE = 1
const val DEAD = 0

fun main(args: Array<String>) {
    createWorld(readFile(args[0]))
}

fun createWorld(lines: List<String>): List<IntArray> {
    return createBoard(parseDimensions(lines[1]), lines.subList(2, lines.size))
}

fun createBoard(dim: Pair<Int, Int>, cellLines: List<String>): List<IntArray> {
    val paddingRow = IntArray(dim.second) { PADDING_VALUE }
    val elements = cellLines.map { rowOfCells(it) }
    return listOf(paddingRow, *elements.toTypedArray(), paddingRow)
}

fun rowOfCells(line: String): IntArray {
    return intArrayOf(PADDING_VALUE, *line.toInts(), PADDING_VALUE)
}

private fun String.toInts(): IntArray {
    return map {
        when (it) {
            '*' -> ALIVE
            else -> DEAD
        }
    }.toIntArray()
}

private fun readFile(filename: String): List<String> {
    return File(filename).useLines { it.toList() }
}

private fun parseDimensions(line: String): Pair<Int, Int> {
    val dimensions = line.toList().filter { it != ' ' }
    val rows: Int = dimensions[0].toString().toInt() + PADDING_SIZE
    val cols: Int = dimensions[1].toString().toInt() + PADDING_SIZE

    return Pair(rows, cols)
}

fun liveOrLetDie(currentCell: Int, neighbours: IntArray): Int {
    val liveNeighbours = neighbours.sum()
    if (liveCellWithExactlyTwoLiveNeighbours(currentCell, liveNeighbours)) {
        return ALIVE
    }
    if (anyCellWithExactlyThreeLiveNeighbours(liveNeighbours)) {
        return ALIVE
    }
    return DEAD
}

private fun anyCellWithExactlyThreeLiveNeighbours(sum: Int) = sum == 3

private fun liveCellWithExactlyTwoLiveNeighbours(currentCell: Int, sum: Int) =
    currentCell == 1 && sum == 2

fun extractSlice(world: List<IntArray>, position: Pair<Int, Int>): Pair<Int, IntArray> {
    val cell = world[position.first][position.second]
    return Pair(cell, intArrayOf(
        world[position.first - 1][position.second - 1],
        world[position.first - 1][position.second],
        world[position.first - 1][position.second + 1],
        world[position.first][position.second - 1],
        world[position.first][position.second + 1],
        world[position.first + 1][position.second - 1],
        world[position.first + 1][position.second],
        world[position.first + 1][position.second + 1]))
}

fun nextGeneration(world: List<IntArray>): List<IntArray> {
    val next = mutableListOf<IntArray>()
    val paddedCols = world[0].size
    val cols = paddedCols - 2
    val rows = world.size - 2

    next.add(0, IntArray(paddedCols) { PADDING_VALUE })
    for (row in 1..rows) {
        next.add(row, IntArray(paddedCols) { PADDING_VALUE })
        for (col in 1..cols) {
            val (cell, neighbours) = extractSlice(world, Pair(row, col))
            next[row][col] = liveOrLetDie(cell, neighbours)
        }
    }
    next.add(IntArray(paddedCols) { PADDING_VALUE })
    return next
}
