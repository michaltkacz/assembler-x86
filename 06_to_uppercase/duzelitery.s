# Program zamienia male litery na duze w podanym ciagu znakow
# Kompilacja: as duzelitery.s --32 -o duzelitery.o -g
# Laczenie: ld duzelitery.o -m elf_i386 -o duzelitery
#           ./duzelitery

SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDIN = 0
STDOUT = 1
EXIT_SUCCESS = 0

SIGN_a = 97
SIGN_z = 122
SHIFT = 32

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

.section .data
  msg_echo: .ascii "                                           "
  msg_echo_len = . - msg_echo

  newline: .ascii "\n"
  newline_len = . - newline

  msg_hello: .ascii "Wprowadz tekst:\n"
  msg_hello_len = . - msg_hello

.section .text
  .global _start
  _start:
  # piszemy msg_hello
  write_string $msg_hello, $msg_hello_len

  # czytamy string z konsoli do msg_echo
  read_string $msg_echo, $msg_echo_len

  # alogrytm analogiczny do przykladu w jezyku C
  movl $0, %edi                       # int i = 0
  loop_start:                         # for
    movb msg_echo(,%edi,1), %al       # c = bufor[i]

    cmpb $SIGN_z, %al                 # if c > 'z'
    ja next_sign                      # przejdz do nastepnego znaku

    cmpb $SIGN_a, %al                 # if c < 'a'
    jb next_sign                      # przejdz do nastepnego znaku

    subb $SHIFT, %al                  # c = c - SHIFT
    movb %al, msg_echo(,%edi,1)       # bufor[i] = c

    next_sign:                        # pobierz kolejny znak
      incl %edi                       # i++
      cmpl %edi, %edx                 # i <ile
      jg loop_start

  # wypisujemy na STDOUT msg_echo
  write_string $msg_echo, $msg_echo_len

  # wypisujemy na STDOUT znak \n
  write_newline

  # zakonczenie programu
  movl $SYSEXIT, %eax		    # funkcja do wywolania - SYSEXIT
  movl $EXIT_SUCCESS, %ebx 	# 1 arg. -- kod wyjscia z programu
  int $0x80			            # wywolanie przerwania programowego
