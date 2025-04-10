// ===============================================
// Estudiante y No de control: Villegas Suarez Francisco Javier  22210364.
// Descripción: Programa en ensamblador ARM64 para encontrar el mínimo en un arreglo
// ===============================================

.section .data
arreglo:    .word 5, 10, 3, 21, 7, 15, 6    // Ejemplo de arreglo de enteros de 32 bits
longitud:   .word 7                         // Longitud del arreglo
.global resultado
resultado:  .word 0                         // Variable para almacenar el mínimo
msg:        .asciz "El valor mínimo en el arreglo es: "
newline:    .asciz "\n"
buffer:     .space 20                       // Buffer para convertir número a texto

.section .text
.global _start

_start:
    // Llamar a la función para encontrar el mínimo
    bl encontrar_minimo

    // Imprimir mensaje
    mov x0, #1                      // stdout
    adrp x1, msg                    // Dirección del mensaje
    add x1, x1, :lo12:msg
    mov x2, #34                     // Longitud del mensaje
    mov x8, #64                     // syscall write
    svc #0

    // Obtener el resultado
    adrp x1, resultado
    add x1, x1, :lo12:resultado
    ldr w2, [x1]                    // Cargar el valor mínimo

    // Convertir número a string
    mov w0, w2                      // Valor a convertir
    adrp x3, buffer                 // Buffer para la conversión
    add x3, x3, :lo12:buffer
    add x3, x3, #19                 // Apuntar al final del buffer
    mov w5, #0                      // Carácter nulo para terminar string
    strb w5, [x3]                   // Añadir carácter nulo
    sub x3, x3, #1                  // Retroceder una posición

convert_loop:
    mov w4, #10
    udiv w5, w0, w4                 // w5 = w0 / 10
    msub w6, w5, w4, w0             // w6 = w0 % 10 (resto)
    add w6, w6, #'0'                // Convertir a ASCII
    strb w6, [x3], #-1              // Guardar y retroceder
    mov w0, w5                      // Actualizar para siguiente iteración
    cbnz w0, convert_loop           // Continuar si hay más dígitos

    // Calcular longitud del número
    add x3, x3, #1                  // Ajustar posición después del loop
    adrp x4, buffer                 // Dirección base del buffer
    add x4, x4, :lo12:buffer
    add x4, x4, #19                 // Final del buffer
    sub x2, x4, x3                  // Longitud = final - inicio

    // Imprimir el número
    mov x0, #1                      // stdout
    mov x1, x3                      // Posición de inicio
    mov x8, #64                     // syscall write
    svc #0

    // Imprimir nueva línea
    mov x0, #1                      // stdout
    adrp x1, newline                // Dirección de nueva línea
    add x1, x1, :lo12:newline
    mov x2, #1                      // Longitud
    mov x8, #64                     // syscall write
    svc #0

    // Terminar programa
    mov x8, #93                     // syscall exit
    mov x0, #0                      // Código de retorno
    svc #0

encontrar_minimo:
    // Guardar el enlace de retorno
    stp x29, x30, [sp, #-16]!       // Guardar frame pointer y link register
    mov x29, sp                      // Actualizar frame pointer

    // Cargar direcciones correctamente
    adrp x0, arreglo                 // Obtener página de dirección de arreglo
    add x0, x0, :lo12:arreglo        // Obtener dirección completa
    
    adrp x1, longitud                // Obtener página de dirección de longitud
    add x1, x1, :lo12:longitud       // Obtener dirección completa
    ldr w1, [x1]                     // Cargar la longitud del arreglo en w1
    
    ldr w2, [x0]                     // Inicializar w2 con el primer elemento (valor mínimo inicial)
    mov w3, #1                       // Índice para iterar por el arreglo

buscar_minimo:
    cmp w3, w1                       // Comprobar si llegamos al final del arreglo
    bge fin                          // Si el índice es >= longitud, termina el bucle
    
    // Calcular dirección: arreglo + índice * 4 (cada entero es de 4 bytes)
    lsl w4, w3, #2                   // w4 = índice * 4
    add x5, x0, x4                   // x5 = dirección de arreglo[índice]
    ldr w4, [x5]                     // Cargar el elemento actual en w4
    
    cmp w4, w2                       // Comparar el elemento actual con el mínimo actual
    bge siguiente                    // Si w4 >= w2, saltar a siguiente
    mov w2, w4                       // Actualizar w2 con el nuevo mínimo
    
siguiente:
    add w3, w3, #1                   // Incrementar el índice
    b buscar_minimo                  // Repetir el bucle
    
fin:
    adrp x5, resultado               // Obtener página de dirección de resultado
    add x5, x5, :lo12:resultado      // Obtener dirección completa
    str w2, [x5]                     // Guardar el valor mínimo en 'resultado'
    
    // Restaurar el stack y retornar
    ldp x29, x30, [sp], #16          // Restaurar frame pointer y link register
    ret                              // Retornar al llamador
