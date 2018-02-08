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


