// ===============================================
// Estudiante y No de control: Villegas Suarez Francisco  Javier 22210364
// Descripción: Programa en ensamblador ARM64 para encontrar el máximo en un arreglo
// ===============================================

// ===============================================
// Solucion en C#
// ===============================================
/*
using System;

class Program
{
    static void Main()
    {
        // Definir el arreglo
        int[] numeros = { 3, 7, 2, 9, 12, 5, 8 };

        // Llamar a la función para encontrar el máximo
        int maximo = EncontrarMaximo(numeros);

        // Mostrar el resultado
        Console.WriteLine("El valor máximo en el arreglo es: " + maximo);
    }

    static int EncontrarMaximo(int[] arreglo)
    {
        // Asumimos que el primer elemento es el máximo inicialmente
        int max = arreglo[0];

        // Recorrer el arreglo y encontrar el máximo
        for (int i = 1; i < arreglo.Length; i++)
        {
            if (arreglo[i] > max)
            {
                max = arreglo[i];
            }
        }

        return max;
    }
}
*/

// ===============================================
// Codigo extra en lenguaje C
// ===============================================

/*
#include <stdio.h>

// Declaramos la función de ensamblador
extern void encontrar_maximo();

// Declaramos la variable resultado como externa
extern int resultado;

int main() {
    // Llamamos a la función de ensamblador
    encontrar_maximo();

    // Imprimimos el resultado
    printf("El valor máximo en el arreglo es: %d\n", resultado);
    return 0;
}
*/


// ===============================================
// Solucion en ARM54 Assembler
// ===============================================
  .data
arreglo:
    .word 5, 10, 3, 21, 7, 15, 6    // Ejemplo de arreglo de enteros de 32 bits
longitud:
    .word 7                         // Longitud del arreglo

.global resultado
resultado:
    .word 0                         // Variable para almacenar el máximo

    .text
    .global encontrar_maximo

encontrar_maximo:
    ldr x0, =arreglo                // Cargar la dirección base del arreglo en x0
    ldr w1, =7                      // Cargar la longitud del arreglo en w1 (longitud)
    ldr w2, [x0]                    // Inicializar w2 con el primer elemento (valor máximo inicial)

    mov w3, #1                      // Índice para iterar por el arreglo

buscar_maximo:
    cmp w3, w1                      // Comprobar si llegamos al final del arreglo
    bge fin                         // Si el índice es >= longitud, termina el bucle

    ldr w4, [x0, x3, LSL #2]        // Cargar el siguiente elemento en w4
    cmp w4, w2                      // Comparar el elemento actual con el máximo actual
    ble siguiente                   // Si w4 <= w2, saltar a siguiente
    mov w2, w4                      // Actualizar w2 con el nuevo máximo

siguiente:
    add w3, w3, #1                  // Incrementar el índice
    b buscar_maximo                 // Repetir el bucle

fin:
    ldr x5, =resultado              // Cargar la dirección de 'resultado'
    str w2, [x5]                    // Guardar el valor máximo en 'resultado'
    ret
