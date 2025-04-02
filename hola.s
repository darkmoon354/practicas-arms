/*
 * ---------------------------------------------------------------------------------
 *  Lenguajes de Interfaz en TECNM Campus ITT
 *  Autor: [Villegas Suarez Francisco Javier]
 *  Fecha: [2025-04-02]
 *  Descripción: Esta plantilla proporciona una estructura profesional para el desarrollo
 *               embebido, incluyendo C# y Assembly ARM64 para RaspbianOS.
 *  Demostración:  [ ASCIINEMA.ORG/.....]
 * ---------------------------------------------------------------------------------
 */

/*
 * ----------------------------------------------
 * C# "Hola, Mundo!" para Desarrolladores Embebidos (Referencia)
 * ----------------------------------------------
 * using System;
 *
 * class Program {
 *     static void Main() {
 *         Console.WriteLine("Hola, Mundo!");
 *     }
 * }
 */

.global _start
.section .data
mensaje: .ascii "Hola, Mundo!\n"
len = . - mensaje

.section .text
_start:
    // Llamada al sistema para escribir (sys_write)
    mov x0, #1          // Descriptor de archivo para stdout
    ldr x1, =mensaje    // Puntero al mensaje
    mov x2, len         // Longitud del mensaje
    mov x8, #64         // Syscall: write
    svc #0              // Invocar syscall

    // Llamada al sistema para salir (sys_exit)
    mov x0, #0          // Estado 0
    mov x8, #93         // Syscall: exit
    svc #0              // Invocar syscall
