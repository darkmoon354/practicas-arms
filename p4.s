// ===============================================
// Estudiante y No de control: Villegas Suarez Francisco Javier
// Descripción: Programa en ensamblador ARM64 para invertir una cadena
// ===============================================

// ===============================================
// Solucion en C#
// ===============================================
/*
using System;
using System.Linq;

class Program
{
    static void Main()
    {
        // Pedir al usuario que ingrese una cadena
        Console.Write("Ingrese una cadena: ");
        string input = Console.ReadLine();

        // Usar LINQ para invertir la cadena
        string reversed = new string(input.Reverse().ToArray());

        // Mostrar la cadena invertida
        Console.WriteLine($"La cadena invertida es: {reversed}");
    }
}

*/

// ===============================================
// Solucion en ARM64 Assembler
// ===============================================

.data
    mensaje: .asciz "Ingresa una cadena para invertir: "
    resultado: .asciz "\nCadena invertida: "
    newline: .asciz "\n"

.bss
    .lcomm buffer, 100       // Buffer para la cadena de entrada, tamaño 100 bytes

.text
.global _start

_start:
    // Imprimir mensaje para ingresar cadena
    mov x0, #1                // file descriptor 1 (stdout)
    adrp x1, mensaje          // Obtener página de dirección del mensaje
    add x1, x1, :lo12:mensaje // Obtener dirección completa
    mov x2, #32               // Longitud del mensaje
    mov x8, #64               // syscall write
    svc #0

    // Leer cadena del usuario
    mov x0, #0                // file descriptor 0 (stdin)
    adrp x1, buffer           // Obtener página de dirección del buffer
    add x1, x1, :lo12:buffer  // Obtener dirección completa
    mov x2, #100              // Tamaño máximo de la entrada
    mov x8, #63               // syscall read
    svc #0
    
    // Guardar la longitud real leída (retornada en x0)
    mov x4, x0                // x4 = longitud de la cadena incluyendo \n

    // Remover el salto de línea al final de la entrada
    cmp x4, #0                // Si la longitud es 0, saltar
    beq invertir
    sub x5, x4, #1            // Posición del último carácter
    adrp x3, buffer           // Dirección base del buffer
    add x3, x3, :lo12:buffer  // Dirección completa
    ldrb w6, [x3, x5]         // Cargar último carácter
    cmp w6, #10               // Si es '\n', reemplazar con '\0'
    bne invertir
    mov w6, #0                // Carácter nulo '\0'
    strb w6, [x3, x5]         // Reemplazar '\n' por '\0'
    sub x4, x4, #1            // Ajustar la longitud (sin el \n)

invertir:
    // Punteros para inicio y fin de la cadena
    adrp x1, buffer           // Obtener página de dirección del buffer
    add x1, x1, :lo12:buffer  // x1 apunta al inicio de la cadena
    add x2, x1, x4            // x2 apunta al final de la cadena
    sub x2, x2, #1            // Ajustar para apuntar al último carácter

invertir_loop:
    cmp x1, x2                // Comparar punteros de inicio y fin
    bge imprimir_resultado    // Si se cruzan, terminar inversión

    // Intercambiar caracteres en x1 y x2
    ldrb w3, [x1]             // Cargar carácter en inicio (x1)
    ldrb w4, [x2]             // Cargar carácter en fin (x2)
    strb w4, [x1]             // Escribir carácter de fin en inicio
    strb w3, [x2]             // Escribir carácter de inicio en fin

    // Mover punteros hacia el centro
    add x1, x1, #1            // Avanzar puntero de inicio
    sub x2, x2, #1            // Retroceder puntero de fin
    b invertir_loop

imprimir_resultado:
    // Imprimir mensaje de resultado
    mov x0, #1                // file descriptor 1 (stdout)
    adrp x1, resultado        // Obtener página de dirección del mensaje
    add x1, x1, :lo12:resultado // Obtener dirección completa
    mov x2, #18               // Longitud del mensaje
    mov x8, #64               // syscall write
    svc #0

    // Imprimir cadena invertida
    mov x0, #1                // file descriptor 1 (stdout)
    adrp x1, buffer           // Obtener página de dirección del buffer
    add x1, x1, :lo12:buffer  // Dirección completa
    mov x2, x4                // Longitud de la cadena invertida
    mov x8, #64               // syscall write
    svc #0

    // Imprimir nueva línea final
    mov x0, #1                // file descriptor 1 (stdout)
    adrp x1, newline          // Obtener página de dirección del newline
    add x1, x1, :lo12:newline // Dirección completa
    mov x2, #1                // Longitud de la nueva línea
    mov x8, #64               // syscall write
    svc #0

    // Terminar programa
    mov x8, #93               // syscall exit
    mov x0, #0                // Código de salida
    svc #0
