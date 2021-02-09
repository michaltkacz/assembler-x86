# Kompilacja: as add.s --32 -g -o add.o
# Laczenie: ld add.o -m elf_i386 -o add
# Uruchomienie: ./add; echo $?

SYSEXIT = 1

.data
    arg1: .long 3
    arg2: .long 4


.text
.globl _start
# main
_start:
    pushl arg2          # arg2 na stos
    pushl arg1          # arg1 na stos
    call dodaj          # wywoalnie funkcji
    addl $8, %esp       # wyrownanie stosu   

    movl %eax, %ebx     # kod powrotu do %ebx
    movl $SYSEXIT, %eax  # wyjscie z programu  
    int $0x80


.type dodaj, @function
dodaj:
    # prolog
    pushl %ebp
    movl %esp, %ebp

    # funkcja
    movl 8(%ebp), %eax      # arg1
    movl 12(%ebp), %ecx     # arg2
    addl %ecx, %eax         # suma w %eax, wartosc zwracana

    # epilog
    movl %ebp, %esp
    popl %ebp
    ret
