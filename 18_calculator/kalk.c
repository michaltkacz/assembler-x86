// Kalkulator
// Kompilacja: gcc kalk.c kalk.s -m32 -g -o kalk

#include <stdio.h>
#include <stdlib.h>

// prototypy funkcji
double my_add(double a, double b);
double my_sub(double a, double b);
double my_mul(double a, double b);
double my_div(double a, double b);
double my_sqrt(double a);
double my_sin(double a);

double a = 0.0f;
double b = 0.0f;
double result = 0.0f;

int main()
{
    int option = 0;

    printf("Witaj w kalkulatorze!\n");
    
    while(1)
    {
        printf("\n");
        printf("Dostepne opcje:\n");
        printf("0. Wyjscie\n");
        printf("1. Dodawanie\n");
        printf("2. Odejmowanie\n");
        printf("3. Mnozenie\n");
        printf("4. Dzielenie\n");
        printf("5. Pierwiastek kwadratowy\n");
        printf("6. Sinus\n");
        printf("Wybierz opcje: ");
        scanf("%i", &option);

        if(option == 0)
        {
            break;
        }

        printf("(Dla pierwiastka i sinusa rozpatrywany jest argument a.)\n");
        printf("Wprowadz argument a: ");
        scanf("%lf", &a);
        printf("Wprowadz argument b: ");
        scanf("%lf", &b);

        switch(option)
        {
            case 1:
            {
                result = my_add(a, b);
                printf("Suma: %f\n", result);
                break;
            }
            case 2:
            {
                result = my_sub(a, b);
                printf("Roznica: %f\n", result);
                break;
            }
            case 3:
            {
                result = my_mul(a, b);
                printf("Iloczyn: %f\n", result);
                break;
            }
            case 4:
            {
                if(b != 0)
                {
                    result = my_div(a, b);
                    printf("Iloraz: %f\n", result);
                } else
                {
                    printf("Dzielnik nie moze byc zerem!\n");
                }
                break;
            }
            case 5:
            {
                result = my_sqrt(a);
                printf("Pierwiastek kwadratowy: %f\n", result);
                break;
            }
            case 6:
            {
                result = my_sin(a);
                printf("Sinus: %f\n", result);
                break;
            }
            default:
                printf("Nie ma takiej opcji!\n");
                break;
        }
    }

    printf("Koniec.\n");
}