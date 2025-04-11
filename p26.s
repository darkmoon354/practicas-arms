// ===============================================
// Estudiante y No de control: Villegas Suarez Francisco Javier--22210364
// Descripción: Programa en ensamblador ARM64 Máximo Común Divisor (MCD)
// ===============================================

// ===============================================
// Solucion en C#
// ===============================================

/*
using System;

class Program
{
    // Método para calcular el MCD utilizando el algoritmo de Euclides
    static int CalcularMCD(int a, int b)
    {
        while (b != 0)
        {
            int temp = b;
            b = a % b;
            a = temp;
        }
        return a;
    }

    static void Main()
    {
        // Solicitar los números al usuario
        Console.Write("Introduce el primer número: ");
        int num1 = int.Parse(Console.ReadLine());

        Console.Write("Introduce el segundo número: ");
        int num2 = int.Parse(Console.ReadLine());

        // Calcular el MCD
        int mcd = CalcularMCD(num1, num2);

        // Mostrar el resultado
        Console.WriteLine($"El Máximo Común Divisor de {num1} y {num2} es: {mcd}");
    }
}

*/

// ===============================================
// Archivo C
// ===============================================

/*
#include <stdio.h>
extern long gcd_func(long a, long b);

int main() {
    long a, b;

    // Capturar los valores de a y b desde el usuario
    printf("Ingrese el primer número (positivo): ");
    scanf("%ld", &a);
    printf("Ingrese el segundo número (positivo): ");
    scanf("%ld", &b);

    // Validar que los números sean positivos
    if (a <= 0 || b <= 0) {
        printf("Error: Ambos números deben ser positivos y mayores que cero.\n");
        return 1;
    }

    // Llamar a la función ensambladora que ejecuta la macro gcd
    long result = gcd_func(a, b);

    // Imprimir el resultado
    printf("El MCD de %ld y %ld es: %ld\n", a, b, result);

    return 0;
}
*/

// ===============================================
// Solucion en ARM54 Assembler
// ===============================================
.macro gcd a, b
1:                      
    cmp \a, \b          // Comparar a y b
    b.eq 2f             // Si a == b, saltar al final
    sub \a, \a, \b      // Si a > b, restar b de a
    sub \b, \b, \a      // Si a < b, restar a de b
    b 1b                // Volver a comparar
2:
.endm

// Función en ensamblador que calcula el MCD
.text
.globl gcd_func
.type gcd_func, %function
gcd_func:
    // Argumentos en X0 y X1 (a y b)
    gcd x0, x1          // Ejecutar la macro gcd con X0 y X1
    mov x0, x1          // Mover el resultado a X0 para retornarlo
    ret                 // Retornar el valor en X0
