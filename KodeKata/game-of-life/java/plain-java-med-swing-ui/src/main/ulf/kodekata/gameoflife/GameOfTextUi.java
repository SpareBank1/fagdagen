package ulf.kodekata.gameoflife;

/**
 * Rules:
 * 1. Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
 * 2. Any live cell with more than three live neighbours dies, as if by overcrowding.
 * 3. Any live cell with two or three live neighbours lives on to the next generation.
 * 4. Any dead cell with exactly three live neighbours becomes a live cell.
 */
public class GameOfTextUi {

    public static void main(String[] args) throws InterruptedException {
        GameOfLife g = glider();
        while (true) {
            render(g);
            g.nextGeneration();
            Thread.sleep(200);
        }
    }

    static void render(GameOfLife game) {
        boolean[][] grid = game.grid();
        for (boolean[] row : grid) {
            for (boolean cell : row) {
                System.out.print(cell ? "*" : "-");
            }
            System.out.println("");
        }
        System.out.println("");
    }

    public static GameOfLife explodingWorld() {
        boolean[][] grid = new boolean[20][20];
        grid[8][10] = true;
        grid[9][9] = true;
        grid[9][10] = true;
        grid[9][11] = true;
        grid[10][9] = true;
        grid[10][11] = true;
        grid[11][10] = true;
        return new GameOfLife(grid);
    }

    public static GameOfLife linje() {
        boolean[][] grid = new boolean[100][100];
        grid[45][46] = true;
        grid[45][47] = true;
        grid[45][48] = true;
        grid[45][49] = true;
        grid[45][50] = true;
        grid[45][51] = true;
        grid[45][52] = true;
        grid[45][53] = true;
        grid[45][54] = true;
        grid[45][55] = true;
        return new GameOfLife(grid);
    }

    public static GameOfLife glider() {
        boolean[][] grid = new boolean[20][20];
        grid[10][10] = true;
        grid[11][11] = true;
        grid[12][9] = true;
        grid[12][10] = true;
        grid[12][11] = true;
        return new GameOfLife(grid);
    }


}
