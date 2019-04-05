#!/bin/python3
from functools import reduce


class BowlingSeries:
    def __init__(self, frames):
        self.frames = frames

    def calculate_score(self):
        # Oversett input til lister av kast per frame, med heltallverdier
        f = list(map(self._mapper, self.frames))

        # Kompletter frames med bonus
        for i in range(10):
            if f[i][0] == 10:
                f[i].append(self._next(i, f))
                f[i].append(self._next(i, f, peek=2))
            elif sum(f[i]) == 10:
                f[i].append(self._next(i, f))

        # .. en form for flatmap + fold av første 10 frames
        return reduce(lambda acc, val: acc + int(reduce(lambda a, v: a + v, val, 0)), f[:10], 0)

    def _mapper(self, frame):
        if len(frame) == 1:
            return [self._to_int(frame[0])]
        else:
            first_roll = self._to_int(frame[0])
            return [first_roll, self._to_int(frame[1], previous=first_roll)]

    @staticmethod
    def _next(i, frames, peek=1):
        if peek == 1:
            return frames[i+1][0]
        elif len(frames[i+1]) == 2:
            return frames[i+1][1]
        else:
            return frames[i+2][0]

    @staticmethod
    def _to_int(roll, previous=None):
        mapper = {
            "/": lambda: 10 - previous if previous is not None else 0,
            "X": lambda: 10,
            "-": lambda: 0
        }
        return mapper.get(roll, lambda: int(roll))()
