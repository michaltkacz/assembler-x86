// Kompilacja: gcc zamien-asf.c zamien-asf.s -g -m32 -o zamien-asf

#include <stdio.h>

int main(void) 
{
    int arg1 = 534;
    int arg2 = 1057;
    int sum, diff;

    printf("arg1: %d arg2: %d\n", arg1, arg2);
    
    sum = swap_add(&arg1, &arg2);
    
    printf("arg1: %d arg2: %d\n", arg1, arg2);

    diff = arg1 - arg2;

    printf("sum: %d diff: %d\n", sum, diff);

    return sum * diff;
}