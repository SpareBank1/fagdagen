package no.sb1.integration.bowlingkata;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

public class BowlingGame {

    List<Frame> frames = new ArrayList<Frame>();
    int totalScore = 0;
    String inputScore;

    public int getTotalScore() {
        int size = frames.size();
        int totalScore = 0;

        for (int i = 0; i < 10; i++) {
            Frame frame = frames.get(i);
            totalScore += frame.getFrameScore();

            if (frame.isSpare() && i < size - 1) {
                totalScore += frames.get(i + 1).getFirstRollScore();
            } else if (frame.isStrike() && i < size - 2) {
                // We have a strike and at least two frames after this
                int nextFrameScore = frames.get(i + 1).getFrameScore();
                int nextNextRollScore = frames.get(i + 2).getFirstRollScore();

                boolean isNextStrike = frames.get(i + 1).isStrike();
                int bonusScore = isNextStrike ? nextFrameScore + nextNextRollScore : nextFrameScore;
                totalScore += bonusScore;
            } else if (frame.isStrike() && i < size - 1) {
                // We have a strike but only one frame after this i.e. 11th round
                totalScore += frames.get(i + 1).getFrameScore();
            }
        }
        return totalScore;
    }

    public void setTotalScore(int totalScore) {
        this.totalScore = totalScore;
    }

    public String getInputScore() {
        return inputScore;
    }

    public void setInputScore(String inputScore) {
        this.inputScore = inputScore;
        parseInput();
    }

    public List<Frame> getFrames() {
        return frames;
    }

    public void setFrames(List<Frame> frames) {
        this.frames = frames;
    }

    private void parseInput() {
        StringTokenizer st = new StringTokenizer(getInputScore());
        while (st.hasMoreTokens()) {
            String token = st.nextToken();
            Frame frame = new Frame();
            frame.setToken(token);
            frames.add(frame);
        }
    }

}
