package sb1.kodekata.bowling.ulf;

import java.util.List;
import java.util.stream.Collectors;

class BowlingGame {

    private final List<Frame> frames;

    BowlingGame(List<String> frames) {
        this.frames = frames.stream().map(Frame::new).collect(Collectors.toList());
    }

    int score() {
        int score = 0;
        for (int i=0; i<10; i++) {
            Frame frame = frames.get(i);
            if (frame.isStrike()) {
                score += 10 + (frames.get(i + 1).isStrike() ? 10 + frames.get(i + 2).bonusScore() : frames.get(i + 1).score());
            } else if (frame.isSpare()) {
                score += 10 + (frames.get(i + 1).isStrike() ? 10 : frames.get(i + 1).firstRoll());
            } else {
                score += frame.score();
            }
        }
        return score;
    }

    static class Frame {
        private String value;

        Frame(String value) {
            this.value = value;
        }

        boolean isStrike() {
            return "X".equals(value.substring(0,1));
        }

        boolean isSpare() {
            return value.indexOf('/') != -1;
        }

        int score() {
            return isSpare() || isStrike() ? 10 : firstRoll() + secondRoll();
        }

        int bonusScore() {
            return isStrike() ? 10 : firstRoll();
        }

        int firstRoll() {
            return value.charAt(0) != '-' ? Character.getNumericValue(value.charAt(0)) : 0;
        }

        private int secondRoll() {
            return value.charAt(1) != '-' ? Character.getNumericValue(value.charAt(1)) : 0;
        }

    }
}
