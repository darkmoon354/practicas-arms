// ===============================================
// Estudiante y No de control: Villegas Suarez Francisco Javier--22210364
// Descripción: Programa en ensamblador ARM64 Minimo Común Divisor (MCD)
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
        // Solicitar al usuario los dos números
        Console.Write("Introduce el primer número: ");
        int a = int.Parse(Console.ReadLine());

        Console.Write("Introduce el segundo número: ");

        // Calcular el MCD utilizando el algoritmo de Euclides
        int mcd = CalcularMCD(a, b);

        // Mostrar el resultado
        Console.WriteLine($"El Mínimo Común Divisor (MCD) de {a} y {b} es: {mcd}");
    }

    // Método para calcular el MCD usando el Algoritmo de Euclides
    static int CalcularMCD(int a, int b)
    {
        // El algoritmo de Euclides para encontrar el MCD
        while (b != 0)
        {
            int temp = b;
            b = a % b;
            a = temp;
        }
        return a;
    }
}
*/

// ===============================================
// Solucion en ARM54 Assembler
// ===============================================
.text
.global main
.align 2

main:
    // Prologo de la función main
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Cargar los valores de entrada
    mov     w0, #56                 // Ejemplo: primer número
    mov     w1, #98                 // Ejemplo: segundo número

    // Guardar los valores originales para usarlos después
    mov     w3, w0                  // Guardar primer número en w3
    mov     w4, w1                  // Guardar segundo número en w4

    // Llamar a la función para calcular el MCD
    bl      calcular_mcd            // w0 contendrá el MCD al retornar

    // Calcular MCM usando la fórmula: MCM = (a * b) / MCD
    mul     w5, w3, w4              // w5 = a * b
    udiv    w0, w5, w0              // w0 = (a * b) / MCD, que es el MCM

    // Imprimir el resultado (MCM en w0)
    adrp    x0, msg_mcm             // Cargar el mensaje para printf
    add     x0, x0, :lo12:msg_mcm
    mov     w1, w0                  // Pasar el MCM a w1 como argumento para printf
    bl      printf

    // Epílogo de la función main
    ldp     x29, x30, [sp], #16
    mov     x0, #0                  // Código de salida 0
    ret

// Función calcular_mcd
// Entrada: w0 = primer número, w1 = segundo número
// Salida: w0 = MCD de los dos números
calcular_mcd:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

loop_mcd:
    cmp     w1, #0                  // Comparar w1 con 0
    beq     fin_mcd                 // Si w1 es 0, fin (MCD está en w0)
    udiv    w2, w0, w1              // w2 = w0 / w1
    msub    w2, w2, w1, w0          // w2 = w0 - (w2 * w1) -> residuo
    mov     w0, w1                  // w0 = w1 (intercambiar)
    mov     w1, w2                  // w1 = residuo
    b       loop_mcd                // Repetir mientras w1 no sea 0

fin_mcd:
    ldp     x29, x30, [sp], #16
    ret                             // Retornar el MCD en w0

// Datos
.data
msg_mcm: .string "El MCM es: %d\n"
