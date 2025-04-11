// ===============================================
// Estudiante y No de control: Villegas Suarez Francisco Javier--22210364
// Descripción: Programa en ensamblador ARM64 Invertir los elementos de un arreglo
// ===============================================

// ===============================================
// Solucion en C#
// ===============================================

/*
using System;

class Program
{
    // Función para invertir los elementos de un arreglo
    static void InvertirArreglo(int[] arreglo)
    {
        int inicio = 0;
        int fin = arreglo.Length - 1;

        // Intercambiar los elementos desde el principio y el final hasta llegar al medio
        while (inicio < fin)
        {
            int temp = arreglo[inicio];
            arreglo[inicio] = arreglo[fin];
            arreglo[fin] = temp;

            inicio++;
            fin--;
        }
    }

    static void Main()
    {
        // Definir un arreglo de enteros
        int[] arreglo = { 1, 2, 3, 4, 5 };

        // Mostrar el arreglo original
        Console.WriteLine("Arreglo original:");
        MostrarArreglo(arreglo);

        // Invertir el arreglo
        InvertirArreglo(arreglo);

        // Mostrar el arreglo invertido
        Console.WriteLine("\nArreglo invertido:");
        MostrarArreglo(arreglo);
    }

    // Función para mostrar los elementos de un arreglo
    static void MostrarArreglo(int[] arreglo)
    {
        foreach (int numero in arreglo)
        {
            Console.Write(numero + " ");
        }
        Console.WriteLine();
    }
}
*/


// ===============================================
// Archivo C
// ===============================================

/*
#include <stdio.h>
#include <stdlib.h>

// Declarar la función de ensamblador
extern void invertir_arreglo(long* arreglo, long tamaño);

int main() {
    int n;

    // Solicitar el número de elementos en el arreglo
    printf("Introduce el número de elementos en el arreglo: ");
    scanf("%d", &n);

    // Crear el arreglo de tipo long
    long* arreglo = (long*)malloc(n * sizeof(long));

    // Solicitar los elementos del arreglo
    printf("Introduce los elementos del arreglo:\n");
    for (int i = 0; i < n; i++) {
        printf("Elemento %d: ", i + 1);
        scanf("%ld", &arreglo[i]);
    }

    // Llamar a la función de ensamblador para invertir el arreglo
    invertir_arreglo(arreglo, n);

    // Imprimir el arreglo invertido
    printf("Arreglo invertido:\n");
    for (int i = 0; i < n; i++) {
        printf("%ld ", arreglo[i]);
    }
    printf("\n");

    // Liberar la memoria
    free(arreglo);

    return 0;
}

*/

// ===============================================
// Solucion en ARM54 Assembler
// ===============================================
.global invertir_arreglo

// Función que invierte un arreglo
// Entrada: x0 = puntero al arreglo, x1 = tamaño del arreglo
invertir_arreglo:
    // Guardar registros
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Calcular los límites iniciales
    mov x2, x0           // x2 = puntero al inicio del arreglo
    add x3, x0, x1, lsl #3  // x3 = puntero al final del arreglo (x1 * 8 bytes para enteros de 64 bits)
    sub x3, x3, 8        // Ajustar x3 para que apunte al último elemento

invertir_loop:
    // Comparar los punteros para ver si se cruzaron
    cmp x2, x3
    b.ge invertir_done   // Si se cruzaron, terminar

    // Intercambiar los elementos apuntados por x2 y x3
    ldr x4, [x2]         // Cargar el valor en x2 en x4
    ldr x5, [x3]         // Cargar el valor en x3 en x5
    str x5, [x2]         // Almacenar x5 en la posición de x2
    str x4, [x3]         // Almacenar x4 en la posición de x3

    // Mover los punteros hacia el centro
    add x2, x2, 8        // Avanzar x2 al siguiente elemento
    sub x3, x3, 8        // Retroceder x3 al elemento anterior
    b invertir_loop      // Repetir el bucle

invertir_done:
    // Restaurar registros y retornar
    ldp x29, x30, [sp], 16
    ret
