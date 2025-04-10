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
// Solucion en ARM64 Assembler
// ===============================================
    .data
celsius:    .double 25.0               // Definimos el valor de entrada en Celsius.
fahrenheit: .double 0.0                // Espacio para almacenar el resultado en Fahrenheit.
msg:        .asciz "Fahrenheit: "      // Mensaje de texto.
buffer:     .space 20                  // Espacio para almacenar el número convertido en texto.
newline:    .asciz "\n"                // Carácter de nueva línea

    .text
    .global _start

_start:
    // Cargar el valor en Celsius desde la memoria.
    adrp x0, celsius                   // Cargar la dirección de la página de `celsius`
    add x0, x0, :lo12:celsius          // Ajustar el desplazamiento de la dirección completa
    ldr d0, [x0]                       // Cargar el valor de Celsius en el registro d0

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

    // Mostrar el mensaje "Fahrenheit: "
    mov x0, #1                         // Descriptor de archivo 1 (stdout)
    adrp x1, msg                       // Cargar la dirección de la página de `msg`
    add x1, x1, :lo12:msg              // Ajustar el desplazamiento de la dirección completa
    mov x2, #12                        // Longitud del mensaje
    mov x8, #64                        // Syscall de escritura
    svc 0

    // Inicializar el buffer para la conversión
    adrp x3, buffer                    // Cargar la dirección base de `buffer`
    add x3, x3, :lo12:buffer           // Cargar la dirección completa de `buffer`
    mov x4, #0                         // Contador de dígitos

    // Manejar caso especial si el número es 0
    cmp x2, #0
    bne convert_digits
    mov w5, '0'                        // Carácter '0'
    strb w5, [x3]                      // Almacenar en el buffer
    mov x4, #1                         // Longitud es 1
    b show_result

convert_digits:
    // Primero verificar si es negativo
    cmp x2, #0
    bge positive_number
    neg x2, x2                         // Hacer positivo para procesar
    mov w5, '-'                        // Carácter '-'
    strb w5, [x3], #1                  // Almacenar en el buffer y avanzar
    add x4, x4, #1                     // Incrementar contador

positive_number:
    // Guarda la posición inicial del buffer para los dígitos
    mov x7, x3

    // Convertir dígitos de derecha a izquierda
digit_loop:
    mov x5, #10
    udiv x6, x2, x5                    // x6 = x2 / 10
    msub x5, x6, x5, x2                // x5 = x2 % 10 (resto)
    add w5, w5, '0'                    // Convertir a ASCII
    strb w5, [x3], #1                  // Almacenar en el buffer y avanzar
    add x4, x4, #1                     // Incrementar contador
    mov x2, x6                         // Actualizar para siguiente iteración
    cbnz x2, digit_loop                // Continuar si aún hay dígitos

    // Ahora invertir los dígitos en el buffer (no incluye el signo si lo hay)
    sub x3, x3, #1                     // Apuntar al último dígito
    cmp x7, x3                         // Comprobar si necesitamos invertir
    bge show_result                    // Si solo hay un dígito, no invertir

reverse_loop:
    ldrb w5, [x7]                      // Cargar primer carácter
    ldrb w6, [x3]                      // Cargar último carácter
    strb w6, [x7], #1                  // Intercambiar caracteres
    strb w5, [x3], #-1                 // y avanzar/retroceder punteros
    cmp x7, x3                         // Comprobar si hemos terminado
    blt reverse_loop                   // Continuar si no hemos terminado

show_result:
    // Mostrar el número convertido
    mov x0, #1                         // stdout
    adrp x1, buffer                    // Dirección del buffer
    add x1, x1, :lo12:buffer           // Dirección completa
    mov x2, x4                         // Longitud calculada
    mov x8, #64                        // Syscall de escritura
    svc 0

    // Mostrar nueva línea
    mov x0, #1                         // stdout
    adrp x1, newline                   // Dirección de nueva línea
    add x1, x1, :lo12:newline          // Dirección completa
    mov x2, #1                         // Longitud de nueva línea
    mov x8, #64                        // Syscall de escritura
    svc 0

    // Salir del programa
    mov x8, #93                        // Número de syscall para salir en Linux
    mov x0, #0                         // Código de salida 0
    svc 0
