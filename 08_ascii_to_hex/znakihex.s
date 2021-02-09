# Program konwertuje kody znakow ASCII na zapis HEX
# i wyprowadza wyniki na STDOUT
# Kompilacja: as znakihex.s --32 -o znakihex.o -g
# Laczenie: ld znakihex.o -m elf_i386 -o znakihex
#           ./znakihex < ascii.txt > wynik.txt
# Plik wejsciowy: ascii.txt
# Plik wyjsciowy: wynik.txt

SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDIN = 0
STDOUT = 1
EXIT_SUCCESS = 0

SIGN_0 = 48       # kod ascii znaku '0'
SIGN_9 = 57       # kod ascii znaku '9'
CORRECTION = 7    # 'A' - '9' - 1

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

# dane
.section .data
  three_bytes: .ascii "   "
  three_bytes_len = . - three_bytes

.section .bss
  .lcomm one_byte, 1

# main
.section .text
  .global _start
  _start:                                 # do
    read_string $one_byte, $1             # read(STDIN,&oneByte,1)
    movl %eax, %edx                       # READ = read(STDIN,&oneByte,1)
    cmpl $1, %edx                         # if READ != 1
    jne exit                              # goto exit

    # młodsze 4 bity
    movb one_byte, %al                    # c = oneByte
    and $0x0F, %al                        # c = c & 0x0F
    addb $SIGN_0, %al                     # c = c + '0'
    cmpb $SIGN_9, %al                     # if (c <= '9')
    jbe no_correction1                    # goto no correction
    addb $CORRECTION, %al                 # else
    no_correction1:                       # correction
      movl $1, %edi                       # index = 1
      movb %al, three_bytes(, %edi, 1)    # threeBytes[1] = c

    # starsze 4 bity
    movb one_byte, %al                    # c = oneByte
    shr $4, %al                           # c = c >> 4
    and $0x0F, %al                        # c = c & 0x0F
    addb $SIGN_0, %al                     # c = c + '0'
    cmpb  $SIGN_9, %al                    # if (c <= '9')
    jbe no_correction2                    # goto no correction
    addb $CORRECTION, %al                 # else
    no_correction2:                       # correction
      movl $0, %edi                       # index = 0
      movb %al, three_bytes(, %edi, 1)    # threeBytes[0] = c

    write_string $three_bytes, $three_bytes_len # STDOUT
    jmp _start                            # dopoki sa dane

    exit:
      # zakonczenie programu
      movl $SYSEXIT, %eax		    # funkcja do wywolania - SYSEXIT
      movl $EXIT_SUCCESS, %ebx 	# 1 arg. -- kod wyjscia z programu
      int $0x80			            # wywolanie przerwania programowego
