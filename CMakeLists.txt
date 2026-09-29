cmake_minimum_required(VERSION 3.20)

include("${CMAKE_CURRENT_LIST_DIR}/cpm.cmake")
project(hellocpm C ASM)

find_program(SREC_CAT_EXECUTABLE srec_cat REQUIRED)

add_executable(hellocpm 
	${CMAKE_CURRENT_SOURCE_DIR}/cpm-crt0.s # The startup code must come first
	main.c
	putchar.s
)
set_target_properties(hellocpm PROPERTIES SUFFIX ".ihx")
target_link_options(hellocpm PRIVATE
	"-Wl-b _DATA = s__CODE + l__CODE + l__HOME + l__INITIALIZER + l__GSINIT + l__GSFINAL"
)

set(COM_FILE "${CMAKE_CURRENT_BINARY_DIR}/hellocpm.com")
add_custom_command(
	OUTPUT "${COM_FILE}"
	COMMAND "${SREC_CAT_EXECUTABLE}" "$<TARGET_FILE:hellocpm>" -Intel -offset -${CPM_CODE_LOC} -o "${COM_FILE}" -binary
	DEPENDS hellocpm
	VERBATIM
)
add_custom_target(hellocpm_com ALL DEPENDS "${COM_FILE}")
