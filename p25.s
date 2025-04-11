// ===============================================
// Estudiante y No de control: Villegas Suarez Francisco Javier--22210364
// Descripción: Programa en ensamblador ARM64 para restar 2 numeros
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
//         Console.Write("Ingrese el primer número: ");
//         int numero1 = Convert.ToInt32(Console.ReadLine());
//
//         Console.Write("Ingrese el segundo número: ");
//         int numero2 = Convert.ToInt32(Console.ReadLine());
//
//         // resta de los dos números
//         int resta = numero1 - numero2;
//
//         Console.WriteLine($"La resta de {numero1} y {numero2} es: {resta}");
//     }
// }

// ===============================================
// Solucion en ARM54 Assembler
// ===============================================
    .data
num1:       .word 10                        // Primer número
num2:       .word 5                         // Segundo número
resultado:  .word 0                         // Espacio para almacenar el resultado
msg:        .asciz "Resultado: "            // Mensaje a mostrar
buffer:     .space 20                       // Espacio para almacenar el número convertido en texto

    .text
    .global _start

_start:
    // Cargar los valores de num1 y num2 en registros.
    adrp x0, num1                          // Cargar la dirección base de num1
    ldr w1, [x0, :lo12:num1]               // Cargar el valor de num1 en w1
    adrp x0, num2                          // Cargar la dirección base de num2
    ldr w2, [x0, :lo12:num2]               // Cargar el valor de num2 en w2

    // Restar los dos valores.
    sub w3, w1, w2                         // Restar num2 de num1, almacenar en w3

    // Guardar el resultado en la memoria.
    adrp x0, resultado                     // Cargar la dirección base de resultado
    str w3, [x0, :lo12:resultado]          // Almacenar el resultado en la memoria

    // Convertir el resultado en w3 a cadena ASCII
    mov w0, w3                             // Mover el valor de w3 a w0 para manipular como entero de 32 bits
    adrp x1, buffer                        // Cargar la dirección base de buffer
    add x1, x1, :lo12:buffer               // Dirección completa de buffer
    add x1, x1, #19                        // Apuntar al final del buffer

convertir_a_cadena:
    mov x2, #10
    udiv w3, w0, w2                        // w3 = w0 / 10
    msub w4, w3, w2, w0                    // w4 = w0 % 10
    add w4, w4, '0'                        // Convertir dígito a ASCII
    strb w4, [x1, #-1]!                    // Almacenar el dígito y retroceder el puntero
    mov w0, w3                             // Actualizar w0 al cociente
    cbnz w0, convertir_a_cadena            // Repetir hasta que w0 sea 0

    // Mostrar el mensaje "Resultado: "
    mov x0, #1                             // Descriptor de archivo 1 (stdout)
    ldr x1, =msg                           // Dirección del mensaje
    mov x2, #11                            // Longitud del mensaje
    mov x8, #64                            // Syscall de escritura
    svc 0

    // Mostrar el número en el buffer
    mov x0, #1                             // Descriptor de archivo 1 (stdout)
    mov x1, x1                             // Apuntar al inicio de la cadena convertida
    adrp x4, buffer                        // Cargar la dirección base de buffer
    add x4, x4, :lo12:buffer               // Dirección completa de buffer
    add x4, x4, #20                        // x4 = buffer + 20
    sub x2, x4, x1                         // Calcular la longitud de la cadena
    mov x8, #64                            // Syscall de escritura
    svc 0

    // Finalizar el programa (llamada de salida en Linux).
    mov x8, #93                            // syscall exit
    mov x0, #0                             // código de salida 0
    svc 0
