package score

import (
	"testing"
)

func TestPerfectGame(t *testing.T) {
	repeated := calculateScore(
		[]Frame{
			{10, 0},
			{ 10, 0},
			{ 10, 0},
			{ 10, 0},
			{ 10, 0},
			{ 10, 0},
			{ 10, 0},
			{ 10, 0},
			{ 10, 0},
			{ 10, 0},
			{ 10, 0},
			{ 10, 0}})
	expected := 300

	if repeated != expected {
		t.Errorf("expected '%d' but got '%d'", expected, repeated)
	}
}

func TestScoreAll9(t *testing.T) {
	repeated := calculateScore(
		[]Frame{
			{ 9, 0},
			{ 9,0},
			{ 9, 0},
			{ 9, 0},
			{ 9, 0},
			{ 9,0},
			{ 9, 0},
			{ 9, 0},
			{ 9, 0},
			{ 9, 0},
			{ 0, 0},
			{ 0, 0},})
	expected := 90

	if repeated != expected {
		t.Errorf("expected '%d' but got '%d'", expected, repeated)
	}
}

func TestScoreBadPlayer(t *testing.T) {
	repeated := calculateScore(
		[]Frame{
			{ 4, 2},
			{ 3,4},
			{ 6, 2},
			{ 2, 3},
			{ 9, 0},
			{ 10,0},
			{ 5, 5},
			{ 0, 3},
			{ 3, 2},
			{ 4, 2},
			{ 5, 0},
			{ 6, 0},})
	expected := 79

	if repeated != expected {
		t.Errorf("expected '%d' but got '%d'", expected, repeated)
	}
}

func TestScoreStrikeStrike(t *testing.T) {
	repeated := calculateScore(
		[]Frame{
			{ 4, 2},
			{ 3,4},
			{ 6, 2},
			{ 2, 3},
			{ 9, 0},
			{ 10,0},
			{ 10, 0},
			{ 2, 3},
			{ 3, 2},
			{ 4, 2},
			{ 5, 0},
			{ 0, 0},})
	expected := 88

	if repeated != expected {
		t.Errorf("expected '%d' but got '%d'", expected, repeated)
	}
}


func TestScoreAll5plusSpare(t *testing.T) {
	repeated := calculateScore(
		[]Frame{
			{ 5,5},
			{ 5,5},
			{ 5,5},
			{ 5,5},
			{ 5,5},
			{ 5,5},
			{ 5,5},
			{ 5,5},
			{ 5,5},
			{ 5,5},
			{ 5,0},
			{ 0,0}})
	expected := 150

	if repeated != expected {
		t.Errorf("expected '%d' but got '%d'", expected, repeated)
	}
}


func TestStrikingBowler(t *testing.T) {
	repeated := calculateScore(
		[]Frame{
			{2, 5},
			{4, 2},
			{10, 0},
			{10, 0},
			{5, 5},
			{3, 7},
			{0, 6},
			{1, 4},
			{9, 1},
			{2, 0},
			{0,0},
			{0,0}})
	expected := 106

	if repeated != expected {
		t.Errorf("expected '%d' but got '%d'", expected, repeated)
	}
}