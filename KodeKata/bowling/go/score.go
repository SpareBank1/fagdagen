package score

type Frame struct {
	throw1Score int
	throw2Score int
}

func (frame *Frame) isStrike() bool {
	return frame.throw1Score == 10
}

func (frame *Frame) isSpare() bool {
	return frame.throw1Score != 10 && (frame.throw1Score + frame.throw2Score == 10)
}

func calculateScore(frames []Frame) int {
	sum := 0
	for i := 0; i < 10; i++ {
		sum += calculateFrame(frames[i], frames[i+1], frames[i+2])
	}
	return sum
}

func calculateFrame(current Frame, next Frame, third Frame) int {
	if current.isStrike() {
		if next.isStrike() {
			return current.throw1Score + next.throw1Score + third.throw1Score
		} else {
			return 10 + next.throw1Score + next.throw2Score
		}
	} else if current.isSpare() {
		return 10 + next.throw1Score
	} else {
		return current.throw1Score + current.throw2Score
	}
}