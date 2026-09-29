# "Hello World in C" for CP/M 2.2 using SDCC

Copyright (c) 2026 Matthias Arndt <marndt@final-memory.org>

The MIT License applies. See the LICENSE file for details.

## Abstract
This is a simple Hello World program cross-compiled with the Small Device C Compiler (SDCC) for Z80 targets running CP/M 2.2 or a compatible system.

It demonstrates the build and link process and serves as a practical example for further use.

## System requirements

- SDCC compiler version 4.5.12 or newer
- CMake 3.20 or newer
- SRecord 1.64 or newer (older versions may work too)
- A CP/M machine or compatible emulator to run the resulting .COM file

## Features

- Use of the SDCC C runtime library except for the startup code
- Dynamic linkage of the DATA segment to avoid fixed addresses
- Assembly-language mapping of the putchar() function to BDOS
- CP/M .COM file entry point at 0x100, configurable via CMake variables
- C runtime and startup code placing the stack below the BDOS
- Return to BDOS via warm start, e.g. "jp 0"
- Alignment of the resulting .COM file to 128 bytes, with remaining bytes filled with 0
- Future-proof CMake infrastructure to support different entry points or user startup code

## Links

- [Small Device C Compiler](https://sdcc.sourceforge.net/)
- [SRecord](https://srecord.sourceforge.net/)
- [jhallen-cpm: a CP/M virtual machine for Linux](https://github.com/jhallen/cpm)

