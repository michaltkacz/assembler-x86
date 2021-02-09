# Kompilacja: gcc zamien-asf.c zamien-asf.s -g -m32 -o zamien-asf

.global swap_add

.type swap_add, @function
swap_add:
    # prolog
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx

    # funkcja
    movl 8(%ebp), %edx      # arg1: xp
    movl 12(%ebp), %ecx     # arg2: yp
    
    movl (%edx), %ebx       # x
    movl (%ecx), %eax       # y
    
    movl %eax, (%edx)       # y do xp
    movl %ebx, (%ecx)       # x do yp

    addl %ebx, %eax         # suma w %eax

    # epilog
    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret
