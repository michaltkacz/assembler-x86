# Sumowanie elemntow z tablicy
# rejestr %edi  -indeks tablicy
# rejestr %eax  -biezacy element
# Kompilacja:	as sumowanie2.s --32 -o sumowanie2.o -g
# Laczenie: 	ld sumowanie2.o -m elf_i386 -o sumowanie2
#	            kdbg sumowanie

STDIN = 0
STDOUT = 1
SYSCALL = 0x80

.section .data
  tablica1: .long 63,67,34,224,45,75,54,34,44,33,22,11,66,0
  tablica2: .long 1,2,3,4,5,6,7,4,4,3,2,1,6,0

.section .text
  .globl _start
  _start:
    movl $0, %edi                   # przeslij 0 do rejestru indeksowego

    movl tablica1(,%edi,4), %ecx    # przeslij do ecx pierwsza liczbe z tablicy1
    cmpl $0, %ecx                   # sprawdz czy koniec tablicy1 (jest tam 0)
    je loop_exit

    movl tablica2(,%edi,4), %edx    # przeslij do edx pierwsza liczbe z tablicy2
    cmpl $0, %edx                   # sprawdz czy koniec tablicy2 (jest tam 0)
    je loop_exit                    # jezeli jest 0, to tablica2 byla "pusta"

    movl %ecx, %eax                 # do %eax wstaw wartosc z pierwszej tablicy
    addl %edx, %eax                 # do %eax dodaj wartosc z drugiej tablicy
    movl %eax, tablica2(,%edi, 4)   # zastap wartosc w drugej tablicy suma

    start_loop:                     # start petli
      incl %edi                     # zwieksz licznik

      movl tablica1(,%edi,4), %ecx   # pobierz kolejny element z tablicy1 do %ecx
      cmpl $0, %eax                 # sprawdz czy koniec tablicy1 (jest tam 0)
      je loop_exit

      movl tablica2(,%edi,4), %edx   # pobierz kolejny element z tablicy2 do %edx
      cmpl $0, %edx                 # sprawdz czy koniec tablicy2 (jest tam 0)
      je loop_exit

      movl %ecx, %eax               # do %eax wstaw wartosc z pierwszej tablicy
      addl %edx, %eax               # do %eax dodaj wartosc z drugiej tablicy
      movl %eax, tablica2(,%edi, 4) # zastap wartosc w drugej tablicy suma

      jmp start_loop                # skocz na poczatek petli

   loop_exit:
      movl $STDOUT, %eax             # exit
      int $SYSCALL
