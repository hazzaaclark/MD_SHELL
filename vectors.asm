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

    BRA             HW_CHECK                    ;; BRANCH TO CHECK FOR HARDWARE DEFINES

HW_CHECK:
    MOVEQ           #$F, D7
    AND.B           $A10001-$A11100(A3), D7     ;; ACCESS HARDWARE REV
    BEQ.S           @HW_DONE                    ;; BRANCH ASSUMING THAT THE RESULT IS EQUAL TO THE AND COMPARISON (SEE: main.asm)
    MOVE.L          #'SEGA' $A14000             ;; CHECK FOR SEGA CHAR IN ORDER TO INIT VDP                    
    
BUS_ERROR:          ASM_EXTERN
    PRINT_STDERR    "BUS ERROR", EXCE_DEFAULT | ADDRESS_ERROR_FLAG

ADDRESS_ERROR:      ASM_EXTERN
    PRINT_STDERR    "ADDRESS ERROR", EXCE_DEFAULT | ADDRESS_ERROR_FLAG

ILLEGAL_INSTR:      ASM_EXTERN
    PRINT_STDERR    "ILLEGAL INSTRUCTION", EXCE_DEFAULT

ZERO_DIV:           ASM_EXTERN
    PRINT_STDERR    "ZERO DIVISION", EXCE_DEFAULT

CHK_INSTR:          ASM_EXTERN
    PRINT_STDERR    "CHECK INSTRUCTION", EXCE_DEFAULT

TRAPV_INSTR:        ASM_EXTERN
    PRINT_STDERR    "TRAP_V INSTRUCTION", EXCE_DEFAULT

PRIV_VIOL:          ASM_EXTERN
    PRINT_STDERR    "PRIVILEEGE VIOLATION", EXCE_DEFAULT

TRACE:              ASM_EXTERN
    PRINT_STDERR    "TRACE", EXCE_DEFAULT

LINE_1010:          ASM_EXTERN
    PRINT_STDERR    "LINE_1010 EMULATOR", EXCE_DEFAULT

LINE_1111:          ASM_EXTERN
    PRINT_STDERR    "LINE_1111 EMULATOR", EXCE_DEFAULT

ERROR_EXCEPT:       ASM_EXTERN
    PRINT_STDERR    "ERROR EXCEPTION", EXCE_DEFAULT

IDLE_INT:           ASM_EXTERN
    RTE

;--------------------------------------------------------
;       THINK OF THIS AS A MAKESHIFT HALT COROUTINE
;   SUCH THAT IF THERE IS NO CONCURRENT INSTRUCTION
;       TRAP WILL LOOK TO STOP CPU EXECUTION
;--------------------------------------------------------

ERROR_TRAP:         ASM_EXTERN
    NOP
    BRA.S   ERROR_TRAP

;--------------------------------------------------------
;       SETUP DIRECTIVES AND VALUES THAT CORRESPOND
;   WITH THE VDP, Z80, INITALISATION OF PORTS, TMSS, ETC
;--------------------------------------------------------

@SETUP_VALUES:      ASM_EXTERN

    DC.L            $C00004                 ; VDP CTRL
    DC.L            $A11100                 ; Z80 BUS REQ
    DC.L            $A11200                 ; Z80 RESET
