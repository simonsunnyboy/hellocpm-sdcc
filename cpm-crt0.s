	;--------------------------------------------------------------------------
	; cpm_crt0.s - Updated sdcc crt0.s for a Z80 for use with CP/M 2.x and up
    ; 
    ; The stack is located right in front of the BDOS overlapping the CCP.
	; Return to CP/M is via a CP/M warmboot by jump to 0.
	; There is no argument parsing involved.
    ;
    ; Copyright (c) 2026 Matthias Arndt <marndt@final-memory.org>
    ; The MIT License (MIT) applies. See file LICENSE for details.
	;--------------------------------------------------------------------------

	.module crt0
	.optsdcc -mz80 sdcccall(1)
	.globl	_main
	.globl  ___sdcc_external_startup
	.globl  l__DATA
	.globl  s__DATA
	.globl  s__CODE
	.globl  l__CODE
	.globl  l__HOME
	.globl  l__GSINIT
	.globl  l__GSFINAL
	.globl  l__INITIALIZER
	.globl  s__INITIALIZER
	.globl  s__INITIALIZED

	.area	_CODE
	; vectors are not handled by a CP/M .COM file

init:
	;; Set stack pointer directly above top of BDOS
	ld   hl,(0x0006)  ; Load BDOS entry address into HL (L = low byte, H = high byte)
    ld   l,#0x00      ; Set low byte to 00h (now HL = [0007h]:00h)
    ld   sp,hl        ; Initialize Stack Pointer below BDOS

	call	___sdcc_external_startup

	;; Initialise global variables. Skip if __sdcc_external_startup returned
	;; non-zero value. Note: calling convention version 1 only.
	or	a, a
	call	Z, gsinit

	;; run main() without function arguments
	call	_main

	;; perform CP/M warmstart on exit
	jp	    0x0

	;; Ordering of segments for the linker.
	.area	_HOME
	.area	_CODE
	.area	_INITIALIZER
	.area   _GSINIT
	.area   _GSFINAL

	.area	_DATA
	.area	_INITIALIZED
	.area	_BSEG
	.area   _BSS
	.area   _HEAP

	.area   _GSINIT
gsinit::

	; Default-initialized global variables.
        ld      bc, #l__DATA
        ld      a, b
        or      a, c
        jr      Z, zeroed_data
        ld      hl, #s__DATA
        ld      (hl), #0x00
        dec     bc
        ld      a, b
        or      a, c
        jr      Z, zeroed_data
        ld      e, l
        ld      d, h
        inc     de
        ldir
zeroed_data:

	; Explicitly initialized global variables.
	ld	bc, #l__INITIALIZER
	ld	a, b
	or	a, c
	jr	Z, gsinit_next
	ld	de, #s__INITIALIZED
	ld	hl, #s__INITIALIZER
	ldir

gsinit_next:

	.area   _GSFINAL
	ret

