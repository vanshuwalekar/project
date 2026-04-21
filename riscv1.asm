
.text
.globl main

main:
    addi x1, x0, 5
    addi x2, x0, 10
    add  x3, x1, x2
    sw   x3, 0(x0)
    lw   x4, 0(x0)
    beq  x3, x4, skip
    addi x5, x0, 0

skip:
    addi x6, x0, 1
