;=============================================================================
; @(#)delay2500000.asm
;                       ________.________
;   ____   ____  ______/   __   \   ____/
;  / ___\ /  _ \/  ___/\____    /____  \ 
; / /_/  >  <_> )___ \    /    //       \
; \___  / \____/____  >  /____//______  /
;/_____/            \/                \/ 
; Copyright (c) 2017 by Alessandro Fraschetti (gos95@gommagomma.net).
;
; This file is part of the xp-pic-asm project:
;     https://github.com/gos95-electronics/xp-pic-asm
; This code comes with ABSOLUTELY NO WARRANTY.
;
; Author.....: Alessandro Fraschetti
; Company....: gos95
; Target.....: Microchip PIC 16Fxxx Microcontroller
; Compiler...: Microchip Assembler (MPASM)
; Version....: 1.0 2018/03/09
;
; Module.....: DELAY2500000
; Description: 2500000 cycles delay routine
;=============================================================================

        TITLE       'DELAY2500000 - 2500000 cycles delay'
        SUBTITLE    'Part of the xp-delay-library'

        GLOBAL      DELAY2500000


;=============================================================================
; Variable declarations
;=============================================================================
GPR_VAR         UDATA
localvar1       RES         1
localvar2       RES         1
localvar3       RES         1


;=============================================================================
; Module
;=============================================================================
        CODE                                    ; begin module
DELAY2500000
        movlw       0x15                        ; 2499992 cycles
        movwf       localvar1
        movlw       0x74
        movwf       localvar2
        movlw       0x06
        movwf       localvar3
delay2500000_loop
        decfsz      localvar1, F
        goto        $+2
        decfsz      localvar2, F
        goto        $+2
        decfsz      localvar3, F
        goto        delay2500000_loop
        goto        $+1                         ; 4 cycle
        goto        $+1

        return                                  ; 4 cycles (including call)

        END                                     ; end module