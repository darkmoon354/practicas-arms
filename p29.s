// ===============================================
// Estudiante y No de control: Villegas Suarez Francisco Javier
// Descripción: Programa en ensamblador ARM64 Suma de elementos en un arreglo
// ===============================================

// ===============================================
// Solucion en C#
// ===============================================

/*
using System;
class Program
{
    // Función para calcular la suma de los elementos en un arreglo
    static int SumarElementos(int[] arreglo)
    {
        int suma = 0;

        // Iterar sobre el arreglo y sumar cada elemento
        foreach (int numero in arreglo)
        {
            suma += numero;
        }

        return suma;
    }

    static void Main()
    {
        // Definir un arreglo de enteros
        int[] arreglo = { 1, 2, 3, 4, 5 };

        // Calcular la suma de los elementos del arreglo
        int resultado = SumarElementos(arreglo);

        // Mostrar el resultado
        Console.WriteLine("La suma de los elementos del arreglo es: " + resultado);
    }
}
*/

// ===============================================
// Solucion en ARM54 Assembler
// ===============================================

.data
arreglo: .word 32145435, 5345, 12345, 6789, 10234  // Arreglo de ejemplo con 5 elementos
tamano: .word 5                                    // Tamaño del arreglo (definido directamente)

msg_suma: .string "La suma de los elementos es: %d\n"  

.text
.global main
.align 2

main:
    // Prologo de la función main
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Inicializar la suma y el índice
    mov     w0, #0                    // Suma acumulada
    mov     w1, #5                    // Tamaño del arreglo
    adrp    x2, arreglo               // Dirección base del arreglo
    add     x2, x2, :lo12:arreglo

loop_suma:
    cbz     w1, fin_suma              // Si el tamaño es 0, terminar el bucle

    ldr     w3, [x2], #4              // Cargar un elemento de 4 bytes y avanzar la dirección
    add     w0, w0, w3                // Sumar el elemento al acumulador
    sub     w1, w1, #1                // Decrementar el tamaño (contador de elementos)

    b       loop_suma                 // Repetir para el siguiente elemento

fin_suma:
    // Imprimir el resultado
    adrp    x0, msg_suma              // Cargar el mensaje para printf
    add     x0, x0, :lo12:msg_suma
    mov     w1, w0                    // Pasar la suma a w1 como argumento para printf
    bl      printf

    // Epílogo de la función main
    ldp     x29, x30, [sp], #16       // Restaurar el frame pointer y el link register
    mov     x0, #0                    // Código de salida 0
    ret
