package bowling_kata_01__test

import (
	"strconv"
	"testing"
	"unicode"
)

func valueOfShot(shots string, i int) int {
	r := []rune(shots)
	if i >= len(shots) || shots[i] == '-' {
		return 0
	}
	if shots[i] == 'X' || shots[i] == '/' {
		return 10
	}
	if unicode.IsDigit(r[i]) {
		v, _ := strconv.Atoi(string(shots[i]))
		return v
	}
	return 0
}

func calculate(shots string) int {
	result := 0
	for i := range shots {
		result += addShot(shots, i)
	}
	return result
}

func addShot(shots string, currentShot int) int {
	numberOfShots := len(shots)
	v := valueOfShot(shots, currentShot)
	shot := shots[currentShot]
	if shot == 'X' && currentShot < numberOfShots-3 {
		v += strike(shots, currentShot)
	}
	if shot == '/' && currentShot < numberOfShots-2 {
		v += regularSpare(shots, currentShot)
	}
	if shot == '/' && currentShot >= numberOfShots-2 {
		v -= tailSpare(shots, currentShot)
	}
	return v
}

func tailSpare(shots string, i int) int {
	return valueOfShot(shots, i-1)
}

func regularSpare(shots string, i int) int {
	return valueOfShot(shots, i+1) - valueOfShot(shots, i-1)
}

func strike(shots string, i int) int {
	return valueOfShot(shots, i+1) + valueOfShot(shots, i+2)
}

func TestScore(t *testing.T) {
	table := []struct {
		shots         string
		expectedScore int
	}{
		{shots: "--------------------", expectedScore: 0},
		{shots: "1-------------------", expectedScore: 1},
		{shots: "2-------------------", expectedScore: 2},
		{shots: "21------------------", expectedScore: 3},
		{shots: "212-----------------", expectedScore: 5},
		{shots: "212----------------1", expectedScore: 6},
		{shots: "X------------------", expectedScore: 10},
		{shots: "X1-----------------", expectedScore: 12},
		{shots: "XXXXXXXXXXXX", expectedScore: 300},
		{shots: "9-9-9-9-9-9-9-9-9-9-", expectedScore: 90},
		{shots: "1/------------------", expectedScore: 10},
		{shots: "1/------------------", expectedScore: 10},
		{shots: "------------------1/X", expectedScore: 20},
		{shots: "------------------XXX", expectedScore: 30},
		{shots: "----------------1/8/-", expectedScore: 28},
		{shots: "X--------------1/8/-", expectedScore: 38},
		{shots: "X-------6------1/8/-", expectedScore: 44},
		{shots: "-1X1/--2/X5/32X2-", expectedScore: 103},
	}
	for _, td := range table {
		t.Run(td.shots, func(t *testing.T) {
			result := calculate(td.shots)
			if result != td.expectedScore {
				t.Errorf("Expecting result to be %d, was %d",
					td.expectedScore, result)
			}
		})
	}
}

func TestValueOfShot(t *testing.T) {
	table := []struct {
		desc          string
		shots         string
		index         int
		expectedValue int
	}{
		{"first shot miss", "-", 0, 0},
		{"first shot, 1 point", "1", 0, 1},
		{"first shot, 2 points", "2", 0, 2},
		{"second shot, 2 points", "12", 1, 2},
		{"first shot, 10 points", "X2", 0, 10},
		{"second shot, 10 points", "1/", 1, 10},
		{"index out of range", "5", 9, 0},
	}
	for _, td := range table {
		t.Run(td.desc, func(t *testing.T) {
			v := valueOfShot(td.shots, td.index)
			if v != td.expectedValue {
				t.Errorf("When shot is '%s', then value of shot #%d should be %d, was %d",
					td.shots, td.index, td.expectedValue, v)
			}

		})
	}
}
