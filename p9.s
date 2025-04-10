// ===============================================
// Estudiante y No de control: Villegas Suarez Francisco Javier --22210364
// Descripción: Programa en ensamblador ARM64 de Búsqueda binaria
// ===============================================

// ===============================================
// Solucion en ARM64 Assembler
// ===============================================

.section .data
array:      .word 1, 3, 5, 7, 9, 11, 13, 15, 17, 19  // Arreglo ordenado
array_size: .word 10                             // Tamaño del arreglo
target:     .word 7                              // Valor a buscar

msg_not_found:  .asciz "Valor no encontrado\n"   // Mensaje de "No encontrado"
msg_found:      .asciz "Valor encontrado\n"      // Mensaje de "Encontrado"

.section .text
.global _start

_start:
    // Cargar el tamaño del arreglo y la dirección del primer elemento
    adrp x1, array_size                   // Carga la página base de array_size en x1
    add x1, x1, :lo12:array_size          // Completa la dirección con el offset bajo de array_size
    ldr w2, [x1]                          // Carga el tamaño del arreglo en w2

    adrp x3, array                        // Carga la página base de array en x3
    add x3, x3, :lo12:array               // Completa la dirección con el offset bajo de array
    adrp x4, target                       // Carga la página base de target en x4
    add x4, x4, :lo12:target              // Completa la dirección con el offset bajo de target
    ldr w5, [x4]                          // Carga el valor a buscar en w5

    mov w6, #0                            // Inicializa el índice de inicio (low)
    mov w7, w2                            // Inicializa el índice final (high) al tamaño del arreglo

binary_search_loop:
    cmp w6, w7                            // Verifica si low <= high
    bgt not_found                         // Si no, el valor no se encuentra

    add w8, w6, w7                        // w8 = low + high
    lsr w8, w8, #1                        // w8 = (low + high) / 2 (dividir entre 2)

    // Cargar el valor de array[mid] (usando un registro de 64 bits)
    ldr w9, [x3, x8, lsl #2]              // Cargar el valor en la mitad del arreglo (array[mid])
    cmp w9, w5                            // Compara el valor encontrado con el valor objetivo
    beq found                             // Si son iguales, hemos encontrado el valor

    blt search_right                      // Si el valor es menor que el objetivo, buscar en la mitad derecha
    b search_left                         // Si el valor es mayor, buscar en la mitad izquierda

search_left:
    sub w7, w8, #1                        // high = mid - 1
    b binary_search_loop                  // Repetir la búsqueda

search_right:
    add w6, w8, #1                        // low = mid + 1
    b binary_search_loop                  // Repetir la búsqueda

not_found:
    // Imprimir mensaje "Valor no encontrado"
    mov x0, #1                           // Descriptor de archivo para salida estándar (stdout)
    adrp x1, msg_not_found                // Dirección del mensaje "No encontrado"
    add x1, x1, :lo12:msg_not_found
    mov x2, #22                           // Longitud del mensaje
    mov x8, #64                           // syscall number para 'write'
    svc #0                                // Llamada al sistema para escribir
    b exit_program                        // Salir del programa

found:
    // Imprimir mensaje "Valor encontrado"
    mov x0, #1                           // Descriptor de archivo para salida estándar (stdout)
    adrp x1, msg_found                    // Dirección del mensaje "Encontrado"
    add x1, x1, :lo12:msg_found
    mov x2, #21                           // Longitud del mensaje
    mov x8, #64                           // syscall number para 'write'
    svc #0                                // Llamada al sistema para escribir
    b exit_program                        // Salir del programa

exit_program:
    // Finalizar el programa
    mov x8, #93                           // Número de salida para ARM Linux
    svc #0                                // Llamada al sistema para salir
