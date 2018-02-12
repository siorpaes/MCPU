mcpu.coe
This is the coefficient file corresponding to MCPU demo in "memory.dat"

gpio.coe
This is an application that increments accumulator value and stores its
value in 0x3c so that gpio peripheral is stimulated.

0  NOR[0x3e]     0x3e  0b00111110
1  ADD[0x3f]     0x7f  0b01111111
2  STA[0x3c]     0xbc  0b10111100
3  JCC 1         0xc1  0b11000001
4  JCC 0         0xc0  0b11000000
~~
3c GPIO register
3d 00 constant
3e ff constant
3f 01 constant

blinky.coe
This application blinks LD0. Uses a loop to create the delay and then
increments a variable. Afterwards, all bits but the first one are
cleared with NOR 0xfe and the result is stored to GPIO peripheral

0  NOR[3e]       0x3e  0b00111110  ;delay loop
1  ADD[3f]       0x7f  0b01111111
2  STA[3b]       0xbb  0b10111011
3  JCC 1         0xc1  0b11000001  ;delay loop
4  NOR[3e]       0x3e  0b00111110  ;LDA[3a] 1/2
5  ADD[3a]       0x7a  0b01111010  ;LDA[3a] 2/2
6  ADD[3f]       0x7f  0b01111111  ;add one
7  STA[3a]       0xba  0b10111010  ;store to 3a
8  NOR[39]       0x39  0b00111001  ;keep first bit
9  STA[3c]       0xbc  0b10111100  ;write to gpio
a  JCC 0         0xc0  0b11000000  ;restart
b  JCC 0         0xc0  0b11000000
~~ 
39 fe constant
3a blinky variable
3b delay variable
3c gpio
3d 00 constant
3e ff constant
3f 01 constant

