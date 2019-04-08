import FrameType.*

//The different types a frame can be of
enum class FrameType {
    NUMBER, SPARE, STRIKE, TENTHFRAME
}

//Data class representing one frame. It has a frametype and the scores for the individual throws in the frame
class Frame(var type: FrameType, var throws: IntArray)

//The game itself. It takes an arraylist of strings in. Each element represents a frame in the game
class Game(theScoresAsStrings: ArrayList<String>) {

    private val frames : List<Frame>

    init {
        //Start with converting the list of strings to a list of Frames
        frames = toFrames(theScoresAsStrings)
    }

    //Convert from strings to Frames
    fun toFrames(theScoresAsStrings: ArrayList<String>): List<Frame> =
        theScoresAsStrings.mapIndexed { frameNumber, scoreAsString -> toFrame(frameNumber, scoreAsString) }

    //Create a Frame from the string score
    fun toFrame(frameNumber : Int, score: String): Frame {
        var throws = intArrayOf(0, 0, 0)
        var type: FrameType = NUMBER
        for (i in 0 until score.length) {
            when (score[i]) {

                'X' -> {
                    throws[i] = 10
                    type = STRIKE
                }

                '/' -> {
                    throws[i] = 10 - throws[0] //the sum of the two throws shall be 10. Last throw of frame 10 cannot be a spare
                    type = SPARE
                }

                '-' -> {
                    throws[i] = 0
                }

                else -> {
                    throws[i] = score[i].toString().toInt()
                }
            }
        }

        if(frameNumber == 9) type = TENTHFRAME

        return Frame(type, throws)
    }

    //Sum up the Frames. The bowling score rules are here
    fun totalScore(): Int {
        var totalScore = 0
        for (i in 0..9) {
            var frameScore = _1stThrow(i) + _2ndThrow(i) + _3rdThrow(i)
            totalScore += when(frames[i].type) {
                STRIKE ->       frameScore + nextFrame_1stThrow(i) + nextFrame_2ndThrow(i) + if (nextFrame_isStrike(i)) nextNextFrame_1stThrow(i) else 0
                SPARE ->        frameScore + nextFrame_1stThrow(i)
                NUMBER ->       frameScore
                TENTHFRAME ->   frameScore
            }
        }

        return totalScore
    }

    //Extracted functions for better readability
    fun _1stThrow(i : Int) = frames[i].throws[0]
    fun _2ndThrow(i : Int) = frames[i].throws[1]
    fun _3rdThrow(i : Int) = frames[i].throws[2]
    fun nextFrame_1stThrow(i : Int) = frames[i+1].throws[0]
    fun nextFrame_2ndThrow(i : Int) = frames[i+1].throws[1]
    fun nextFrame_isStrike(i : Int) = frames[i+1].type == STRIKE
    fun nextNextFrame_1stThrow(i : Int) = frames[i+2].throws[0]
}
