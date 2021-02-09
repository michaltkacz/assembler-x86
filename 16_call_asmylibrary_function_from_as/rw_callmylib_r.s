# Kompilacja: gcc rw_callmylib_r.s -m32 -L. -lmylib -g -o rw_callmylib_r


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

    # bufor na wczytanie lanuchca znakow z pliku
    msg_echo: .ascii "                                  "
    msg_echo_buff_len = . - msg_echo

    # wiadomosc dla uzytkownika
    msg_info: .ascii "Wczytano lancuch znakow:\n"
    msg_info_len = . - msg_info


.bss
    # zmienna dla prawidlowej dlugosci lancucha
    .lcomm msg_echo_input_len, 4

    # uchwyty do pliku
    .lcomm filehandle, 4


.text
.global main
# main
main:
    # wiadomosc info
    pushl $msg_info_len         # argument 3 - dlugosc lanuchca
    pushl $msg_info             # argument 2 - lancuch znakow
    pushl $STDOUT               # argument 1 - standardowe wyjscie
    call write_function         # wywolanie funkcji
    addl $12, %esp              # usuniecie argumentow ze stosu

    # otwarcie pliku (jesli plik nie istnieje, to zostanie utworzony)
    pushl $RWE_ALL              # argument 3 - permisje
    pushl $CR_RE_WR_ONLY        # argument 2 - tryp dostepu
    pushl $file_name            # argument 1 - nazwa pliku
    call open_function          # wywolanie funkcji
    addl $12, %esp              # usuniecie argumentow ze stosu
    movl %eax, filehandle       # zapisanie uchwytu do pliku

    # wczytanie lancucha znakow z pliku
    pushl $msg_echo_buff_len        # argument 3 - dlugosc bufora lanuchca
    pushl $msg_echo                 # argument 2 - bufor lancucha znakow
    pushl filehandle                # argument 1 - wjescie standardowe
    call read_function              # wywolanie funkcji
    addl $12, %esp                  # usuniecie argumentow ze stosu
    movl %eax, msg_echo_input_len   # dlugosc wprowadzonego lanuchca

    # zamkniecie pliku
    pushl filehandle        # argument 1 - uchwyt pliku
    call close_function     # wywolanie funkcji
    addl $4, %esp           # usuniecie argumentow ze stosu

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
