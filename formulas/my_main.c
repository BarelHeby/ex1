#include "formulas.h"
#include <stdio.h>
#include <stdlib.h>
int main(void)
{
    const int size = 4; // Example size, must be a multiple of 4 for SSE
    float a[4] = {1.0, 2.0, 3.0, 4.3};
    float b[4] = {5.0, 6.0, 7.0, 8.0};

    printf("%f\n", formula2(a, b, size));
    return 0;
}