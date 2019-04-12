package no.sb1.integration.bowlingkata;

public class Roll {

    private int rollScore = 0;

    public void setToken(char token) {
        switch (token) {
            case 'X':
                rollScore = 10;
                break;
            case '/':
                rollScore = 10;
                break;
            case '-':
                rollScore = 0;
                break;
            default:
                rollScore = Character.getNumericValue(token);
        }
    }

    public int getRollScore() {
        return rollScore;
    }

}
