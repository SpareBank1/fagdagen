package ulf.kodekata.gameoflife;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class GameOfLifeUi extends JPanel implements ActionListener {

    public static void main(String[] args) {
        boolean[][] initGrid = GameOfTextUi.linje().grid();

        GameOfLifeUi panel = new GameOfLifeUi(new GameOfLife(initGrid));
        JFrame frame = new JFrame();
        frame.setTitle("Game of Life");
        frame.setSize(panel.game.numberOfCols() * SQUARE_SIZE + 5, panel.game.numberOfRows() * SQUARE_SIZE + 27);
        frame.setVisible(true);
        frame.setResizable(false);
        frame.add(panel);
    }

    private static int SQUARE_SIZE = 10;
    private Timer timer = new Timer(500, this);
    private GameOfLife game;

    private GameOfLifeUi(GameOfLife game) {
        this.game = game;
        setBackground(Color.black);
        timer.start();
    }

    @Override
    public void paintComponent(Graphics g) {
        super.paintComponent(g);
        for (int row = 0; row < game.numberOfRows(); row++) {
            for (int col = 0; col < game.numberOfCols(); col++) {
                g.setColor(game.grid()[row][col] ? Color.pink : Color.gray);
                g.fillRect(col * SQUARE_SIZE, row * SQUARE_SIZE, SQUARE_SIZE - 1, SQUARE_SIZE - 1);
            }
        }
        timer.start();
    }

    public void actionPerformed(ActionEvent e) {
        game.nextGeneration();
        repaint();
    }

}