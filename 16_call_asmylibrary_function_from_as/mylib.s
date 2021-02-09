# Kompilacja: as mylib.s -32 -g -o mylib.o
# Tworzenie biblioteki: ar rcsv libmylib.a mylib.o


SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
SYSOPEN = 5
SYSCLOSE = 6


# funkcja open
.global open_function
.type open_function, @function
open_function:
    # prolog
    pushl %ebp
    movl %esp, %ebp

    # funkcja
    movl $SYSOPEN, %eax
    movl 8(%ebp), %ebx
    movl 12(%ebp), %ecx
    movl 16(%ebp), %edx
    int $0x80

    # epilog
    movl %ebp, %esp
    popl %ebp
    ret

# funkcja close
.global close_function
.type close_function, @function
close_function:
    # prolog
    pushl %ebp
    movl %esp, %ebp

    # funkcja
    movl $SYSCLOSE, %eax
    movl 8(%ebp), %ebx
    int $0x80

    # epilog
    movl %ebp, %esp
    popl %ebp
    ret


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
    movl 12(%ebp), %ecx           # lancuch znakow - argument funkcji
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
    movl $SYSEXIT, %eax	            	
    movl 8(%ebp), %ebx      # Kod powrotu
    int $0x80

    # epilog
    movl %ebp, %esp
    popl %ebp
    ret
