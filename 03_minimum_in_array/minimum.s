# znajdowanie minimum w tablicy tablica
# rejestr %edi  -indeks tablicy
# rejestr %ebx  -aktualnie najwiekszy element
# rejestr %eax  -biezacy element
# wynik w %ebx
# Kompilacja:	as minimum.s --32 -o minimum.o -g
# Laczenie: 	ld minimum.o -m elf_i386 -o minimum
# Wykonanie:  ./minimum; echo $?
#	Lub	        kdbg minimum

STDIN = 0
STDOUT = 1
SYSCALL = 0x80

.section .data
  tablica: .long 63,67,34,224,45,75,54,34,44,33,22,11,66,0

.section .text
  .globl _start
  _start:
    movl $0, %edi                   # przeslij 0 do rejestru indeksowego
    movl tablica(,%edi,4), %eax     # przeslij do eax pierwsza liczbe z tablicy
    movl %eax, %ebx                 # pierwszy element jest na razie najmniejszy
    cmpl $0, %eax                   # sprawdz czy koniec tablicy (jest tam 0)
    je loop_exit                    # jezeli jest 0, to tablica byla "pusta"

    start_loop:                     # start petli
      incl %edi                     # zwieksz licznik
      movl tablica(,%edi,4), %eax   # pobierz kolejny element z tablicy do %eax
      cmpl $0, %eax                 # sprawdz czy koniec tablicy (jest tam 0)
      je loop_exit
        cmpl %ebx, %eax             # porownaj czy %eax wiekszy od minimum w %ebx
        jge start_loop              # skocz do poczatku petli gdyz %eax jest wiekszy od min w %ebx
          movl %eax, %ebx           #  w %eax jest aktualne minimum, minimum do %ebx
        jmp start_loop              # skocz na poczatek petli

   loop_exit:
      movl $STDOUT, %eax             # exit, wynik %ebx
      int $SYSCALL
