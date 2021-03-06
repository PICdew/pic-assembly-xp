	LIST    P = 16C54, n = 66
;
;*******************************************************************
;                       Double Precision Multiplication
;
;               ( Optimized for Speed : straight Line Code )
;
;*******************************************************************;
;   Multiplication : ACCb(16 bits) * ACCa(16 bits) -> ACCb,ACCc ( 32 bits )
;      (a) Load the 1st operand in location ACCaLO & ACCaHI ( 16 bits )
;      (b) Load the 2nd operand in location ACCbLO & ACCbHI ( 16 bits )
;      (c) CALL D_mpy
;      (d) The 32 bit result is in location ( ACCbHI,ACCbLO,ACCcHI,ACCcLO )
;
;   Performance :
;               Program Memory  :       240
;               Clock Cycles    :       233
;
;       Note : The above timing is the worst case timing, when the
;               register ACCb = FFFF. The speed may be improved if
;               the register ACCb contains a number ( out of the two
;               numbers ) with less number of 1s.
;
;               The performance specs are for Unsigned arithmetic ( i.e,
;               with "SIGNED equ  FALSE ").
;
;       Program:          DBL_MPYF.ASM 
;       Revision Date:   
;                         1-13-97      Compatibility with MPASMWIN 1.40
;
;*******************************************************************;
;
ACCaLO  equ     10
ACCaHI  equ     11
ACCbLO  equ     12
ACCbHI  equ     13
ACCcLO  equ     14
ACCcHI  equ     15
ACCdLO  equ     16
ACCdHI  equ     17
temp    equ     18
sign    equ     19
;
	include "p16c5x.inc"

PIC54   equ     1FFH    ; Define Reset Vector
TRUE    equ     1
FALSE   equ     0

	org     0
;*******************************************************************
SIGNED  equ     FALSE           ; Set This To 'TRUE' if the routines
;                               ; for Multiplication & Division needs
;                               ; to be assembled as Signed Integer
;                               ; Routines. If 'FALSE' the above two
;                               ; routines ( D_mpy & D_div ) use
;                               ; unsigned arithmetic.
;*******************************************************************
;       multiplication macro
;
mulMac  MACRO
	LOCAL   NO_ADD
;
	rrf     ACCdHI, F       ;rotate d right
	rrf     ACCdLO, F
	btfss   STATUS,C    ;need to add?
	goto    NO_ADD          ; no addition necessary
	movf    ACCaLO,W        ; Addition ( ACCb + ACCa -> ACCb )
	addwf   ACCbLO, F       ;add lsb
	btfsc   STATUS,C    ;add in carry
	incf    ACCbHI, F
	movf    ACCaHI,W
	addwf   ACCbHI, F       ;add msb
NO_ADD  rrf     ACCbHI, F
	rrf     ACCbLO, F
	rrf     ACCcHI, F
	rrf     ACCcLO, F
;
	ENDM
;
;*******************************************************************;
;               Double Precision Multiply ( 16x16 -> 32 )
;         ( ACCb*ACCa -> ACCb,ACCc ) : 32 bit output with high word
;  in ACCb ( ACCbHI,ACCbLO ) and low word in ACCc ( ACCcHI,ACCcLO ).
;
D_mpyF                          ;results in ACCb(16 msb's) and ACCc(16 lsb's)
;
     IF   SIGNED
     CALL    S_SIGN
     ENDIF
;
	call    setup
;
; use the mulMac macro 16 times
;
	mulMac
	mulMac
	mulMac
	mulMac
	mulMac
	mulMac
	mulMac
	mulMac
	mulMac
	mulMac
	mulMac
	mulMac
	mulMac
	mulMac
	mulMac
	mulMac
;
    IF    SIGNED
	btfss   sign,MSB
	retlw   0
	comf    ACCcLO          ; negate ACCa ( -ACCa -> ACCa )
	incf    ACCcLO
	btfsc   STATUS,Z
	decf    ACCcHI
	comf    ACCcHI
	btfsc   STATUS,Z
neg_B   comf    ACCbLO          ; negate ACCb
	incf    ACCbLO
	btfsc   STATUS,Z
	decf    ACCbHI
	comf    ACCbHI
	retlw   0
    ELSE
	retlw   0
    ENDIF
;
;*******************************************************************
;
setup   movlw   .16             ; for 16 shifts
	movwf   temp
	movf    ACCbHI,W          ;move ACCb to ACCd
	movwf   ACCdHI
	movf    ACCbLO,W
	movwf   ACCdLO
	clrf    ACCbHI
	clrf    ACCbLO
	retlw   0
;
;*******************************************************************
;
neg_A   comf    ACCaLO, F       ; negate ACCa ( -ACCa -> ACCa )
	incf    ACCaLO, F
	btfsc   STATUS,Z
	decf    ACCaHI, F
	comf    ACCaHI, F
	retlw   0
;
;*******************************************************************
;  Assemble this section only if Signed Arithmetic Needed
;
     IF    SIGNED
;
S_SIGN  movf    ACCaHI,W
	xorwf   ACCbHI,W
	movwf   sign
	btfss   ACCbHI,MSB        ; if MSB set go & negate ACCb
	goto    chek_A
;
	comf    ACCbLO          ; negate ACCb
	incf    ACCbLO
	btfsc   STATUS,Z
	decf    ACCbHI
	comf    ACCbHI
;
chek_A  btfss   ACCaHI,MSB        ; if MSB set go & negate ACCa
	retlw   0
	goto    neg_A
;
     ENDIF
;
;*******************************************************************
;                       Test Program
;*******************************************************************
;    Load constant values to ACCa & ACCb for testing
;
loadAB  movlw   1
	movwf   ACCaHI
	movlw   0FF             ; loads ACCa = 01FF
	movwf   ACCaLO
;
	movlw   07F
	movwf   ACCbHI
	movlw   0FF             ; loads ACCb = 7FFF
	movwf   ACCbLO
	retlw   0
;
main    nop
;
	call    loadAB          ; result of multiplying ACCb*ACCa->(ACCb,ACCc)
	call    D_mpyF          ; Here (ACCb,ACCc) = 00FF 7E01
;
self    goto    self
;
	org     PIC54
	goto    main
	END
;****************************************************************

