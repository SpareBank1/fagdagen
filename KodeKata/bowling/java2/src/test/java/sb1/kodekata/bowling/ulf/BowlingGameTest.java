package sb1.kodekata.bowling.ulf;

import org.junit.Assert;
import org.junit.Test;

import java.util.Arrays;

public class BowlingGameTest {

    @Test
    public void canCalculateWhenOnlyStrikes() {
        BowlingGame bowlingGame = new BowlingGame(Arrays.asList("X", "X", "X", "X", "X", "X", "X", "X", "X", "X", "X", "X"));
        Assert.assertEquals(300, bowlingGame.score());
    }

    @Test
    public void canCalculateWhenAlmostOnlyStrikes() {
        BowlingGame bowlingGame = new BowlingGame(Arrays.asList("X", "X", "33", "X", "X", "X", "7/", "X", "X", "X", "X", "X"));
        Assert.assertEquals(232, bowlingGame.score());
    }

    @Test
    public void canCalculateWhenOnlyStrikesButTheLast() {
        BowlingGame bowlingGame = new BowlingGame(Arrays.asList("X", "X", "X", "X", "X", "X", "X", "X", "X", "X", "X", "5"));
        Assert.assertEquals(295, bowlingGame.score());
    }

    @Test
    public void canCalculateWhenOnlyMisses() {
        BowlingGame bowlingGame = new BowlingGame(Arrays.asList("--", "--", "--", "--", "--", "--", "--", "--", "--", "--"));
        Assert.assertEquals(0, bowlingGame.score());
    }

    @Test
    public void canCalculateWhenStrikesInBetween() {
        BowlingGame bowlingGame = new BowlingGame(Arrays.asList("X", "9-", "9-", "9-", "X", "9-", "9-", "9-", "9-", "9-"));
        Assert.assertEquals(110, bowlingGame.score());
    }

    @Test
    public void canCalculateWhenOnlyNines() {
        BowlingGame bowlingGame = new BowlingGame(Arrays.asList("9-", "9-", "9-", "9-", "9-", "9-", "9-", "9-", "9-", "9-"));
        Assert.assertEquals(90, bowlingGame.score());
    }

    @Test
    public void canCalculateWhenOnlyNines2() {
        BowlingGame bowlingGame = new BowlingGame(Arrays.asList("81", "81", "81", "81", "81", "81", "81", "81", "81", "81"));
        Assert.assertEquals(90, bowlingGame.score());
    }

    @Test
    public void canCalculateWhenSpares() {
        BowlingGame bowlingGame = new BowlingGame(Arrays.asList("5/", "5/", "5/", "5/", "5/", "5/", "5/", "5/", "5/", "5-"));
        Assert.assertEquals((9*15) + 5, bowlingGame.score());
    }

    @Test
    public void canCalculateWhenSpareInLastThrow() {
        BowlingGame bowlingGame = new BowlingGame(Arrays.asList("5/", "5/", "5/", "5/", "5/", "5/", "5/", "5/", "5/", "5/", "5"));
        Assert.assertEquals(150, bowlingGame.score());
    }


}