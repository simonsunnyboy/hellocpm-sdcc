# This file is a CMake toolchain definition for building z80 programs for CP/M.
#
# CMake normally expects a host compiler for the current machine, but this project
# targets a different architecture entirely: a bare-metal z80 system running CP/M.
# To make that work, we tell CMake to use the SDCC C compiler and the sdasz80
# assembler, then force the generated output to match the CP/M conventions used by
# this project.

# Default load address for the generated code inside a CP/M executable.
# CP/M programs are normally loaded at 0x0100, so we keep this configurable in case
# the project needs a different start address later.
set(CPM_CODE_LOC "0x0100" CACHE STRING "CP/M load address for executable code")

# Guard against re-running the toolchain setup multiple times during the same
# CMake configure process. This is important because this file is included before
# project() and may be re-evaluated when CMake refreshes its state.
get_property(CPM_SETUP_COMPLETE GLOBAL PROPERTY CPM_SETUP_COMPLETE)
if(CPM_SETUP_COMPLETE)
	# When the toolchain is already configured, keep the output conventions stable.
	# z80 object files and assembly output are stored as .rel modules, which matches
	# the SDCC/sdasz80 toolchain style used by this project.
	set(CMAKE_C_OUTPUT_EXTENSION ".rel")
	set(CMAKE_ASM_OUTPUT_EXTENSION ".rel")
	# sdasz80 is invoked with the -los option so the assembler can include the
	# object library support that CP/M programs often rely on.
	set(CMAKE_ASM_COMPILE_OBJECT "<CMAKE_ASM_COMPILER> -los <OBJECT> <SOURCE>")
	return()
endif()
set_property(GLOBAL PROPERTY CPM_SETUP_COMPLETE TRUE)

# Tell CMake we are cross-compiling for a generic bare-metal target instead of the
# current Linux host. The "Generic" system name is a common way to say "this is a
# custom target platform, not a standard desktop/server OS".
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR z80)

# Locate the actual toolchain programs that will generate z80 code for CP/M.
# SDCC is the C compiler; sdasz80 is the assembler for the same architecture.
find_program(SDCC_EXECUTABLE sdcc REQUIRED)
set(CMAKE_C_COMPILER "${SDCC_EXECUTABLE}" CACHE FILEPATH "SDCC compiler" FORCE)
find_program(CMAKE_ASM_COMPILER sdasz80 REQUIRED)

# -mz80 tells SDCC to generate z80-specific code.
# --no-std-crt0 disables the default C runtime startup, because the project provides
# its own CRT startup assembly and wants to control the exact memory layout.
# --code-loc places the program entry point at the CP/M load address.
# --out-fmt-ihx emits Intel HEX output, which is a common format for flashing or
# converting CP/M programs into .COM files.
set(CMAKE_C_FLAGS_INIT "-mz80")
set(CMAKE_EXE_LINKER_FLAGS_INIT "--no-std-crt0 --code-loc ${CPM_CODE_LOC} --out-fmt-ihx")

# sdasz80 is not a GCC-compatible compiler, so CMake must be told its compiler id
# and that it is a real working assembler for this target.
set(CMAKE_ASM_COMPILER_ID SDAS)
set(CMAKE_ASM_COMPILER_FORCED TRUE)
set(CMAKE_ASM_COMPILER_WORKS TRUE)

# The final executable suffix is .ihx because the linker emits Intel HEX files,
# which is the actual artifact that is later transformed into a CP/M .COM file.
set(CMAKE_EXECUTABLE_SUFFIX ".ihx")

# Override the default CMake make rules so these custom z80/CP/M settings remain in
# effect across the configuration and build. This ensures the project continues to use
# the same cross-compilation rules throughout the build lifecycle.
set(CMAKE_USER_MAKE_RULES_OVERRIDE "${CMAKE_CURRENT_LIST_FILE}")