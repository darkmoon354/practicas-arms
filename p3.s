// ===============================================
// Estudiante y No de control: Villegas Suarez Francisco Javier.
// Descripción: Programa en ensamblador ARM64 para convertir una temperatura de Celsius a Fahrenheit.
// ===============================================

// ===============================================
// Solucion en C#
// ===============================================
// using System;
// 
// class Program
// {
//     static void Main()
//     {
//         Console.Write("Ingrese los grados Celsius: ");
//         double celsius = Convert.ToDouble(Console.ReadLine());
// 
//         // Conversión de Celsius a Fahrenheit
//         double fahrenheit = (celsius * 9 / 5) + 32;
//
//         Console.WriteLine($"{celsius} grados Celsius son {fahrenheit} grados Fahrenheit.");
//     }
// }

// ===============================================
// Solucion en ARM54 Assembler
// ===============================================
    .data
celsius:    .double 25.0               // Definimos el valor de entrada en Celsius.
fahrenheit: .double 0.0                // Espacio para almacenar el resultado en Fahrenheit.
msg:        .asciz "Fahrenheit: "      // Mensaje de texto.
buffer:     .space 20                  // Espacio para almacenar el número convertido en texto.

    .text
    .global _start

_start:
    // Cargar el valor en Celsius desde la memoria.
    ldr d0, celsius                    // Cargar el valor de Celsius en el registro d0

    // Realizar la conversión de Celsius a Fahrenheit.
    // Fórmula: Fahrenheit = (Celsius * 9/5) + 32

    // Multiplicar Celsius por 9
    mov x1, #9
    scvtf d1, x1                       // Convertimos 9 a punto flotante y lo almacenamos en d1
    fmul d0, d0, d1                    // Celsius * 9 (resultado en d0)

    // Dividir el resultado por 5
    mov x1, #5
    scvtf d1, x1                       // Convertimos 5 a punto flotante y lo almacenamos en d1
    fdiv d0, d0, d1                    // (Celsius * 9) / 5

    // Sumar 32 para completar la conversión
    mov x1, #32
    scvtf d1, x1                       // Convertimos 32 a punto flotante y lo almacenamos en d1
    fadd d0, d0, d1                    // (Celsius * 9/5) + 32 (resultado final en d0)

    // Almacenar el resultado en la variable `fahrenheit`
    adrp x1, fahrenheit                // Cargar la dirección de la página de `fahrenheit`
    add x1, x1, :lo12:fahrenheit       // Ajustar el desplazamiento de la dirección completa
    str d0, [x1]                       // Guardar el valor de Fahrenheit en la dirección apuntada por x1

    // Convertir el resultado de punto flotante a entero para mostrar
    fcvtzs x2, d0                      // Convierte el valor en d0 a entero y lo almacena en x2

    // Convertir el número en `x2` a cadena ASCII y guardarlo en `buffer`
    mov x0, x2                         // Mover el valor a x0 para manipular
    adrp x3, buffer                    // Cargar la dirección base de `buffer`
    add x3, x3, :lo12:buffer           // Cargar la dirección completa de `buffer`
    add x3, x3, #19                    // Apuntar al final del buffer

convertir_a_cadena:
    mov x4, #10
    udiv x5, x0, x4                    // x5 = x0 / 10
    msub x6, x5, x4, x0                // x6 = x0 % 10
    add x6, x6, '0'                    // Convertir dígito a ASCII
    strb w6, [x3, #-1]!                // Almacenar dígito y mover el puntero hacia atrás
    mov x0, x5                         // Actualizar x0 al cociente
    cbnz x0, convertir_a_cadena        // Repetir hasta que x0 sea 0

    // Mostrar el mensaje "Fahrenheit: "
    mov x0, #1                         // Descriptor de archivo 1 (stdout)
    ldr x1, =msg                       // Dirección del mensaje
    mov x2, #12                        // Longitud del mensaje
    mov x8, #64                        // Syscall de escritura
    svc 0

    // Mostrar el número en el buffer
    mov x0, #1                         // Descriptor de archivo 1 (stdout)
    mov x1, x3                         // Apuntar al inicio de la cadena convertida
    adrp x4, buffer                    // Cargar la dirección base de `buffer`
    add x4, x4, :lo12:buffer           // Cargar la dirección completa de `buffer`
    add x4, x4, #20                    // x4 = buffer + 20
    sub x2, x4, x3                     // Calcular la longitud de la cadena
    mov x8, #64                        // Syscall de escritura
    svc 0

    // Salir del programa
    mov x8, #93                        // Número de syscall para salir en Linux
    mov x0, #0                         // Código de salida 0
    svc 0
