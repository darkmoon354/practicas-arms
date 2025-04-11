// ===============================================
// Estudiante y No de control: Villegas SUarez Francisco Javier--22210364
// Descripción: Programa en ensamblador ARM64 Contar los bits activados en un número
// ===============================================

// ===============================================
// Solucion en C#
// ===============================================

/*
using System;

class Program
{
    static void Main()
    {
        Console.Write("Ingresa un número entero: ");
        ulong numero = ulong.Parse(Console.ReadLine());

        int contadorBits = ContarBitsActivados(numero);
        Console.WriteLine("Número de bits activados: " + contadorBits);
    }

    static int ContarBitsActivados(ulong numero)
    {
        int contador = 0;

        while (numero != 0)
        {
            numero &= (numero - 1); // Eliminar el bit más bajo activado
            contador++;              // Incrementar el contador de bits activados
        }

        return contador;
    }
}

*/

// ===============================================
// Solucion en ARM54 Assembler
// ===============================================
.global _start            // Make _start globally visible
.global count_set_bits   // Ensure count_set_bits is also globally visible

.type _start, %function

_start:
    mov     x0, #29       // Load the number whose bits we want to count (e.g., 29)
    bl      count_set_bits // Call the count_set_bits function

    // Exit the program (using an exit syscall)
    mov     x8, #93       // Exit syscall number (93 for exit in Linux ARM64)
    mov     x0, #0        // Exit status 0
    svc     #0            // Make syscall to exit the program

count_set_bits:
    mov     x1, x0        // Copy the number to x1
    mov     x0, #0        // Initialize the counter of set bits to 0

count_loop:
    cmp     x1, #0        // Check if the number is 0
    beq     end           // If it is 0, we are done

    // Remove the lowest set bit (x1 = x1 & (x1 - 1))
    subs    x1, x1, #1    // x1 = x1 - 1
    and     x1, x1, x0    // x1 = x1 & x0

    // Increment the counter of set bits
    add     x0, x0, #1    // Increment the counter of set bits

    b       count_loop    // Repeat the loop

end:
    ret
