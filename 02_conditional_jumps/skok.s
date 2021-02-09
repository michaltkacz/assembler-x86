# Skok warunkow, wartosc bezwzgledna abs(arg1 - arg2)
# wynik w %ebx
# Kompilacja:	as skok.s --32 -o skok.o -g
# Laczenie: 	ld skok.o -m elf_i386 -o skok
# Wykonanie:  ./skok; echo $?
#	Lub	        kdbg skok

STDIN = 0
STDOUT = 1
SYSCALL = 0x80

.section .data
  # Wersja 1
  # arg1: .long 3
  # arg2: .long 4

  # Wersja 2
  arg1: .long 4
  arg2: .long 3

.section .text
  .globl _start
  _start:
    movl arg1, %edx
    movl arg2, %eax
    cmpl %eax, %edx
    jge .L2             # Skocz do .L2 jezeli %eax <= %edx
      subl %edx, %eax   # %eax > %edx
      movl %eax, %ebx
      jmp .L3

    .L2:
      subl %eax, %edx   # %eax <= %edx
      movl %edx, %ebx

    .L3:
      movl $STDOUT, %eax  # exit, wynik %ebx
      int $SYSCALL
