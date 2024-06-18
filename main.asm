;--------------------------------------------------------
;           COPYRIGHT (C) HARRY CLARK 2024
;--------------------------------------------------------
;           SEGA MEGA DRIVE SHELL UTILITY
;--------------------------------------------------------

;--------------------------------------------------------
;   THIS FILE PERTAINS TOWARDS THE MAIN FUNCTIONALITY
;                  OF THE PROGRAM
;--------------------------------------------------------
;   
            INCLUDE "vectors.asm"
;
;--------------------------------------------------------

ROM_HEADER:

    DC.B        'SEGA MEGA DRIVE '
    DC.B        '(C)         HARRY CLARK                         '
    DC.B        'SEGA MEGA DRIVE SHELL                          '
    DC.B        'SEGA MEGA DRIVE SHELL                          '
    DC.B        'GM-00000000-00'
    DC.W        0
    DC.B        'J              '
    DC.L        $000000, $0FFFFF
    DC.L        $FF0000, $FFFFFF
    DC.B        '               '
    DC.B        '               '
    DC.B        'JUE            '


;--------------------------------------------------------
;         DEFINE THE CONSTRUCTS THAT FASHION UP
;           THE ENTRY POINT OF THE PROGRAM 
;--------------------------------------------------------

;--------------------------------------------------------
;       THIS ENCOMPASSES ALL FUNCTIONALITY SUCH AS
;   VALIDATING THE TMSS REGISTER, AS WELL AS INITIALISING
;   ADDRESS REGISTERS TO READ THE HARDWARE CHECKS TO RAM
;--------------------------------------------------------

PROG_ENTRY:
    MOVE        #$2700, SR              ;; DISABLE INTERRUPTS IN STACK REGISTER BASED ON OFFSET
    LEA         SETUP_VALUES(PC), A0
    MOVEM.L     (A0)+, A2-A5

    TST.W       $A1000C-$A11100(A3)
    BNE.S       @INIT_DONE
    MOVEM.W     (A0)+, D0-D6  

    MOVEQ       #$F, D7
    AND.B       $A10001-$A11100(A3), D7
    BEQ         HW_DONE
    MOVE.L      $100.W, $A10001-$A11100(A3)


@INIT_DONE:
    BRA       PROG_START

PROG_START:
    MOVEA.L     0.W, SP
    MOVEQ       #$40, D0
    MOVE.B      D0, $A10009
    MOVE.B      D0, $A1000B

    MOVE        #$2700, SR
