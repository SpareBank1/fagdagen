Python-baserte variant hvor man gjør cirka følgende transformasjoner:

Input:
```
['8-', 'X', '61', '72', '5/', '3-', '--', '--', 'X', '9-']
```

oversettes til heltallsverdier i legges i egne lister for hver runde:
```
[[8, 0], [10], [6, 1], [7, 2], [5, 5], [3, 0], [0, 0], [0, 0], [10], [9, 0]]
```

som igjen kompletteres i for-løkka ved at man legger til evt. bonus i runden
```
[[8, 0], [10, 6, 1], [6, 1], [7, 2], [5, 5, 3], [3, 0], [0, 0], [0, 0], [10, 9, 0], [9, 0]]
```

til slutt kjøres en kombinert flatmap/fold for å aggregere summen av de nå 10 komplette rundene (bonusrundene droppes)
