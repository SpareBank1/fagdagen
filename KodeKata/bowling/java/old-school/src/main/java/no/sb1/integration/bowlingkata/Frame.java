package no.sb1.integration.bowlingkata;

import java.util.ArrayList;
import java.util.List;

public class Frame {
    private boolean isSpare;
    private boolean isStrike;
    private String token;
    List<Roll> rolls = new ArrayList<Roll>();

    public void setToken(String token) {
        this.token = token;
        for (int i = 0; i < token.length(); i++) {
            Roll roll = new Roll();
            roll.setToken(token.charAt(i));
            rolls.add(roll);

            switch (token.charAt(i)) {
                case 'X':
                    isStrike = true;
                    break;
                case '/':
                    isSpare = true;
                    break;
                default:
            }
        }
    }

    public int getFrameScore() {
        int frameScore = 0;
        if (isStrike || isSpare) {
            frameScore = 10;
            if (rolls.size() == 3) {
                // Spare in 10th round, one more bonus roll
                frameScore += rolls.get(2).getRollScore();
            }
        } else {
            for (Roll roll : rolls) {
                frameScore += roll.getRollScore();
            }
        }
        return frameScore;
    }

    public boolean isStrike() {
        return isStrike;
    }

    public boolean isSpare() {
        return isSpare;
    }

    public int getFirstRollScore() {
        return rolls.get(0).getRollScore();
    }

}