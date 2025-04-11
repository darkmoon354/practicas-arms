//==============================================================
// Nombre del archivo: nombre.s
// Autor: [villegas suarez Francisco Javier]
// Descripción: Captura un nombre desde la entrada estándar y lo muestra.
// Ensamblar: as -o nombre.o nombre.s
// Enlazar: ld -o nombre nombre.o
// Ejecutar: ./nombre
//==============================================================

.section .data
msg:    .asciz "Introduce tu nombre: "
len_msg = . - msg

.section .bss
    .lcomm buffer, 100  // Espacio para almacenar el nombre

.section .text
.global _start

_start:
    // Mostrar mensaje de entrada
    mov x0, #1          // File descriptor 1 (stdout)
    ldr x1, =msg        // Dirección del mensaje
    mov x2, len_msg     // Longitud del mensaje
    mov x8, #64         // syscall: sys_write
    svc #0              // Llamada al sistema

    // Leer el nombre del usuario
    mov x0, #0          // File descriptor 0 (stdin)
    ldr x1, =buffer     // Dirección del búfer
    mov x2, #100        // Longitud máxima
    mov x8, #63         // syscall: sys_read
    svc #0              // Llamada al sistema

    // Mostrar el nombre ingresado
    mov x0, #1          // File descriptor 1 (stdout)
    ldr x1, =buffer     // Dirección del búfer con el nombre
    mov x2, #100        // Longitud máxima
    mov x8, #64         // syscall: sys_write
    svc #0              // Llamada al sistema

    // Salida del programa
    mov x8, #93         // syscall: exit
    mov x0, #0          // Código de salida
    svc #0              // Llamada al sistema
