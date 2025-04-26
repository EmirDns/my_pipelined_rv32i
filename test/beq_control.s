    .text
    .globl _start

_start:
    addi x1, x0, 5          # x1 = 5
    addi x2, x0, 5          # x2 = 5

    beq x1, x2, branch_target

    addi x3, x0, 1    # Should be flushed
    addi x4, x0, 2    # Should be flushed
    addi x5, x0, 3    # Should be flushed
    addi x6, x0, 4    # Should be flushed
    addi x7, x0, 5    # Should be flushed
    addi x8, x0, 6    # Should be flushed
    addi x9, x0, 7    # Should be flushed
    addi x10, x0, 8    # Should be flushed


branch_target:
    addi x11, x0, 3
    addi x12, x0, 4

    ecall             # Finish program
