;=============================================================================
; @(#)filename.asm
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
; Target.....: Microchip PICmicro #pic_model# Microcontroller
; Compiler...: Microchip Assembler (MPASM)
; Version....: #x.y# #release_date# - #whatsnew#
;              #x.y# #release_date# - #whatsnew#
; Description: #program description#
;=============================================================================

    PROCESSOR   16f648a
    INCLUDE     <p16f648a.inc>


;=============================================================================
;  CONFIGURATION
;=============================================================================
    __CONFIG    _CP_OFF & _DATA_CP_OFF & _LVP_OFF & _BOREN_OFF & _MCLRE_ON & _WDT_OFF & _PWRTE_ON & _HS_OSC
;    __CONFIG   _CP_OFF & _DATA_CP_OFF & _LVP_OFF & _BOREN_OFF & _MCLRE_OFF & _WDT_OFF & _PWRTE_ON & _INTOSC_OSC_NOCLKOUT

                ; _CP_[ON/OFF]    : code protect program memory enable/disable
                ; _CPD_[ON/OFF]   : code protect data memory enable/disable
                ; _LVP_[ON/OFF]   : Low Voltage ICSP enable/disable
                ; _BOREN_[ON/OFF] : Brown-Out Reset enable/disable
                ; _WDT_[ON/OFF]   : watchdog timer enable/disable
                ; _MCLRE_[ON/OFF] : MCLR pin function digitalIO/MCLR
                ; _PWRTE_[ON/OFF] : power-up timer enable/disable


;=============================================================================
;  CONSTANT DEFINITIONS
;=============================================================================
stuffc              EQU     0x01                ; assign value 1 to label stuffc 
    CONSTANT    CONST1 = .1


;=============================================================================
;  VARIABLE DEFINITIONS
;=============================================================================
    CBLOCK	0x020
        w_temp                                  ; variable used for context saving
        status_temp                             ; variable used for context saving
        pclath_temp                             ; variable used for context saving
        twoByteVar: 0, twoByteH, twoByteL
        doubleWordVar: 2
    ENDC


;=============================================================================
;  MACROS
;=============================================================================


;=============================================================================
;  RESET VECTOR
;=============================================================================
RESET               ORG     0x0000              ; processor reset vector
        pagesel     MAIN
        goto        MAIN                        ; jump to the main routine


;=============================================================================
;  INTERRUPT VECTOR
;=============================================================================
INTERRUPT           ORG     0x0004              ; interrupt vector location
        movwf       w_temp                      ; save off current W register contents
        movf        STATUS, W                   ; move status register into W register
        movwf       status_temp                 ; save off contents of STATUS register
        movf        PCLATH, W                   ; move pclath register into W register
        movwf       pclath_temp                 ; save off contents of PCLATH register

        ; isr code can go here or be located as a call subroutine elsewhere

        movf        pclath_temp, W              ; retrieve copy of PCLATH register
        movwf       PCLATH                      ; restore pre-isr PCLATH register contents
        movf        status_temp, W              ; retrieve copy of STATUS register
        movwf       STATUS                      ; restore pre-isr STATUS register contents
        swapf       w_temp, F
        swapf       w_temp, W                   ; restore pre-isr W register contents
        retfie                                  ; return from interrupt


;=============================================================================
;  ROUTINES... name and description
;=============================================================================


;=============================================================================
;  MAIN PROGRAM
;=============================================================================
MAIN                                            ; begin program
        nop

        END                                     ; end program