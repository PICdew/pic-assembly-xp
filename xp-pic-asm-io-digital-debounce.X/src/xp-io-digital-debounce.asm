;=============================================================================
; @(#)xp-io-digital-debounce.asm
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
; Target.....: Microchip PICmicro 16F648a Microcontroller
; Compiler...: Microchip Assembler (MPASM)
; Version....: 1.1 2018/03/13 - source refactory
;              1.0 2017/04/08
; Description: Software debounce tecniques for input switches.
;=============================================================================

    PROCESSOR   16f648a
    INCLUDE     <p16f648a.inc>


;=============================================================================
;  CONFIGURATION
;=============================================================================
    __CONFIG    _CP_OFF & _DATA_CP_OFF & _LVP_OFF & _BOREN_OFF & _MCLRE_ON & _WDT_OFF & _PWRTE_ON & _HS_OSC


;=============================================================================
;  LABEL EQUATES
;=============================================================================
SWITCH              EQU     PORTB
SW1                 EQU     0x00
SW2                 EQU     0x01
SW3                 EQU     0x02
SW4                 EQU     0x03

LED                 EQU     PORTA
LED1                EQU     0x00
LED2                EQU     0x01
LED3                EQU     0x02
LED4                EQU     0x03


;=============================================================================
;  VARIABLE DEFINITIONS
;=============================================================================
; Shared Uninitialized Data Section
SHARED_VAR          UDATA_SHR     
swstatereg          RES     1                   ; switches state (1=UP, 0=DW)
sample_counter      RES     1
d1                  RES     1                   ; the delay routine vars
d2                  RES     1                   ;
d3                  RES     1                   ;


;=============================================================================
;  RESET VECTOR
;=============================================================================
RESET               CODE    0x0000              ; processor reset vector
        pagesel     MAIN                        ; 
        goto        MAIN                        ; go to beginning of program


;=============================================================================
;  INIT ROUTINES
;=============================================================================
INIT_ROUTINES       CODE                        ; routines vector
init_ports

        errorlevel	-302

        ; set PORTA JA1(A0-A3) as Output
        pagesel     PORTA
        clrf		PORTA                       ; initialize PORTB by clearing output data latches
        movlw       h'07'                       ; turn comparators off
        movwf       CMCON                       ; and set port A mode I/O digital
        pagesel     TRISA
        movlw		b'11100000'                 ; PORTA input/output
  		movwf		TRISA

        ; set JB1 (B0-B3) as Input
        pagesel     PORTB
        clrf		PORTB                       ; initialize PORTB by clearing output data latches
        pagesel     TRISB
        movlw		b'00001111'                 ; PORTB input/output
        movwf		TRISB

        errorlevel  +302

        return


;=============================================================================
;  DELAY ROUTINES
;=============================================================================
DELAY_ROUTINES      CODE                        ; routines vector

;  1s delay routine (20MHz)
delay1s
        movlw       0x2C                        ;4999993 cycles
        movwf       d1
        movlw       0xE7
        movwf       d2
        movlw       0x0B
        movwf       d3
delay1s_loop
        decfsz      d1, F
        goto        $+2
        decfsz      d2, F
        goto        $+2
        decfsz      d3, F
        goto        delay1s_loop
        goto        $+1                         ;3 cycles
        nop

        return                                  ;4 cycles (including call)


;  100ms delay routine (20MHz)
delay100ms
        movlw       0x03                        ;499994 cycles
        movwf       d1
        movlw       0x18
        movwf       d2
        movlw       0x02
        movwf       d3
delay100ms_loop
        decfsz      d1, F
        goto        $+2
        decfsz      d2, F
        goto        $+2
        decfsz      d3, F
        goto        delay100ms_loop
        goto        $+1                         ;2 cycles

        return                                  ;4 cycles (including call)


;  50ms delay routine (20MHz)
delay50ms
        movlw       0x4E                        ;249993  cycles
        movwf       d1
        movlw       0xC4
        movwf       d2
delay50ms_loop
        decfsz      d1, F
        goto        $+2
        decfsz      d2, F
        goto        delay50ms_loop
        goto        $+1                         ;3 cycles
        nop

        return                                  ;4 cycles (including call)


;  25ms delay routine (20MHz)
delay25ms
        movlw       0xA6                        ;124993  cycles
        movwf       d1
        movlw       0x62
        movwf       d2
delay25ms_loop
        decfsz      d1, F
        goto        $+2
        decfsz      d2, F
        goto        delay25ms_loop
        goto        $+1                         ;3 cycles
        nop

        return                                  ;4 cycles (including call)


;  10ms delay routine (20MHz)
delay10ms
        movlw       0x0E                        ;49993 cycles
        movwf       d1
        movlw       0x28
        movwf       d2
delay10ms_loop
        decfsz      d1, F
        goto        $+2
        decfsz      d2, F
        goto        delay10ms_loop
        goto        $+1                         ;3 cycles
        nop

        return                                  ;4 cycles (including call)


;  5ms delay routine (20MHz)
delay5ms
        movlw       0x86                        ;24993 cycles
        movwf       d1
        movlw       0x14
        movwf       d2
delay5ms_loop
        decfsz      d1, F
        goto        $+2
        decfsz      d2, F
        goto        delay5ms_loop
        goto        $+1                         ;3 cycles
        nop

        return                                  ;4 cycles (including call)


;  1ms delay routine (20MHz)
delay1ms
        movlw       0xE6                        ;4993 cycles
        movwf       d1
        movlw       0x04
        movwf       d2
delay1ms_loop
        decfsz      d1, F
        goto        $+2
        decfsz      d2, F
        goto        delay1ms_loop
        goto        $+1                         ;3 cycles
        nop

        return                                  ;4 cycles (including call)


;=============================================================================
;  MAIN PROGRAM
;=============================================================================
MAINPROGRAM         CODE                        ; begin program
MAIN
		lcall 		init_ports
        pagesel     $

        bcf         LED, LED1
        bcf         LED, LED2
        bcf         LED, LED3
        bcf         LED, LED4

        movlw       b'0001111'
        movwf       swstatereg
        clrf        sample_counter
mainloop

switch_1_control ; momentary toggling switch with no debounce
        btfsc       SWITCH, SW1
        goto        switch_2_control

        btfsc       LED, LED1
        goto        $+3
        bsf         LED, LED1
        goto        switch_2_control
        bcf         LED, LED1


switch_2_control ; momentary toggling switch with single delay debounce tecnique
        btfsc       SWITCH, SW2
        goto        switch_2_reset
        lcall       delay1ms
        pagesel     $
        btfsc       SWITCH, SW2
        goto        switch_2_reset

        btfsc       swstatereg, SW2
        goto        switch_3_control
        bsf         swstatereg, SW2
switch_2_action
        btfsc       LED, LED2
        goto        $+3
        bsf         LED, LED2
        goto        switch_3_control
        bcf         LED, LED2
        goto        switch_3_control
switch_2_reset
        bcf         swstatereg, SW2


switch_3_control ; momentary switch
        btfsc       SWITCH, SW3
        goto        switch_3_up
        bsf         LED, LED3
        goto        switch_4_control
switch_3_up
        bcf         LED, LED3


switch_4_control ; momentary toggling switch with sampling debounce tecnique
        btfsc       swstatereg, SW4             ; last SW stable state is UP?
        goto        sample_sw_up

sample_sw_down                                  ; scan for SW = DW
        clrw
        btfss       SWITCH, SW4                 ; if SW is DW
        incf        sample_counter, W           ; inc counter to W
        movwf       sample_counter              ; store W value to F and count samples
        goto        count_samples

sample_sw_up                                    ; scan for SW = UP
        clrw
        btfsc       SWITCH, SW4                 ; if SW is UP
        incf        sample_counter, W           ; inc counter to W
        movwf       sample_counter              ; store W value to F and count samples

count_samples                                   ; execute debounce
        movf        sample_counter, W           ; counter value reached sample size?
        xorlw       5
        btfss       STATUS, Z
        goto        end_sw_controls

        btfsc       swstatereg, SW4             ; invert SW stable state
        goto        $+3
        bsf         swstatereg, SW4
        goto        $+2
        bcf         swstatereg, SW4

        clrf        sample_counter              ; clear and go to the SW action
        btfss       swstatereg, SW4
        goto        end_sw_controls

switch_action                                   ; do action
        btfsc       LED, LED4
        goto        $+3
        bsf         LED, LED4
        goto        end_sw_controls
        bcf         LED, LED4


end_sw_controls
        lcall       delay1ms
        pagesel     $
        goto        mainloop

        END                                     ; end program