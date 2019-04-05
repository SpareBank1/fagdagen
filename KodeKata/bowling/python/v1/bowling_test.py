#!/bin/python3
import unittest
from bowling import BowlingSeries


class BowlingTest(unittest.TestCase):

    def test_all_strikes_should_result_in_max_score(self):
        series = BowlingSeries(["X", "X", "X", "X", "X", "X", "X", "X", "X", "X", "X", "X"])
        self.assertEqual(series.calculate_score(), 300)

    def test_all_nines_should_result_in_90(self):
        series = BowlingSeries(["9-", "9-", "9-", "9-", "9-", "9-", "9-", "9-", "9-", "9-"])
        self.assertEqual(series.calculate_score(), 90)

    def test_all_eights_plus_ones_should_result_in_90(self):
        series = BowlingSeries(["81", "81", "81", "81", "81", "81", "81", "81", "81", "81"])
        self.assertEqual(series.calculate_score(), 90)

    def test_all_misses_should_result_in_0(self):
        series = BowlingSeries(["--", "--", "--", "--", "--", "--", "--", "--", "--", "--"])
        self.assertEqual(series.calculate_score(), 0)

    def test_all_spares_and_then_5_should_result_in_150(self):
        series = BowlingSeries(["5/", "5/", "5/", "5/", "5/", "5/", "5/", "5/", "5/", "5/", "5"])
        self.assertEqual(series.calculate_score(), 150)

    def test_natural_game_should_produce_correct_result(self):
        series = BowlingSeries(["8-", "X", "61", "72", "5/", "3-", "--", "--", "X", "9-"])
        self.assertEqual(series.calculate_score(), 85)


if __name__ == '__main__':
    unittest.main()
