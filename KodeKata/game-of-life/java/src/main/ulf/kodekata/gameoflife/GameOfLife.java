package ulf.kodekata.gameoflife;

import java.util.Arrays;

class GameOfLife {
    private boolean[][] grid;

    GameOfLife(boolean[][] grid) {
        this.grid = grid;
    }

    boolean[][] grid() {
        return grid;
    }

    int numberOfRows() {
        return grid.length;
    }

    int numberOfCols() {
        return grid[0].length;
    }

    void nextGeneration() {
        boolean[][] nextGen = Arrays.stream(grid).map(boolean[]::clone).toArray(boolean[][]::new);

        for (int r = 0; r < numberOfRows(); r++) {
            for (int c = 0; c < numberOfCols(); c++) {
                int aliveNeighbours = aliveNeighbours(r, c);

                if (isAlive(r, c)) {
                    nextGen[r][c] = aliveNeighbours == 2 || aliveNeighbours == 3;
                } else {
                    if (aliveNeighbours == 3) {
                        nextGen[r][c] = true;
                    }
                }
            }
        }
        this.grid = nextGen;
    }

    int aliveNeighbours(int row, int col) {
        int alive = 0;
        for (int r = row - 1; r <= row + 1; r++) {
            for (int c = col - 1; c <= col + 1; c++) {
                if (isInGrid(r, c)) {
                    if ((r != row || c != col) && isAlive(r, c)) {
                        alive++;
                    }
                }
            }
        }
        return alive;
    }

    private boolean isInGrid(int r, int c) {
        return r >= 0 && c >= 0 && r < grid.length && c < grid[0].length;
    }

    private boolean isAlive(int row, int col) {
        return grid[row][col];
    }

}
