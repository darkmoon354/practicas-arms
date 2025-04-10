// ===============================================
// Estudiante y No de control: villegas suarez francisco javier - 22210364
// Descripción: Programa en ensamblador ARM64 de Busqueda Lineal
// ===============================================

// ===============================================
// Solucion en C#
// ===============================================
// Comentada, ya que estamos trabajando en ensamblador

/*
using System;

class Program
{
    // Función para realizar la búsqueda lineal
    static int BusquedaLineal(int[] arreglo, int valorBuscado)
    {
        // Recorremos cada elemento del arreglo
        for (int i = 0; i < arreglo.Length; i++)
        {
            if (arreglo[i] == valorBuscado)
            {
                return i; // Retorna el índice donde se encontró el valor
            }
        }

        // Si no encontramos el valor, retornamos -1
        return -1;
    }

    static void Main()
    {
        // Definir un arreglo de enteros
        int[] arreglo = { 3, 5, 7, 2, 8, 6, 4 };

        // Solicitar al usuario el valor que desea buscar
        Console.Write("Introduce el valor que deseas buscar: ");
        int valor = int.Parse(Console.ReadLine());

        // Llamar a la función de búsqueda lineal
        int indice = BusquedaLineal(arreglo, valor);

        // Mostrar el resultado
        if (indice != -1)
        {
            Console.WriteLine($"El valor {valor} se encuentra en el índice: {indice}");
        }
        else
        {
            Console.WriteLine($"El valor {valor} no se encuentra en el arreglo.");
        }
    }
}
*/

// ===============================================
// Solucion en ARM64 Assembler
// ===============================================

.section .data
array:      .word 12, 3, 5, 7, 1, 9, 2     // Arreglo de ejemplo
array_size: .word 7                        // Tamaño del arreglo (número de elementos)
target:     .word 5                        // Valor a buscar en el arreglo
msg_found:  .asciz "El valor se encuentra en el índice: "
newline:    .asciz "\n"
buffer:     .space 20                       // Buffer para convertir número a texto

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

    mov w6, #0                            // Inicializa el índice a 0 (64 bits ahora)

    // Bucle de búsqueda lineal
search_loop:
    cmp w6, w2                            // Verifica si el índice ha alcanzado el tamaño del arreglo (usando w6)
    beq not_found                         // Si hemos llegado al final, el valor no se encontró

    ldr w7, [x3, x6, lsl #2]              // Carga el elemento actual del arreglo en w7 usando 64 bits en el desplazamiento
    cmp w7, w5                            // Compara el elemento actual con el valor de búsqueda
    beq found                             // Si son iguales, salta a la etiqueta found

    add w6, w6, #1                        // Incrementa el índice (64 bits)
    b search_loop                         // Repite el bucle

not_found:
    mov w0, #-1                           // Si no se encuentra el valor, retorna -1
    mov x8, #93                           // Código de salida para ARM Linux
    svc #0                                 // Llama al sistema para salir

found:
    // Imprimir "El valor se encuentra en el índice: "
    mov x0, #1                            // stdout
    adrp x1, msg_found                    // Dirección del mensaje
    add x1, x1, :lo12:msg_found
    mov x2, #35                           // Longitud del mensaje
    mov x8, #64                           // syscall write
    svc #0                                 // Llamada al sistema

    // Convertir el índice a cadena
    mov w0, w6                            // Valor a convertir (en w6)
    adrp x3, buffer                       // Buffer para la conversión
    add x3, x3, :lo12:buffer
    add x3, x3, #19                       // Apuntar al final del buffer
    mov w5, #0                            // Carácter nulo para terminar string
    strb w5, [x3]                         // Añadir carácter nulo
    sub x3, x3, #1                        // Retroceder una posición

convert_loop:
    mov w4, #10
    udiv w5, w0, w4                       // x5 = w0 / 10
    msub w6, w5, w4, w0                   // x6 = w0 % 10 (resto)
    add w6, w6, #'0'                      // Convertir a ASCII
    strb w6, [x3], #-1                    // Guardar y retroceder
    mov w0, w5                            // Actualizar para siguiente iteración
    cbnz w0, convert_loop                 // Continuar si hay más dígitos

    // Calcular longitud del número
    add x3, x3, #1                        // Ajustar posición después del loop
    adrp x4, buffer                       // Dirección base del buffer
    add x4, x4, :lo12:buffer
    add x4, x4, #19                       // Final del buffer
    sub x2, x4, x3                        // Longitud = final - inicio

    // Imprimir el número
    mov x0, #1                            // stdout
    mov x1, x3                            // Posición de inicio
    mov x8, #64                           // syscall write
    svc #0                                 // Llamada al sistema

    // Imprimir nueva línea
    mov x0, #1                            // stdout
    adrp x1, newline                      // Dirección de nueva línea
    add x1, x1, :lo12:newline
    mov x2, #1                            // Longitud
    mov x8, #64                           // syscall write
    svc #0                                 // Llamada al sistema

    // Terminar el programa
    mov x8, #93                           // syscall exit
    mov x0, #0                            // Código de salida
    svc #0                                 // Llamada al sistema
