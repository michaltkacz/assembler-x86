# Program oblicza wyrazu ciagu Fibonacciego
# Kompilacja: as fib.s --32 -o fib.o -g
# Laczenie: ld fib.o -m elf_i386 -o fib
#           ./fib

SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDIN = 0
STDOUT = 1
EXIT_SUCCESS = 0

NUM_OF_NUMBERS = 50     # liczba wyrazow ciagu do wygenerowania
CORRECTION = 48         # korekta przy konwersji cyfry na znak ascii

.align 32

# wypisyanie ciagu znakow na konsoli
.macro write_string str_name, str_len
  mov $SYSWRITE, %eax 	 	     # funkcja do wywolania - SYSWRITE
  mov $STDOUT, %ebx 	         # 1 arg. - syst. deskryptor stdout
  mov \str_name, %ecx          # 2 arg. - adres poczatkowy napisu
  mov \str_len, %edx           # 3 arg. - dlugosc lancucha
  int $0x80			               # wywolanie przerwania programowego
.endm

# wczytanie ciagu znakow z konsoli
.macro read_string str_name, str_len
  mov $SYSREAD, %eax 	 	       # funkcja do wywolania - SYSREAD
  mov $STDIN, %ebx 	           # 1 arg. - syst. deskryptor stdin
  mov \str_name, %ecx          # 2 arg. - adres poczatkowy napisu
  mov \str_len, %edx           # 3 arg. - dlugosc lancucha
  int $0x80			               # wywolanie przerwania programowego
.endm

# wypisanie znaku nowej linii na konsoli
.macro write_newline
  write_string $newline, $newline_len
.endm

.macro number_to_string number
  movl $14, %edi                      # rzad jednosci, dziesiatek, setek...
  movl \number, %ebx                  # w ebx - konwertowana liczba
  get_ascii\@:                        # \@ - wymagane dla etykiety w makrze
    movl $0, %edx                     # dzielna1, edx - reszta z dzielenia
    movl %ebx, %eax                   # dzielna0, eax - wynik dzielenia
    movl $10, %ecx                    # dzielnik rowny 10
    divl %ecx                         # podziel przez 10
    movl %eax, %ebx                   # w ebx nastepna liczba do podzielenia

    # teraz w edx znajduje sie reszta z dzielenia, czyli cyfra z zakresu od 0-9
    # aby uzyskac jej kod ascii, wystarczy dodac wartosc znaku '0' czyli 48
    addb $CORRECTION, %dl             # dodaj korekte do cyfry
    movb %dl, msg_echo(, %edi, 1)     # wprowadz cyfre do stringa
    decl %edi                         # kolejny rzad wielkosci

    cmpl $0, %eax                     # koniec rzedow wielkosci,liczba zamieniona
    je end_conversion\@

    cmpl $0, %edi                     # jezeli miesci sie w zakresie dlugosci
    ja get_ascii\@                    # stringa wyjsciowego (15 + 1 znakow)

  end_conversion\@:                   # \@ - wymagane dla etykiety w makrze
.endm

# dane
.section .data
  newline: .ascii "\n"
  newline_len = . - newline

  msg_hello: .ascii "Ciag Fibonacciego:\n"
  msg_hello_len = . - msg_hello

  msg_space: .ascii " "
  msg_space_len = . - msg_space

  msg_echo: .ascii "                " # 15 znakow + 1 znak nowej linii
  msg_echo_len = . - msg_echo

  first: .long 0
  second: .long 1

# main
.section .text
  .global _start
  _start:
    # wiadomosc powitalna
    write_string $msg_hello, $msg_hello_len

    # algorytm na kolejne liczby Fibonacciego
    # wypisanie pierwszego wyrazu
    number_to_string first                    # konwersja liczby na ascii
    write_string $msg_echo, $msg_echo_len
    write_newline

    # kolejne wyrazy ciagu
    movl $1, %edi                             # i = 1, licznik petli
    loop_start:
      cmpl $NUM_OF_NUMBERS, %edi              # if i == NUM_OF_NUMBERS
      je exit                                 # goto exit
      incl %edi                               # i++

      pushl %edi                              # zachowanie licznika petli
      number_to_string second                 # konwersja liczby na ascii
      write_string $msg_echo, $msg_echo_len
      write_newline

      movl $0, %edi                        # wyzerowanie indeku do adresacji

      movl first(,%edi, 4), %ecx           # ecx: next = first
      addl second(,%edi, 4), %ecx          # ecx: next = first + second

      movl second(,%edi, 4), %ebx          # ebx: second
      movl %ebx, first(,%edi, 4)           # first = second

      movl %ecx, second(,%edi, 4)          # second = next

      popl %edi                            # przywrocenie stanu licznika petli
      jmp loop_start

  # zakonczenie programu
  exit:
  movl $SYSEXIT, %eax		    # funkcja do wywolania - SYSEXIT
  movl $EXIT_SUCCESS, %ebx 	# 1 arg. -- kod wyjscia z programu
  int $0x80			            # wywolanie przerwania programowego
