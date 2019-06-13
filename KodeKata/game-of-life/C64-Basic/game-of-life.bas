10 x=rnd(-ti)
20 dim buffer$(1000)
30 for i=0 to 1000
40 vd=rnd(1)
50 if vd > 0.2 then poke 1024+i, 96
60 if vd < 0.2 then poke 1024+i, 123
70 next
80 rem "Define array"
90 dim grid%(24,39)
100 rem "Read from screen"
110 for row = 0 to 24
120 for col = 0 to 39
130 grid%(row,col) = peek(1024 + col + 40 * row)
140 next col
141 next row
150 rem "Game og life rules"
160 for row = 0 to 24
170 for col = 0 to 39
180 ne% = 0
190 gosub 250
200 if grid%(row,col)=123 and ne%<2 then poke (1024 + col + 40 * row), 96
201 if grid%(row,col)=123 and ne%>3 then poke (1024 + col + 40 * row), 96
210 if grid%(row,col)=96 and ne%=3 then poke (1024 + col + 40 * row), 123
220 next col
230 next row
240 goto 110
250 rem find num of neighbours
251 rem print row
252 rem print col
258 if row = 0 then goto 289
259 if col = 0 then goto 270
260 if grid%(row-1, col-1)=123 then ne%=ne%+1
270 if row-1>0 and grid%(row-1, col)=123 then ne%=ne%+1
279 if col = 39 then goto 289
280 if row-1>0 and col+1<40 and grid%(row-1, col+1)=123 then ne%=ne%+1
289 if col = 0 then goto 299
290 if col-1>0 and grid%(row, col-1)=123 then ne%=ne%+1
299 if col = 39 then goto 308
300 if col+1<40 and grid%(row, col+1)=123 then ne%=ne%+1
308 if row = 24 then goto 340
309 if col = 0 then goto 320
310 if row+1<25 and col-1>0 and grid%(row+1, col-1)=123 then ne%=ne%+1
320 if row+1<25 and grid%(row+1, col)=123 then ne%=ne%+1
329 if col = 39 then goto 340
330 if row+1<25 and col+1<40 and grid%(row+1,col+1)=123 then ne%=ne%+1
340 return
