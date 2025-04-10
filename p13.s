.data
    .global matrizA, matrizB, resultado

matrizA:
    .word 1, 2, 3
    .word 4, 5, 6
    .word 7, 8, 9

matrizB:
    .word 9, 8, 7
    .word 6, 5, 4
    .word 3, 2, 1

resultado:
    .space 36    // 9 enteros * 4 bytes

.text
    .global suma_matrices

suma_matrices:
    ldr x0, =matrizA       // x0 = &matrizA
    ldr x1, =matrizB       // x1 = &matrizB
    ldr x2, =resultado     // x2 = &resultado

    mov w3, #0             // i = 0

fila_loop:
    mov w4, #0             // j = 0

columna_loop:
    mov x5, x3
    lsl x6, x5, #1
    add x5, x6, x5         // x5 = i * 3
    add x5, x5, x4         // x5 = i * 3 + j

    ldr w6, [x0, x5, LSL #2]   // w6 = A[i][j]
    ldr w7, [x1, x5, LSL #2]   // w7 = B[i][j]
    add w8, w6, w7             // w8 = A[i][j] + B[i][j]
    str w8, [x2, x5, LSL #2]   // resultado[i][j] = w8

    add w4, w4, #1
    cmp w4, #3
    blt columna_loop

    add w3, w3, #1
    cmp w3, #3
    blt fila_loop

    ret
