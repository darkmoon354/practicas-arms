//==============================================================
// Nombre del archivo: color.s
// Autor: [Villegas Suárez Francisco Javier]
// Descripción: Captura tu color favorito desde la entrada estándar y lo muestra.
// Ensamblar: as -o color.o color.s
// Enlazar: ld -o color color.o
// Ejecutar: ./color
//==============================================================

.section .data
msg:    .asciz "¿Cuál es tu color favorito?: "
len_msg = . - msg

.section .bss
    .lcomm buffer, 100  // Espacio para almacenar el color

.section .text
.global _start

_start:
    // Mostrar mensaje de entrada
    mov x0, #1          // File descriptor 1 (stdout)
    ldr x1, =msg        // Dirección del mensaje
    mov x2, len_msg     // Longitud del mensaje
    mov x8, #64         // syscall: sys_write
    svc #0              // Llamada al sistema

    // Leer el color del usuario
    mov x0, #0          // File descriptor 0 (stdin)
    ldr x1, =buffer     // Dirección del búfer
    mov x2, #100        // Longitud máxima
    mov x8, #63         // syscall: sys_read
    svc #0              // Llamada al sistema

    // Mostrar el color ingresado
    mov x0, #1          // File descriptor 1 (stdout)
    ldr x1, =buffer     // Dirección del búfer con el color
    mov x2, #100        // Longitud máxima
    mov x8, #64         // syscall: sys_write
    svc #0              // Llamada al sistema

    // Salida del programa
    mov x8, #93         // syscall: exit
    mov x0, #0          // Código de salida
    svc #0              // Llamada al sistema
