// ===============================================
// Estudiante y No de control: Villegas Suarez Francisco Javier --22210364
// Descripción: Programa en ensamblador ARM64 para Contar vocales y consonantes
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
        Console.Write("Ingresa una cadena de texto: ");
        string cadena = Console.ReadLine();

        int vocales = 0, consonantes = 0;

        ContarVocalesYConsonantes(cadena, out vocales, out consonantes);

        Console.WriteLine("Número de vocales: " + vocales);
        Console.WriteLine("Número de consonantes: " + consonantes);
    }

    static void ContarVocalesYConsonantes(string cadena, out int vocales, out int consonantes)
    {
        vocales = 0;
        consonantes = 0;
        
        cadena = cadena.ToLower(); // Convertir a minúsculas para simplificar

        foreach (char c in cadena)
        {
            if (char.IsLetter(c)) // Verificar si el carácter es una letra
            {
                // Verificar si el carácter es una vocal
                if ("aeiou".Contains(c))
                {
                    vocales++;
                }
                else
                {
                    consonantes++;
                }
            }
        }
    }
}

*/

// ===============================================
// Solucion en ARM54 Assembler
// ===============================================

.data
    cadena:         .string "aad"   // Cadena de ejemplo
    msg_vocales:    .string "Número de vocales: %d\n" // Mensaje para imprimir vocales
    msg_consonantes:.string "Número de consonantes: %d\n" // Mensaje para imprimir consonantes

.text
.global main
.align 2

main:
    // Prologo de la función main
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Cargar la dirección de la cadena
    adrp    x0, cadena
    add     x0, x0, :lo12:cadena

    // Llamar a la función que cuenta vocales y consonantes
    bl      contar_vocales_consonantes

    // Imprimir el número de vocales
    mov     x1, x2                       // Pasar el número de vocales a x1 para printf
    adrp    x0, msg_vocales
    add     x0, x0, :lo12:msg_vocales    // Primer parámetro (mensaje) para printf
    bl      printf

    // Imprimir el número de consonantes
    mov     x1, x3                       // Pasar el número de consonantes a x1 para printf
    adrp    x0, msg_consonantes
    add     x0, x0, :lo12:msg_consonantes // Primer parámetro (mensaje) para printf
    bl      printf

    // Epílogo de la función main
    ldp     x29, x30, [sp], #16
    mov     x0, #0
    ret

// Función contar_vocales_consonantes
// Entrada: x0 = dirección de la cadena
// Salida: x2 = número de vocales, x3 = número de consonantes
contar_vocales_consonantes:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    mov     x2, #0      // Inicializar contador de vocales en x2
    mov     x3, #0      // Inicializar contador de consonantes en x3

loop:
    ldrb    w1, [x0], #1         // Leer un byte de la cadena y avanzar el puntero
    cbz     w1, fin              // Si es NULL (fin de cadena), salir

    // Convertir a minúscula si es mayúscula
    cmp     w1, 'A'
    b.lt    no_conversion
    cmp     w1, 'Z'
    b.gt    no_conversion
    add     w1, w1, #'a' - 'A'   // Convertir a minúscula: 'A'-'Z' -> 'a'-'z'

no_conversion:
    // Comparar si el carácter es una vocal
    cmp     w1, 'a'
    b.eq    es_vocal
    cmp     w1, 'e'
    b.eq    es_vocal
    cmp     w1, 'i'
    b.eq    es_vocal
    cmp     w1, 'o'
    b.eq    es_vocal
    cmp     w1, 'u'
    b.eq    es_vocal

    // No es vocal, verificar si es consonante
    cmp     w1, 'a'
    b.lt    loop       // Si es menor que 'a', no es letra
    cmp     w1, 'z'
    b.gt    loop       // Si es mayor que 'z', no es letra

    // Es consonante
    add     x3, x3, #1 // Incrementar contador de consonantes
    b       loop

es_vocal:
    add     x2, x2, #1 // Incrementar contador de vocales
    b       loop

fin:
    ldp     x29, x30, [sp], #16
    ret

