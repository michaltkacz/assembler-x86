# Mnozenie arg1 * arg2, wynik w %ebx
# Kompilacja:	as mnozenie.s --32 -o mnozenie.o -g
# Laczenie: 	ld mnozenie.o -m elf_i386 -o mnozenie
# Wykonanie:  ./mnozenie; echo $?
#	Lub 	      kdbg mnozenie

STDIN = 0
STDOUT = 1
SYSCALL = 0x80

.section .data
  arg1: .long 3
  arg2: .long 4

.section .text
  .globl _start
  _start:
    movl arg1, %eax
    movl arg2, %ecx
    mul %ecx

    movl %eax, %ebx     # wynik mnozenia w %ebx
    movl $STDOUT, %eax  # exit, wynik %ebx
    int $SYSCALL
