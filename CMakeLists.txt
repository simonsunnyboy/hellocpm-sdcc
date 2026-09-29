cmake_minimum_required(VERSION 3.20)

include("${CMAKE_CURRENT_LIST_DIR}/cpm.cmake")
project(hellocpm C ASM)

add_cpm_executable(hellocpm	
	main.c
	putchar.s
)
