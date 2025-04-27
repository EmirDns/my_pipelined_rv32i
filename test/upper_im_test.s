.text
.globl _start

_start:
    addi x1, x0, 20           # x1 = 20
    lui  x2, 0x80000          # x2 = 0x80000000
    addi x2, x2, 0x10         # x2 = 0x80000010
    sw   x1, 0(x2)            # store x1 (20) into Mem[0x80000010]
    lw   x3, 0(x2)            # load Mem[0x80000010] into x3
    add  x4, x3, x2
    or   x5, x3, x1
    sub  x6, x3, x1
    ecall
