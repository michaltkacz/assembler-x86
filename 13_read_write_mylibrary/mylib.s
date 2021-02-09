# Kompilacja: as mylib.s -32 -g -o mylib.o
# Laczenie: gcc rw_callmylib.s mylib.o -m32 -g -o rw_callmylib
# Uruchomienie: ./rw_callmylib; echo $?

SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4


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
