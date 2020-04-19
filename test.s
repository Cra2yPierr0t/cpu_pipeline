.file "test.s"
.global main
main:
    addi t1, zero, 20
    addi t2, zero, 30
    add  t3, t1, t2
    lw   t3, 0(zero)
    sw   t3, 4(zero)
    nop
    nop
    nop
