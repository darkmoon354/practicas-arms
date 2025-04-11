// ===============================================
// Estudiante y No de control: Cruz Patiño Diego - 22210297
// Descripción: Programa en ensamblador ARM64 para Operaciones AND, OR, XOR a nivel de bits
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
        // Solicitar al usuario que ingrese dos números enteros
        Console.Write("Ingresa el primer número entero: ");
        int numero1 = int.Parse(Console.ReadLine());

        Console.Write("Ingresa el segundo número entero: ");
        int numero2 = int.Parse(Console.ReadLine());

        // Operación AND
        int resultadoAND = numero1 & numero2;
        Console.WriteLine($"\nResultado de {numero1} AND {numero2} = {resultadoAND}");
        Console.WriteLine("Representación binaria:");
        MostrarResultadoEnBinario(numero1, numero2, resultadoAND, "AND");

        // Operación OR
        int resultadoOR = numero1 | numero2;
        Console.WriteLine($"\nResultado de {numero1} OR {numero2} = {resultadoOR}");
        Console.WriteLine("Representación binaria:");
        MostrarResultadoEnBinario(numero1, numero2, resultadoOR, "OR");

        // Operación XOR
        int resultadoXOR = numero1 ^ numero2;
        Console.WriteLine($"\nResultado de {numero1} XOR {numero2} = {resultadoXOR}");
        Console.WriteLine("Representación binaria:");
        MostrarResultadoEnBinario(numero1, numero2, resultadoXOR, "XOR");
    }

    static void MostrarResultadoEnBinario(int num1, int num2, int resultado, string operacion)
    {
        // Mostrar los números en binario con formato de 32 bits
        Console.WriteLine(Convert.ToString(num1, 2).PadLeft(32, '0') + $"  ({num1})");
        Console.WriteLine($"{operacion.PadLeft(32)}");
        Console.WriteLine(Convert.ToString(num2, 2).PadLeft(32, '0') + $"  ({num2})");
        Console.WriteLine("=".PadLeft(32, '='));
        Console.WriteLine(Convert.ToString(resultado, 2).PadLeft(32, '0') + $"  ({resultado})\n");
    }
}

*/

// ===============================================
// Solucion en ARM54 Assembler
// ===============================================

.data
    // Valores de entrada
    value1:      .quad   0x1234567812345678
    value2:      .quad   0x8765432187654321

    // Mensajes de salida
    msgAnd:      .string "AND: %016lX\n"
    msgOr:       .string "OR: %016lX\n"
    msgXor:      .string "XOR: %016lX\n"

.text
.global main
.align 2

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Realizar operaciones bitwise
    ldr     x2, =value1
    ldr     x3, =value2
    ldr     x2, [x2]
    ldr     x3, [x3]

    and     x4, x2, x3
    orr     x5, x2, x3
    eor     x6, x2, x3

    // Imprimir resultados
    adrp    x0, msgAnd
    add     x0, x0, :lo12:msgAnd
    mov     x1, x4
    bl      printf

    adrp    x0, msgOr
    add     x0, x0, :lo12:msgOr
    mov     x1, x5
    bl      printf

    adrp    x0, msgXor
    add     x0, x0, :lo12:msgXor
    mov     x1, x6
    bl      printf

    ldp     x29, x30, [sp], #16
    mov     x0, #0
    ret
