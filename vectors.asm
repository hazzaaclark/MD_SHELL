;--------------------------------------------------------
;           COPYRIGHT (C) HARRY CLARK 2024
;--------------------------------------------------------
;           SEGA MEGA DRIVE SHELL UTILITY
;--------------------------------------------------------

            INCLUDE "macros.asm"

;--------------------------------------------------------
;   THIS FILE PERTAINS TOWARDS THE DECLARATION OF THE
;                   VECTOR TABLE
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

ENTRY_POINT:
    MOVE            #$2700, SR                  ;; DISABLE INTERRUPTS BASED ON CURRENT SR OFFSET
    LEA             @SETUP_VALUES(PC), A0       ;; LOAD CURRENT EXECUTION FROM PC TO A0
    MOVEM.L         (A0)+, A2-A5                ;; INIT ADDRESS REGISTERS

    TST.W           $A1000C-$A11100(A3)         ;; IS PORT C INIT?

    MOVEM.W         (A0)+, D0-D6                ;; INIT DATA REGISTERS
    
BUS_ERROR:

ADDRESS_ERROR:

ILLEGAL_INSTR:

ZERO_DIV:

CHK_INSTR:

TRAPV_INSTR:

PRIV_VIOL:

TRACE:

LINE_1010:

LINE_1111:

ERROR_EXCEPT:

IDLE_INT:

ERROR_TRAP:




@SETUP_VALUES:      ASM_EXTERN

    DC.L            $C00004
    DC.L            $A11100
    DC.L            $A11200
