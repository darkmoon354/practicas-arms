	// ===============================================
// Estudiante y No de control: Villegas Suarez Francsico Javier---- 22210364.
// Descripción: Programa en ensamblador ARM64 para Conversión de entero a ascii
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
        int numero = int.Parse(Console.ReadLine());

        // Convertir el número entero a una cadena ASCII
        string cadenaASCII = EnteroAAscii(numero);
        
        Console.WriteLine("El número convertido a ASCII es: " + cadenaASCII);
    }

    static string EnteroAAscii(int numero)
    {
        // Si el número es 0, devolvemos directamente "0"
        if (numero == 0)
            return "0";

        // Almacenamos el resultado de la conversión
        string resultado = "";

        // Variable para gestionar el signo de los números negativos
        bool esNegativo = false;

        // Si el número es negativo, guardamos el signo y convertimos a positivo
        if (numero < 0)
        {
            esNegativo = true;
            numero = -numero;  // Hacemos el número positivo para procesarlo
        }

        // Convertir el número a cadena extrayendo cada dígito
        while (numero > 0)
        {
            int digito = numero % 10;               // Obtener el último dígito
            char digitoChar = (char)(digito + '0'); // Convertir a carácter ASCII
            resultado = digitoChar + resultado;     // Agregar el carácter al inicio de la cadena
            numero /= 10;                           // Eliminar el último dígito
        }

        // Agregar el signo negativo si es necesario
        if (esNegativo)
            resultado = "-" + resultado;

        return resultado;
    }
}

*/

// ===============================================
// Solucion en ARM54 Assembler
// ===============================================
.global _start

.section .data
msg:    .asciz "El valor ASCII es: "
char:   .byte 65               // El valor ASCII de 'A'

.section .text
_start:
    // Escribir el mensaje en stdout
    mov x0, #1                  // Número de archivo: 1 = stdout
    ldr x1, =msg                // Dirección del mensaje
    ldr x2, =19                  // Longitud del mensaje
    mov x8, #64                 // Número de syscall para 'write'
    svc #0                       // Hacer la llamada al sistema

    // Escribir el valor ASCII (carácter 'A') desde la sección de datos
    mov x0, #1                  // Número de archivo: 1 = stdout
    ldr x1, =char               // Dirección del valor ASCII (carácter 'A')
    mov x2, #1                  // Longitud (1 byte)
    mov x8, #64                 // Número de syscall para 'write'
    svc #0                       // Hacer la llamada al sistema

    // Finalizar el programa
    mov x0, #0                  // Código de salida
    mov x8, #93                 // Número de syscall para 'exit'
    svc #0                       // Hacer la llamada al sistema
