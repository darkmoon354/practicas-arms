#include <stdio.h>

extern void suma_matrices();
extern int resultado[3][3];

int main() {
    suma_matrices();

    printf("Resultado de la suma de matrices:\n");
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            printf("%d ", resultado[i][j]);
        }
        printf("\n");
    }

    return 0;
}
