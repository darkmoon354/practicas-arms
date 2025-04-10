// ===============================================
// Estudiante y No de control: Villegas Suarez Francisco Jaiver.
// Descripción: Programa en ensamblador ARM64 para verificar si una cadena es palíndromo
// ===============================================

// ===============================================
// Solucion en C#
// ===============================================
/*
using System;

class Program
{
    static bool EsPalindromo(string cadena)
    {
        // Eliminar espacios y convertir todo a minúsculas para hacer la comparación insensible a mayúsculas y espacios
        string cadenaLimpia = cadena.Replace(" ", "").ToLower();

        // Invertir la cadena
        char[] array = cadenaLimpia.ToCharArray();
        Array.Reverse(array);
        string cadenaReversa = new string(array);

        // Comparar la cadena original con la invertida
        return cadenaLimpia == cadenaReversa;
    }

    static void Main()
    {
        Console.Write("Introduce una cadena: ");
        string entrada = Console.ReadLine();

        if (EsPalindromo(entrada))
        {
            Console.WriteLine("La cadena es un palíndromo.");
        }
        else
        {
            Console.WriteLine("La cadena no es un palíndromo.");
        }
    }
}
*/

// ===============================================
// Solucion en ARM64 Assembler
// ===============================================

.global _start

.data
prompt: .asciz "Introduce una palabra: "
msg_palindrome: .asciz "Es palindromo\n"
msg_not_palindrome: .asciz "No es palindromo\n"

.bss
input_buffer: .skip 100  // Reservamos espacio para la entrada

.text
_start:
    // Imprimir el mensaje de solicitud
    mov x0, #1                // Descriptor de archivo para stdout
    adrp x1, prompt           // Cargar la dirección de la página de prompt
    add x1, x1, :lo12:prompt  // Dirección completa del mensaje
    mov x2, #23               // Longitud del mensaje
    mov x8, #64               // syscall para escribir
    svc #0                    // Llamada al sistema

    // Leer la entrada del usuario
    mov x0, #0                // Descriptor de archivo para stdin
    adrp x1, input_buffer     // Cargar la dirección de la página del buffer
    add x1, x1, :lo12:input_buffer // Dirección completa del buffer
    mov x2, #100              // Número máximo de caracteres
    mov x8, #63               // syscall para leer
    svc #0                    // Llamada al sistema

    // Guardar longitud real leída
    mov x5, x0                // Guardar cantidad de bytes leídos en x5

    // Eliminar el salto de línea (\n) si lo hay
    sub x5, x5, #1            // Apuntar al último carácter (antes del null)
    adrp x3, input_buffer     // Dirección base del buffer
    add x3, x3, :lo12:input_buffer // Dirección completa
    add x3, x3, x5            // Apuntar al último carácter leído
    ldrb w4, [x3]             // Cargar último byte
    cmp w4, #10               // Comparar con '\n' (código 10)
    bne skip_newline          // Si no es salto de línea, saltar
    mov w4, #0                // Carácter nulo para reemplazar
    strb w4, [x3]             // Reemplazar \n con \0
    sub x5, x5, #1            // Decrementar longitud por el \n removido
skip_newline:

    // Verificar si la cadena es un palíndromo
    adrp x1, input_buffer     // Dirección base del buffer
    add x1, x1, :lo12:input_buffer // Dirección completa
    mov x2, x5                // x2 = longitud ajustada
    mov x3, #0                // x3 = índice inicial (0)
    mov x4, x5                // x4 = longitud
    sub x4, x4, #1            // x4 = longitud - 1 (índice final)

check_palindrome:
    cmp x3, x4                // Comparar índice inicial con final
    bge is_palindrome         // Si inicial >= final, es palíndromo
    
    ldrb w5, [x1, x3]         // Cargar el carácter desde el inicio
    ldrb w6, [x1, x4]         // Cargar el carácter desde el final
    cmp w5, w6                // Comparar los dos caracteres
    bne not_palindrome        // Si no son iguales, no es palíndromo

    // Mover los índices hacia el centro
    add x3, x3, #1            // Incrementar el índice inicial
    sub x4, x4, #1            // Decrementar el índice final
    b check_palindrome        // Continuar verificando

is_palindrome:
    // Es un palíndromo
    mov x0, #1                // Descriptor de archivo para stdout
    adrp x1, msg_palindrome   // Dirección base del mensaje
    add x1, x1, :lo12:msg_palindrome // Dirección completa
    mov x2, #15               // Longitud del mensaje
    mov x8, #64               // syscall para escribir
    svc #0                    // Llamada al sistema
    b end_program             // Salto al final del programa

not_palindrome:
    // No es un palíndromo
    mov x0, #1                // Descriptor de archivo para stdout
    adrp x1, msg_not_palindrome // Dirección base del mensaje
    add x1, x1, :lo12:msg_not_palindrome // Dirección completa
    mov x2, #18               // Longitud del mensaje
    mov x8, #64               // syscall para escribir
    svc #0                    // Llamada al sistema

end_program:
    // Terminar programa
    mov x8, #93               // syscall para salir
    mov x0, #0                // Código de salida
    svc #0                    // Llamada al sistema
