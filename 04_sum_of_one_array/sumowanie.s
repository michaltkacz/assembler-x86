# Sumowanie elemntow z tablicy
# rejestr %edi  -indeks tablicy
# rejestr %ebx  -aktualna suma
# rejestr %eax  -biezacy element
# wynik w %ebx
# Kompilacja:	as sumowanie.s --32 -o sumowanie.o -g
# Laczenie: 	ld sumowanie.o -m elf_i386 -o sumowanie
# Wykonanie:  ./sumowanie; echo $?
#	Lub	        kdbg sumowanie

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
    movl %eax, %ebx                 # pierwszy element jest na razie suma
    cmpl $0, %eax                   # sprawdz czy koniec tablicy (jest tam 0)
    je loop_exit                    # jezeli jest 0, to tablica byla "pusta"

    start_loop:                     # start petli
      incl %edi                     # zwieksz licznik
      movl tablica(,%edi,4), %eax   # pobierz kolejny element z tablicy do %eax
      cmpl $0, %eax                 # sprawdz czy koniec tablicy (jest tam 0)
      je loop_exit
        addl %eax, %ebx             # dodaj wartosc to sumy calkowitej w %ebx
        jmp start_loop              # skocz na poczatek petli

   loop_exit:
      movl $STDOUT, %eax             # exit, wynik %ebx
      int $SYSCALL
