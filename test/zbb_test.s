	.text
	.globl _start

_start:

    # x1 = 0x10 (16 decimal)
    addi x1, x0, 16

    ctz x2, x1            # x2 = CTZ(x1), should be 4

    # x3 = 0x10 again
    addi x3, x0, 16

    clz x4, x3            # x4 = CLZ(x3), should be 27

    # x5 = 0x15 (21 decimal)
    addi x5, x0, 21

    cpop x6, x5           # x6 = CPOP(x5), should be 3

    # x7 = 0
    addi x7, x0, 0

    ctz x8, x7            # x8 = CTZ(0), usually 32

    # x9 = 0
    addi x9, x0, 0

    clz x10, x9           # x10 = CLZ(0), 32

    # x11 = 0
    addi x11, x0, 0

    cpop x12, x11         # x12 = CPOP(0), 0

    ecall
