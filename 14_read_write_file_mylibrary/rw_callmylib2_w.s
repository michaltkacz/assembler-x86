# Kompilacja: as mylib2.s -32 -g -o mylib2.o
# Laczenie: gcc rw_callmylib2_w.s mylib2.o -m32 -g -o rw_callmylib2_w
# Uruchomienie: ./rw_callmylib2_w; echo $?

# prawa dostepu do pliku
CR_RE_WR_ONLY = 0102

# permisje
RWE_ALL = 0777

# standardowe wejscie/wyjscie
STDIN = 0
STDOUT = 1

.align 32

.data
    # nazwa pliku do zapisu/odczytu
    file_name: .asciz "file.txt"

    # bufor na wprowadzenie lancucha znakow od uztkownika
    msg_echo: .ascii "                                  "
    msg_echo_buff_len = . - msg_echo

    # pierwsza wiadomosc dla uzytkownika
    msg_info1: .ascii "Wprowadz lancuch znakow do zapisania do pliku:\n"
    msg_info1_len = . - msg_info1

    # druga wiadomosc dla uzytkownika
    msg_info2: .ascii "Zapisano do pliku.\n"
    msg_info2_len = . - msg_info2


.bss
    # zmienna dla prawidlowej dlugosci lancucha
    .lcomm msg_echo_input_len, 4

    # uchwyt do pliku
    .lcomm filehandle, 4


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

    # otwarcie pliku (jesli plik nie istnieje, to zostanie utworzony)
    pushl $RWE_ALL              # argument 3 - permisje
    pushl $CR_RE_WR_ONLY        # argument 2 - tryp dostepu
    pushl $file_name            # argument 1 - nazwa pliku
    call open_function          # wywolanie funkcji
    addl $12, %esp              # usuniecie argumentow ze stosu
    movl %eax, filehandle       # zapisanie uchwytu do pliku
    
    # zapisanie do pliku podanego lanuchca znakow
    pushl msg_echo_input_len    # argument 3 - wlasciwa dlugosc lanuchca
    pushl $msg_echo             # argument 2 - bufor lancucha znakow
    pushl filehandle            # argument 1 - wyjscie do pliku
    call write_function         # wywolanie funkcji
    addl $8, %esp               # usuniecie argumentow ze stosu

    # zamkniecie pliku
    pushl filehandle        # argument 1 - uchwyt pliku
    call close_function     # wywolanie funkcji
    addl $4, %esp           # usuniecie argumentow ze stosu

    # wiadomosc info2
    pushl $msg_info2_len    # argument 3 - dlugosc lanuchca
    pushl $msg_info2        # argument 2 - lancuch znakow
    pushl $STDOUT           # argument 1 - standardowe wyjscie
    call write_function     # wywolanie funkcji
    addl $8, %esp           # usuniecie argumentow ze stosu

    # zakonczenie programu
    pushl msg_echo_input_len # argument 1 - kod powrotu
    call exit_function       # wywolanie funkcji
    addl $4, %esp            # usuniecie argumentu ze stosu
