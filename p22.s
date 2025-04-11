// ===============================================
// Estudiante y No de control:  villegas suarez francisco javier --2210364
// Descripción: Programa en ensamblador ARM64 Desplazamientos a la izquierda y derecha
// ===============================================

// ===============================================
// Solucion en C#
// ===============================================`
/*
using System;

class Program
{
    static void Main()
    {
        Console.Write("Ingresa un número entero: ");
        int numero = int.Parse(Console.ReadLine());

        Console.Write("Ingresa el número de posiciones para desplazar: ");
        int posiciones = int.Parse(Console.ReadLine());

        // Desplazamiento a la izquierda
        int desplazamientoIzquierda = numero << posiciones;
        Console.WriteLine($"\nResultado de desplazar {numero} a la izquierda por {posiciones} posiciones: {desplazamientoIzquierda}");
        Console.WriteLine("Representación binaria:");
        MostrarEnBinario(numero, desplazamientoIzquierda, "Izquierda");

        // Desplazamiento a la derecha
        int desplazamientoDerecha = numero >> posiciones;
        Console.WriteLine($"\nResultado de desplazar {numero} a la derecha por {posiciones} posiciones: {desplazamientoDerecha}");
        Console.WriteLine("Representación binaria:");
        MostrarEnBinario(numero, desplazamientoDerecha, "Derecha");
    }

    static void MostrarEnBinario(int numeroOriginal, int resultado, string direccion)
    {
        Console.WriteLine(Convert.ToString(numeroOriginal, 2).PadLeft(32, '0') + $"  ({numeroOriginal})");
        Console.WriteLine($"Desplazamiento a la {direccion}".PadLeft(32));
        Console.WriteLine("=".PadLeft(32, '='));
        Console.WriteLine(Convert.ToString(resultado, 2).PadLeft(32, '0') + $"  ({resultado})\n");
    }
}

*/


// ===============================================
// Solucion en ARM54 Assembler
// ===============================================

.data
    x:      .quad   0x1234567812345678    // Número de 64 bits
    y:      .quad   0x0000000000000005    // Número de 64 bits
    
    msgX:    .string "Valor de x: %016lX\n"
    msgY:    .string "Valor de y: %016lX\n"
    msgLeft: .string "Desplazamiento a la izquierda: %016lX\n"
    msgRight:.string "Desplazamiento a la derecha: %016lX\n"
    newline: .string "\n"

.text
.global main
.align 2

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    // Imprimir valor de x
    adrp    x0, msgX
    add     x0, x0, :lo12:msgX
    mov     x1, x
    bl      printf
    
    // Imprimir valor de y
    adrp    x0, msgY
    add     x0, x0, :lo12:msgY
    mov     x1, y
    bl      printf
    
    // Desplazamiento a la izquierda
    mov     x0, x                      // Cargar el valor de x
    mov     x1, y                      // Cargar el valor de y
    bl      shift_left
    
    // Desplazamiento a la derecha
    mov     x0, x                      // Cargar el valor de x
    mov     x1, y                      // Cargar el valor de y
    bl      shift_right
    
    ldp     x29, x30, [sp], #16
    mov     x0, #0
    ret

// Función para desplazamiento a la izquierda
shift_left:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    lsl     x0, x0, x1                 // Desplazar x a la izquierda por y bits
    
    // Imprimir resultado
    adrp    x0, msgLeft
    add     x0, x0, :lo12:msgLeft
    bl      printf
    
    ldp     x29, x30, [sp], #16
    ret

// Función para desplazamiento a la derecha
shift_right:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    lsr     x0, x0, x1                 // Desplazar x a la derecha por y bits
    
    // Imprimir resultado
    adrp    x0, msgRight
    add     x0, x0, :lo12:msgRight
    bl      printf
    
    ldp     x29, x30, [sp], #16
    ret
