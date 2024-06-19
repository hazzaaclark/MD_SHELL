;--------------------------------------------------------
;           COPYRIGHT (C) HARRY CLARK 2024
;--------------------------------------------------------
;           SEGA MEGA DRIVE SHELL UTILITY
;--------------------------------------------------------

            INCLUDE "macros.asm"

;--------------------------------------------------------
;   THIS FILE PERTAINS TOWARDS THE MAIN FUNCTIONALITY
;                  OF THE PROGRAM
;--------------------------------------------------------

VECTORS:

    DC.L        $FFFFF0,            ENTRY_POINT,        BUS_ERROR,          ADDRESS_ERROR
    DC.L        ILLEGAL_INSTR,      ZERO_DIV,           CHK_INSTR,          TRAPV_INSTR
    DC.L        PRIV_VIOL,          TRACE,              LINE_1010,          LINE_1111
    DC.L        ERROR_EXCEPT,       ERROR_EXCEPT,       ERROR_EXCEPT,       ERROR_EXCEPT
    DC.L        ERROR_EXCEPT,       ERROR_EXCEPT,       ERROR_EXCEPT,       ERROR_EXCEPT
    DC.L        ERROR_EXCEPT,       ERROR_EXCEPT,       ERROR_EXCEPT,       ERROR_EXCEPT
    DC.L        ERROR_EXCEPT,       ERROR_TRAP,         ERROR_TRAP,         ERROR_TRAP
    DC.L        IDLE_INT,           ERROR_TRAP,         IDLE_INT,           ERROR_TRAP
    DC.L        ERROR_TRAP,         ERROR_TRAP,         ERROR_TRAP,         ERROR_TRAP
    DC.L        ERROR_TRAP,         ERROR_TRAP,         ERROR_TRAP,         ERROR_TRAP
    DC.L        ERROR_TRAP,         ERROR_TRAP,         ERROR_TRAP,         ERROR_TRAP
    DC.L        ERROR_TRAP,         ERROR_TRAP,         ERROR_TRAP,         ERROR_TRAP
    DC.L        ERROR_TRAP,         ERROR_TRAP,         ERROR_TRAP,         ERROR_TRAP
    DC.L        ERROR_TRAP,         ERROR_TRAP,         ERROR_TRAP,         ERROR_TRAP
    DC.L        ERROR_TRAP,         ERROR_TRAP,         ERROR_TRAP,         ERROR_TRAP
    DC.L        ERROR_TRAP,         ERROR_TRAP,         ERROR_TRAP,         ERROR_TRAP

;--------------------------------------------------------
;       THIS SECTION PERTAINS TOWARDS THE DECLARATION
;       OF THE ROM HEADER AND SUBSEQUENT DEFINES
;--------------------------------------------------------

ROM_START:
    DC.B        'SEGA MEGA DRIVE '                          ;; CONSOLE NAME 
    DC.B        '(C)HARRY CLARK '                           ;; AUTHOR NAME 
    DC.B        '    SEGA MEGA DRIVE SHELL                      '            ;; DOMESTIC NAME
    DC.B        '    SEGA MEGA DRIVE SHELL                      '            ;; INTERNATION NAME (NOT USED)
    DC.B        '   GM-00000000-00'                                                ;; CODE
    DC.W        0x0000                                                          ;; SP
    DC.B        'J              '                                               ;; IO SUPPORT 
    DC.L        ROM_START                                                       ;; ROM START
    DC.L        ROM_END-1                                                       ;; ROM END
    DC.L        $FF0000                                                         ;; RAM START
    DC.L        $FFFFFF                                                         ;; RAM END
    DC.L        $20202020                                                       ;; SRAM START
    DC.L        $20202020                                                       ;; SRAM END
    DC.B        "                                               "
    DC.B        "JUE            "                                                ;; REGION


;--------------------------------------------------------
;         DEFINE THE CONSTRUCTS THAT FASHION UP
;           THE ENTRY POINT OF THE PROGRAM 
;
;       THIS ENCOMPASSES ALL FUNCTIONALITY SUCH AS
;   VALIDATING THE TMSS REGISTER, AS WELL AS INITIALISING
;   ADDRESS REGISTERS TO READ THE HARDWARE CHECKS TO RAM
;--------------------------------------------------------

ENTRY_POINT:
    MOVE            #$2700, SR                  ;; DISABLE INTERRUPTS BASED ON CURRENT SR OFFSET
    LEA             SETUP_VALUES(PC), A0       ;; LOAD CURRENT EXECUTION FROM PC TO A0
    MOVEM.L         (A0)+, A2-A5                ;; INIT ADDRESS REGISTERS

    TST.W           $A1000C-$A11100(A3)         ;; IS PORT C INIT?

    MOVEM.W         (A0)+, D0-D6                ;; INIT DATA REGISTERS

    BRA             HW_CHECK                    ;; BRANCH TO CHECK FOR HARDWARE DEFINES

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



    INCLUDE "vectors.asm"


ROM_END:
