#
# Hello CP/M in C using SDCC and CMake 
#
# Copyright (c) 2026 Matthias Arndt <marndt@final-memory.org>
# The MIT License (MIT) applies. See file LICENSE for details.
#
cmake_minimum_required(VERSION 3.20)

# reference cross-compilation environment
include("${CMAKE_CURRENT_LIST_DIR}/cpm.cmake")

# project name
project(hellocpm C ASM)

# executable definition
add_cpm_executable(hellocpm	
	main.c
	putchar.s
)
