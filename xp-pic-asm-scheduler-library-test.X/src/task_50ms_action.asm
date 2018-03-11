;=============================================================================
; @(#)task_50ms_action.asm
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
; Target.....: Microchip PIC 16F648A Microcontroller
; Compiler...: Microchip Assembler (MPASM)
; Version....: 1.1 2018/03/11 - source refactory
;              1.0 2017/05/20
;
; Routine....: task_50ms_action
; Description: action code of 50ms period task
;
;  This routine must be overrided with task code.
;=============================================================================

        GLOBAL      task_50ms_action


;=============================================================================
; 50ms-delay Task
;=============================================================================
        CODE                                    ; begin module
task_50ms_action

        nop

        return

        END                                     ; end module
