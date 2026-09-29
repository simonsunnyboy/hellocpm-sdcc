cmake_minimum_required(VERSION 3.20)

include("${CMAKE_CURRENT_LIST_DIR}/cpm.cmake")
project(hellocpm C ASM)

find_program(SREC_CAT_EXECUTABLE srec_cat REQUIRED)

file(GLOB C_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/*.c")
file(GLOB ASM_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/*.s")

list(REMOVE_ITEM ASM_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/cpm-crt0.s")
add_executable(hellocpm "${CMAKE_CURRENT_SOURCE_DIR}/cpm-crt0.s" ${C_SOURCES} ${ASM_SOURCES})
set_target_properties(hellocpm PROPERTIES SUFFIX ".ihx")

set(COM_FILE "${CMAKE_CURRENT_BINARY_DIR}/hellocpm.com")
add_custom_command(
	OUTPUT "${COM_FILE}"
	COMMAND "${SREC_CAT_EXECUTABLE}" "$<TARGET_FILE:hellocpm>" -Intel -offset -0x100 -o "${COM_FILE}" -binary
	DEPENDS hellocpm
	VERBATIM
)
add_custom_target(hellocpm_com ALL DEPENDS "${COM_FILE}")
