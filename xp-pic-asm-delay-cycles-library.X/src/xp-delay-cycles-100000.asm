;=============================================================================
; @(#)xp-delay-cycles-100000.asm
;                       ________.________
;   ____   ____  ______/   __   \   ____/
;  / ___\ /  _ \/  ___/\____    /____  \ 
; / /_/  >  <_> )___ \    /    //       \
; \___  / \____/____  >  /____//______  /
;/_____/            \/                \/ 
; Copyright (c) 2018 by Alessandro Fraschetti (gos95@gommagomma.net).
;
; This file is part of the xp-pic-asm project:
;     https://github.com/gos95-electronics/xp-pic-asm
; This code comes with ABSOLUTELY NO WARRANTY.
;
; Author.....: Alessandro Fraschetti
; Company....: gos95
; Target.....: Microchip Mid-Range PICmicro
; Compiler...: Microchip Assembler (MPASM)
; Version....: 1.0 2018/03/09
;
; Module.....: xpDelay100000
; Description: 100000 cycles delay routine
;=============================================================================

    TITLE       'xpDelay100000 - 100000 cycles delay'
    SUBTITLE    'Part of the xp-delay-cycles-library'

    GLOBAL      xpDelay100000


;=============================================================================
;  VARIABLE DEFINITIONS
;=============================================================================
; Unitialized Data Section
GPR_MODULE_VAR      UDATA
localvar1           RES     1
localvar2           RES     1


;=============================================================================
;  MODULE PROGRAM
;=============================================================================
MODULE              CODE                        ; begin module
xpDelay100000
        movlw       0x1E                        ; 99993 cycles
        movwf       localvar1
        movlw       0x4F
        movwf       localvar2
inner_loop
        decfsz      localvar1, F
        goto        $+2
        decfsz      localvar2, F
        goto        inner_loop
        goto        $+1                         ; 3 cycles
        nop

        return                                  ; 4 cycles (including call)

        END                                     ; end module