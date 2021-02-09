# Kompilacja: gcc dodaj_funk.s -m32 -o dodaj_funk

SYSEXIT = 1

.data
    str1: .ascii "Podaj a i b \n\0"     # pierwszy lancuch do printf
    str2: .ascii "%d %d\0"              # lancuch formatujacy formatujacy do scanf
    str3: .ascii "Wynik %d\n\0"         # drugi lancuch do printf
    
    arg1: .long 0                       # arg1
    arg2: .long 0                       # arg2

.text
.globl main
# main
main:
    # pierwszy printf
    pushl $str1
    call printf
    addl $4, %esp

    # wczytanie wartosci do argumentow
    pushl $arg2
    pushl $arg1
    pushl $str2
    call scanf
    addl $12, %esp

    # wywolanie funkcji dodaj, suma w %eax
    pushl arg2
    pushl arg1
    call dodaj
    addl $8, %esp

    # drugi printf, wynik
    pushl %eax
    pushl $str3
    call printf
    addl $8, %esp

    # wyjscie
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
    addl %ecx, %eax         # suma do %eax, wartosc zwracana

    # epilog
    movl %ebp, %esp
    popl %ebp
    ret
