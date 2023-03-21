.section .text
.global _entry

_entry:
    la sp,stacks
    li t0,1024*4
    add tp,a0,x0
    addi a0,a0,1
    mul a0,a0,t0
    add sp,sp,a0
    call start
