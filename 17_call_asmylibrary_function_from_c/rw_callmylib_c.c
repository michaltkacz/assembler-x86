// Kompilacja: gcc rw_callmylib_c.c -m32 -L. -lmylib -g -o rw_callmylib_c

#include <string.h>

#define STDIN  0
#define STDOUT 1

int main()
{
    char str1[] = "Podaj napis:\n";
    int str1_len = strlen(str1);
    //write_function(STDOUT, str1, str1_len);
    write(STDOUT, str1, str1_len);

    char str_in[] = "                     ";
    int str_in_len = strlen(str_in);
    //str_in_len = read_function(STDIN, str_in, str_in_len);
    str_in_len = read(STDIN, str_in, str_in_len);

    //write_function(STDOUT, str_in, str_in_len);
    write(STDOUT, str_in, str_in_len);

    exit_function(str_in_len);
}