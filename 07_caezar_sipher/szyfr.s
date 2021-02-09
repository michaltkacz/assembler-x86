# Program szyfruje podany ciag znakow
# (ale tylko litery a - z), nastepnie wyprowadza wynik
# na SDTOUT, deszyfruje ciag i ponownie wyprowadza na STDOUT
# Kompilacja: as szyfr.s --32 -o szyfr.o -g
# Laczenie: ld szyfr.o -m elf_i386 -o szyfr
#           ./szyfr

SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDIN = 0
STDOUT = 1
EXIT_SUCCESS = 0

SIGN_a = 97       # kod ascii znaku 'a'
SIGN_z = 122      # kod ascii znaku 'z'
KEY = 1           # klucz do szyfrowania
CORRECTION = 25   # 'z' - 'a'

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

# dane
.section .data
  msg_echo: .ascii "                                           "
  msg_echo_len = . - msg_echo

  newline: .ascii "\n"
  newline_len = . - newline

  msg_hello: .ascii "< Witaj, wprowadz tekst do zaszyfrowania:\n> "
  msg_hello_len = . - msg_hello

  msg_encrypt: .ascii "< Zaszyfrowane: "
  msg_encrypt_len = .-msg_encrypt

  msg_decrypt: .ascii "< Odszyfrowane: "
  msg_decrypt_len = .-msg_decrypt

# main
.section .text
  .global _start
  _start:
    # piszemy msg_hello
    write_string $msg_hello, $msg_hello_len

    # czytamy string do msg_echo
    read_string $msg_echo, $msg_echo_len

    # szyfrowanie
    # alogrytm analogiczny do przykladu w jezyku C
    movl $0, %edi                       # int i = 0
    loop_start_encrypt:                 # for
      movb msg_echo(,%edi,1), %al       # p[i]

      cmpb $SIGN_z, %al                 # if p[i] > 'z'
      ja next_sign_encrypt

      cmpb $SIGN_a, %al                 # if p[i] < 'a'
      jb next_sign_encrypt

      addb $KEY, %al                    # enc = p[i] + KEY

      cmpb $SIGN_z, %al                 # if enc <= 'z'
      jbe encrypt                       # znak zaszyfrowany

      subb $CORRECTION, %al             # korekta, jesli potrzebna
      subb $KEY, %al

      encrypt:                          # zapisanie zaszyfrowanego znaku
        movb %al, msg_echo(,%edi,1)     # p[i] = enc

      next_sign_encrypt:                # zapisanie zaszyfrowanego znaku
        incl %edi                       # i++
        cmpl %edi, %edx                 # i < ile
        jg loop_start_encrypt

    # etykieta "Zaszyfrowane"
    write_string $msg_encrypt, $msg_encrypt_len

    # wypisujemy na STDOUT msg_echo
    write_string $msg_echo, $msg_echo_len

    # deszyfrowanie
    # algorytm analogiczny do algorytmu szyforwania
    movl $msg_echo_len, %edx            # dlugosc lancucha
    movl $0, %edi                       # int i = 0
    loop_start_decrypt:                 # for
      movb msg_echo(,%edi,1), %al       # p[i]

      cmpb $SIGN_z, %al                 # if p[i] > 'z'
      ja next_sign_decrypt

      cmpb $SIGN_a, %al                 # if p[i] < 'a'
      jb next_sign_decrypt

      subb $KEY, %al                    # enc = p[i] - KEY

      cmpb $SIGN_a, %al                 # if enc >= 'a'
      jae decrypt                       # znak odszyfrowany

      addb $CORRECTION, %al             # korekta, jesli potrzebna
      addb $KEY, %al

      decrypt:                          # zapisanie odszyfrowanego znaku
        movb %al, msg_echo(,%edi,1)     # p[i] = enc

      next_sign_decrypt:                # pobranie kolejnego znaku
        incl %edi                       # i++
        cmpl %edi, %edx                 # i < ile
        jg loop_start_decrypt

    # wypisujemy na STDOUT znak \n
    write_newline

    # etykieta "Odszyfrowane"
    write_string $msg_decrypt, $msg_decrypt_len

    # wypisujemy na STDOUT msg_echo
    write_string $msg_echo, $msg_echo_len

    # wypisujemy na STDOUT znak \n
    write_newline

    # zakonczenie programu
    movl $SYSEXIT, %eax		    # funkcja do wywolania - SYSEXIT
    movl $EXIT_SUCCESS, %ebx 	# 1 arg. -- kod wyjscia z programu
    int $0x80			            # wywolanie przerwania programowego
