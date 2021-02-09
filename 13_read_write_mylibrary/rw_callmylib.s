# Kompilacja: as mylib.s -32 -g -o mylib.o
# Laczenie: gcc rw_callmylib.s mylib.o -m32 -g -o rw_callmylib
# Uruchomienie: ./rw_callmylib; echo $?

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
.global main
# main
main:
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
