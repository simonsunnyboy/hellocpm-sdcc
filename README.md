# "Hello World in C" for CP/M 2.2 using SDCC

Copyright (c) 2026 Matthias Arndt <marndt@final-memory.org>

The MIT License applies. See file LICENSE for details


## Abstract
This is a simple Hello World program crosscompiled with the 
Small Devices C Compiler for Z80 targets running CP/M 2.2 or
compatible.

It demonstrates the build and link process to provide an example for
further use.

## System requirements

- SDCC compiler V4.5.12 or newer
- CMake 3.20 or newer
- SRecord 1.64 or newer (older versions may work too)
- a CP/M machine to run the resulting .COM file.

## Features

- Usage of SDCC C runtime library except for the startup code
- Dynamic linkage of DATA segment to avoid fixed addresses
- Assembly language mapping of putchar() function to BDOS
- CP/M .COM file entry point at 0x100
- C runtime and startup code placing the stack below the BDOS
- Return to BDOS via warmstart, e.g. "jp 0"
- Alignment of resulting .COM file to 128 bytes and multiples filled with 0


## Links

- [Small Device C Compiler](https://sdcc.sourceforge.net/)
- [SRecord](https://srecord.sourceforge.net/)
- [jhallen-cpm: a CP/M virtual machine for Linux](https://github.com/jhallen/cpm)

