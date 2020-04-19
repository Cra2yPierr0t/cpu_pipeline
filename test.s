.file "test.s"
.global main
main:
    addi t1, zero, 20
    sw   t1, 0(zero)
    nop
    nop
    nop
    lw   t3, 0(zero)
    add  t4, t3, zero
    nop
    nop
    nop
    nop
