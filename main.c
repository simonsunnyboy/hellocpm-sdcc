/**
 * Hello CP/M in C using SDCC and CMake
 * 
 * @file main.c
 * @brief Simple Hello World example for CP/M using SDCC and CMake.
 * @details Proves linking of C and assembly code in a CP/M executable. 
 *          The program prints a greeting to the BDOS console.
 *          Function putchar() is assumed to invoke the CP/M BDOS.
 * 
 * @copyright
 * Copyright (c) 2026 Matthias Arndt <marndt@final-memory.org>
 * The MIT License (MIT) applies. See file LICENSE for details.
 */

#include <stdio.h>

void main(void)
{
    puts("Hello CP/M with SDCC!\r\n");
}
