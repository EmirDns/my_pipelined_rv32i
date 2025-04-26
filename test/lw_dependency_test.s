    .text
    .globl _start

_start:
    
    addi x1, x0, 20
    addi x2, x0, 10
    sw   x1, 0(x2)        # store x1 (20) into Mem[10]
    lw x3, 0(x2)
    add x4, x3, x2
    or x5, x3, x1
    sub x6, x3, x1
    
    ecall
