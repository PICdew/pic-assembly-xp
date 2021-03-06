;=============================================================================
; @(#)xp-delay-library-test.asm
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
; Target.....: Microchip MidRange PICmicro
; Compiler...: Microchip Assembler (MPASM)
; Version....: 1.0 2018/03/09
; Description: Test program for xp-delay-library routines
;=============================================================================

    PROCESSOR   16f648a
    INCLUDE     <p16f648a.inc>
    INCLUDE     "../xp-pic-asm-delay-cycles-library.X/src/xp-delay-cycles-library.inc"


;=============================================================================
;  CONFIGURATION
;=============================================================================
    __CONFIG    _CP_OFF & _DATA_CP_OFF & _LVP_OFF & _BOREN_OFF & _MCLRE_ON & _WDT_OFF & _PWRTE_ON & _HS_OSC


;=============================================================================
;  RESET VECTOR
;=============================================================================
RESET               CODE    0x0000              ; processor reset vector
        pagesel     MAIN                        ; 
        goto        MAIN                        ; go to beginning of program


;=============================================================================
;  MAIN PROGRAM
;=============================================================================
MAINPROGRAM         CODE                        ; begin program
MAIN
        banksel     xpDelay1000
        call        xpDelay1000

        banksel     xpDelay2500
        call        xpDelay2500

        banksel     xpDelay4000
        call        xpDelay4000

        banksel     xpDelay5000
        call        xpDelay5000

        banksel     xpDelay10000
        call        xpDelay10000

        banksel     xpDelay25000
        call        xpDelay25000

        banksel     xpDelay40000
        call        xpDelay40000

        banksel     xpDelay50000
        call        xpDelay50000

        banksel     xpDelay100000
        call        xpDelay100000

        banksel     xpDelay250000
        call        xpDelay250000

        banksel     xpDelay400000
        call        xpDelay400000

        banksel     xpDelay500000
        call        xpDelay500000

        banksel     xpDelay1250000
        call        xpDelay1250000

        banksel     xpDelay2500000
        call        xpDelay2500000

        banksel     xpDelay5000000
        call        xpDelay5000000

        END                                     ; end program