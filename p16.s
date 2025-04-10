// ===============================================
// Estudiante y No de control: Villegas Suarez Francisco Javier ---22210364
// Descripción: Programa en ensamblador ARM64 para Transposición de una matriz
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
        // Matriz original
        int[,] matriz = {
            { 1, 2, 3 },
            { 4, 5, 6 },
            { 7, 8, 9 }
        };

        Console.WriteLine("Matriz Original:");
        ImprimirMatriz(matriz);

        // Transponer la matriz
        int[,] transpuesta = TransponerMatriz(matriz);

        Console.WriteLine("\nMatriz Transpuesta:");
        ImprimirMatriz(transpuesta);
    }

    static int[,] TransponerMatriz(int[,] matriz)
    {
        int filas = matriz.GetLength(0);
        int columnas = matriz.GetLength(1);

        // Crear una nueva matriz transpuesta con las dimensiones invertidas
        int[,] transpuesta = new int[columnas, filas];

        for (int i = 0; i < filas; i++)
        {
            for (int j = 0; j < columnas; j++)
            {
                // Intercambiar filas y columnas
                transpuesta[j, i] = matriz[i, j];
            }
        }

        return transpuesta;
    }

    static void ImprimirMatriz(int[,] matriz)
    {
        int filas = matriz.GetLength(0);
        int columnas = matriz.GetLength(1);

        for (int i = 0; i < filas; i++)
        {
            for (int j = 0; j < columnas; j++)
            {
                Console.Write(matriz[i, j] + "\t");
            }
            Console.WriteLine();
        }
    }
}
*/

// ===============================================
// Solucion en ARM54 Assembler
// ===============================================
.data
    // Matriz original 3x3
    matrix:      .quad   1, 2, 3
                 .quad   4, 5, 6
                 .quad   7, 8, 9

    // Matriz transpuesta 3x3
    transposed:  .zero   72            // 9 elementos * 8 bytes

    // Mensajes para imprimir
    msgOriginal: .string "Matriz Original:\n"
    msgTransposed: .string "Matriz Transpuesta:\n"
    format:      .string "%ld "         // Formato para imprimir números de 64 bits
    newline:     .string "\n"

.text
.global main
.align 2

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Imprimir mensaje para matriz original
    adrp    x0, msgOriginal
    add     x0, x0, :lo12:msgOriginal
    bl      printf

    // Imprimir matriz original
    adrp    x0, matrix
    add     x0, x0, :lo12:matrix
    bl      print_matrix

    // Realizar transposición
    adrp    x0, matrix
    add     x0, x0, :lo12:matrix
    adrp    x1, transposed
    add     x1, x1, :lo12:transposed
    bl      matrix_transpose

    // Imprimir mensaje para matriz transpuesta
    adrp    x0, msgTransposed
    add     x0, x0, :lo12:msgTransposed
    bl      printf

    // Imprimir matriz transpuesta
    adrp    x0, transposed
    add     x0, x0, :lo12:transposed
    bl      print_matrix

    ldp     x29, x30, [sp], #16
    mov     x0, #0
    ret

// Función para transponer matriz
matrix_transpose:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    mov     x3, #0                    // i = 0 (fila)

outer_loop:
    cmp     x3, #3                    // Comparar i con tamaño
    b.ge    end_outer
    mov     x4, #0                    // j = 0 (columna)

inner_loop:
    cmp     x4, #3                    // Comparar j con tamaño
    b.ge    end_inner

    // Calcular índice de la matriz original
    mov     x5, x3                    // i
    lsl     x5, x5, #4                // i * 16 (i * 8 * 2)
    add     x5, x5, x4, lsl #3        // + j * 8
    ldr     x6, [x0, x5]              // Cargar elemento A[i][j]

    // Calcular índice de la matriz transpuesta
    mov     x5, x4                    // j
    lsl     x5, x5, #4                // j * 16
    add     x5, x5, x3, lsl #3        // + i * 8
    str     x6, [x1, x5]              // Guardar en T[j][i]

    add     x4, x4, #1                // j++
    b       inner_loop

end_inner:
    add     x3, x3, #1                // i++
    b       outer_loop

end_outer:
    ldp     x29, x30, [sp], #16
    ret

// Función para imprimir matriz
print_matrix:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    mov     x19, x0                    // Guardar dirección de la matriz

    mov     x20, #0                    // i = 0
print_outer:
    cmp     x20, #3
    b.ge    print_end
    mov     x21, #0                    // j = 0

print_inner:
    cmp     x21, #3
    b.ge    print_inner_end

    // Calcular índice y cargar valor
    mov     x22, x20                   // i
    lsl     x22, x22, #4               // i * 16
    add     x22, x22, x21, lsl #3      // + j * 8
    ldr     x1, [x19, x22]             // Cargar elemento

    // Imprimir valor
    adrp    x0, format
    add     x0, x0, :lo12:format
    bl      printf

    add     x21, x21, #1              // j++
    b       print_inner

print_inner_end:
    // Imprimir nueva línea
    adrp    x0, newline
    add     x0, x0, :lo12:newline
    bl      printf

    add     x20, x20, #1              // i++
    b       print_outer

print_end:
    ldp     x29, x30, [sp], #16
    ret

