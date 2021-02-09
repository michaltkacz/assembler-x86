# Kompilacja: as rwe1.s --32 -o rwe1.o -g
# Laczenie: ld rwe1.o -m elf_i386 -o rwe1
# Uruchomienie: ./rwe1; echo $?

SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDIN = 0
STDOUT = 1

.align 32

.data
    # bufor na wprowadzenie lancucha znakow
    msg_echo: .ascii "                                  "
    msg_echo_buff_len = . - msg_echo

    # pierwsza wiadomosc dla uzytkownika
    msg_info1: .ascii "Wprowadz napis:\n"
    msg_info1_len = . - msg_info1

    # druga wiadomosc dla uzytkownika
    msg_info2: .ascii "Wprowadzono napis:\n"
    msg_info2_len = . - msg_info2

.bss
    # zmienna dla prawidlowej dlugosci lancucha
    .lcomm msg_echo_input_len, 4


.text
.global _start
# main
_start:
    # wiadomosc info1
    pushl $msg_info1_len        # argument 3 - dlugosc lanuchca
    pushl $msg_info1            # argument 2 - lancuch znakow
    pushl $STDOUT               # argument 1 - standardowe wyjscie
    call write_function         # wywolanie funkcji
    addl $12, %esp              # usuniecie argumentow ze stosu

    # wczytanie lancucha znakow od uzytkownika
    pushl $msg_echo_buff_len        # argument 3 - dlugosc bufora lanuchca
    pushl $msg_echo                 # argument 2 - bufor lancucha znakow
    pushl $STDIN                    # argument 1 - wjescie standardowe
    call read_function              # wywolanie funkcji
    addl $12, %esp                  # usuniecie argumentow ze stosu
    movl %eax, msg_echo_input_len   # dlugosc wprowadzonego lanuchca

    # wiadomosc info2
    pushl $msg_info2_len    # argument 3 - dlugosc lanuchca
    pushl $msg_info2        # argument 2 - lancuch znakow
    pushl $STDOUT           # argument 1 - standardowe wyjscie
    call write_function     # wywolanie funkcji
    addl $8, %esp           # usuniecie argumentow ze stosu

    # wypisanie wczytanego lanuchca znakow
    pushl msg_echo_input_len    # argument 3 - wlasciwa dlugosc lanuchca
    pushl $msg_echo             # argument 2 - bufor lancucha znakow
    pushl $STDOUT               # argument 1 - wyjscie do pliku
    call write_function         # wywolanie funkcji
    addl $8, %esp               # usuniecie argumentow ze stosu

    # zakonczenie programu
    pushl msg_echo_input_len # argument 1 - kod powrotu
    call exit_function       # wywolanie funkcji
    addl $4, %esp            # usuniecie argumentu ze stosu



# funkcja read
.global read_function
.type read_function, @function
read_function:
    # prolog
    pushl %ebp
    movl %esp, %ebp

    mov $SYSREAD, %eax 	 	    # funkcja do wywolania - SYSREAD
    mov 8(%ebp), %ebx 	        # systemowy deskryptor
    movl 12(%ebp), %ecx         # lancuch znakow - argument funkcji
    movl 16(%ebp), %edx         # dlugosc lancucha - argument funkcji
    int $0x80			        # wywolanie przerwania programowego

    # epilog
    movl %ebp, %esp
    popl %ebp
    ret


# funkcja write
.global write_function
.type write_function, @function
write_function:
    # prolog
    pushl %ebp
    movl %esp, %ebp

    # funkcja
    mov $SYSWRITE, %eax 	 	 # funkcja do wywolania - SYSWRITE
    movl 8(%ebp), %ebx 	         # syst. deskryptor stdout
    movl 12(%ebp), %ecx          # lancuch znakow - argument funkcji
    movl 16(%ebp), %edx          # dlugosc lancucha - argument funkcji
    int $0x80			         # wywolanie przerwania programowego

    # epilog
    movl %ebp, %esp
    popl %ebp
    ret


# funkcja zakonczenie programu
.global exit_function
.type exit_function, @function
exit_function:
    # prolog
    pushl %ebp
    movl %esp, %ebp
    
    # funkcja
    movl $SYSEXIT, %eax	    # wyjscie       	
    movl 8(%ebp), %ebx      # Kod powrotu
    int $0x80

    # epilog
    movl %ebp, %esp
    popl %ebp
    ret
