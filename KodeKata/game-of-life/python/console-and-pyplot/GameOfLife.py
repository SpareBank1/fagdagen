import pandas as pd
import re
import numpy as np
import matplotlib.pyplot as plt


class GameOfLife:
    def __init__(self, initial_frame):
        self._current_frame = initial_frame

    @classmethod
    def from_file(cls, file):
        return cls(cls._parse_data(cls._read_file(file)))

    @classmethod
    def from_list(cls, list_of_lines):
        return cls(cls._parse_data(list_of_lines))

    def run(self):
        while self._current_frame is not None:
            self._current_frame.plot()
            self._current_frame.render()
            self._current_frame = self._current_frame.next_generation()

    def next_step(self):
        self._current_frame = self._current_frame.next_generation()
        return self._current_frame

    def current(self):
        return self._current_frame

    @staticmethod
    def _read_file(name):
        with open(name) as file:
            content = file.readlines()
        return [line.strip() for line in content]

    @staticmethod
    def _parse_data(data):
        gen_num = int(re.findall(r'Generation (\d+):', data[0])[0])
        dimension = re.findall(r'^(\d+) (\d+)$', data[1])
        num_rows = int(dimension[0][0])
        num_cols = int(dimension[0][1])

        df = pd.DataFrame(index=range(num_rows), columns=range(num_cols))
        for row in range(num_rows):
            for column in range(num_cols):
                if data[row + 2][column] == '*':
                    df.at[row, column] = '*'

        return Frame(gen_num, df)


class Frame:
    def __init__(self, generation, data):
        self._generation = generation
        self._data = data

    def render(self):
        print("Generation {}:".format(self._generation))
        print(self._data.fillna(' '))

    def plot(self):
        x, y = [], []
        for row in range(self._data.shape[0]):
            for col in range(self._data.shape[1]):
                if self._is_alive(row, col):
                    y.append(row)
                    x.append(col)

        plt.title("Game of Life - generation {}:".format(self._generation))
        plt.scatter(x=x, y=y, c='black', s=1000, marker='s')
        plt.ylim(self._data.shape[0], 1)
        plt.xlim(-1, self._data.shape[1])
        plt.ylabel('Row')
        plt.xlabel('Column')
        plt.show()

    def next_generation(self):
        next_gen = self._data.copy()
        for row in range(self._data.shape[0]):
            for col in range(self._data.shape[1]):

                if self._has_fewer_than_two_live_neighbours(row, col)\
                        or self._has_more_than_three_live_neighbours(row, col):
                    next_gen.at[row, col] = np.NaN

                elif self._should_live_on(row, col)\
                        or self._should_resurrect_due_to_three_live_neighbours(row, col):
                    next_gen.at[row, col] = '*'

        next_frame = Frame(self._generation + 1, next_gen)
        return None if self.is_equal_to(next_frame) else next_frame

    def is_equal_to(self, other):
        return self._data.equals(other._data)

    def _retrieve(self, row, col):
        return self._data.loc[row - 1:row + 1, col - 1:col + 1]

    def _is_alive(self, row, col):
        return self._data.loc[row, col] == '*'

    def _is_dead(self, row, col):
        return not self._is_alive(row, col)

    def _has_fewer_than_two_live_neighbours(self, row, col):
        # 1. Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
        sub_self = 1 if self._is_alive(row, col) else 0
        return True if (self._retrieve(row, col).notna().sum().sum() - sub_self) < 2 else False

    def _has_more_than_three_live_neighbours(self, row, col):
        # 2. Any live cell with more than three live neighbours dies, as if by overcrowding.
        sub_self = 1 if self._is_alive(row, col) else 0
        return True if (self._retrieve(row, col).notna().sum().sum() - sub_self) > 3 else False

    def _should_live_on(self, row, col):
        # 3. Any live cell with two or three live neighbours lives on to the next generation.
        return True if (self._is_alive(row, col)
                        and self._retrieve(row, col).notna().sum().sum()) in range(2, 3) else False

    def _should_resurrect_due_to_three_live_neighbours(self, row, col):
        # 4. Any dead cell with exactly three live neighbours becomes a live cell.
        return True if (self._is_dead(row, col)
                        and self._retrieve(row, col).notna().sum().sum()) == 3 else False
