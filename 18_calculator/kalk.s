# Kalkulator
# Kompilacja gcc kalk.c kalk.s -m32 -g -o kalk

.section .text
.globl my_add

my_add:
    # prolog
    pushl %ebp
    movl %esp, %ebp

    # funkcja
    fldl 8(%ebp)
    fldl 16(%ebp)
    faddp

    #epilog
    movl %ebp, %esp
    popl %ebp
    ret

.globl my_sub
my_sub:
    # prolog
    pushl %ebp
    movl %esp, %ebp

    # funkcja
    fldl 16(%ebp)
    fldl 8(%ebp)    
    fsubp

    #epilog
    movl %ebp, %esp
    popl %ebp
    ret

.globl my_mul
my_mul:
    # prolog
    pushl %ebp
    movl %esp, %ebp

    # funkcja
    fldl 8(%ebp)
    fldl 16(%ebp)
    fmulp

    #epilog
    movl %ebp, %esp
    popl %ebp
    ret

.globl my_div
my_div:
    # prolog
    pushl %ebp
    movl %esp, %ebp

    # funkcja
    fldl 16(%ebp)
    fldl 8(%ebp)
    fdivp

    #epilog
    movl %ebp, %esp
    popl %ebp
    ret

.globl my_sqrt
my_sqrt:
    # prolog
    pushl %ebp
    movl %esp, %ebp

    # funkcja
    fldl 8(%ebp)
    fsqrt

    #epilog
    movl %ebp, %esp
    popl %ebp
    ret

.globl my_sin
my_sin:
    # prolog
    pushl %ebp
    movl %esp, %ebp

    # funkcja
    fldl 8(%ebp)
    fsin

    #epilog
    movl %ebp, %esp
    popl %ebp
    ret
