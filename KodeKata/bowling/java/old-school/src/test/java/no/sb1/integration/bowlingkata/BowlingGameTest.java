package no.sb1.integration.bowlingkata;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

public class BowlingGameTest {

    @Test
    public void getTotalScoreSimpleTest() {
        BowlingGame bowlingGame = new BowlingGame();
        bowlingGame.setInputScore("9- 9- 9- 9- 9- 9- 9- 9- 9- 9-");
        assertThat(bowlingGame.getTotalScore()).isEqualTo(90);
    }

    @Test
    public void getTotalScoreStrikeTest() {
        BowlingGame bowlingGame = new BowlingGame();
        bowlingGame.setInputScore("X X X X X X X X X X X X");
        assertThat(bowlingGame.getTotalScore()).isEqualTo(300);
    }

    @Test
    public void getTotalScoreSpareTest() {
        BowlingGame bowlingGame = new BowlingGame();
        bowlingGame.setInputScore("5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/ 5/5");
        int totalScore = bowlingGame.getTotalScore();
        assertThat(totalScore).isEqualTo(150);
    }
}
