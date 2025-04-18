.section .text.boot
.global _start
_start:
    mv s0, a0
    mv s1, a1
    la sp, _start
    la a0, _start
    la a1, _load_start
    la a2, _end
    sub a2, a2, a0
    call memcpy
    mv a0, s0
    mv a1, s1
    la t0, main
    jr t0
