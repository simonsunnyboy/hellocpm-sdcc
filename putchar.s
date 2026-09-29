    ;--------------------------------------------------------------------------
    ; putchar.s - CP/M 2.x implementation of the libc putchar function using BDOS calls
    ;
    ; Uses SDCC calling convetion sdcccall(1)
    ;
    ; Copyright (c) 2026 Matthias Arndt <marndt@final-memory.org>
    ; The MIT License (MIT) applies. See file LICENSE for details.
    ;--------------------------------------------------------------------------

    .module putchar
    .area _CODE

    ; Export the symbol for the C linker
    .globl _putchar

_putchar:
    ;--- Argument handling (__sdcccall(1)) ---
    ; The passed 'char c' is already in register A.
    ld   e, a        ; BDOS expects the character in register E

    ;--- Build the CP/M BDOS call ---
    ld   c, #2       ; BDOS function 2: console output
    call #5          ; CP/M standard entry point for BDOS calls
                     ; (normally destroys AF, BC, DE, HL)

    ;--- Prepare the return value ---
    ; A conforming C 'putchar' returns the written character as an 'int'.
    ; An 'int' (16-bit) is returned in register DE under __sdcccall(1).
    ; We restore the original character, which is still in E.
    ld   d, #0       ; clear the high byte of the int (character is positive)

    ret              ; done, return to the C code
