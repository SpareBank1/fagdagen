#!/bin/python3
import unittest
import random

from GameOfLife import GameOfLife


class GameOfLifeTest(unittest.TestCase):

    @staticmethod
    def _random_line(length):
        return ''.join(random.choice(['.', '*']) for _ in range(length))

    def test_example_should_render_expected_output_after_1_generation(self):
        next_frame = GameOfLife.from_file('console-and-pyplot/data/input_gen1.txt').next_step()
        expected_frame = GameOfLife.from_file('console-and-pyplot/data/output_gen1.txt').current()

        self.assertTrue(next_frame.is_equal_to(expected_frame))

    def test_example2_should_just_run(self):
        GameOfLife.from_file('console-and-pyplot/data/input2_gen1.txt').run()

    def test_example3_should_just_run(self):
        rows = 20
        cols = 20
        data = [
            'Generation 1:',
            '{} {}'.format(rows, cols)
        ]
        for row in range(rows):
            data.append(self._random_line(cols))

        GameOfLife.from_list(data).run()


if __name__ == '__main__':
    unittest.main()
