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
    DC.L        ERROR_TRAP,         ERROR_TRAP,         ERROR_TRAP,         ERROR_TRAP
    DC.L        IDLE_INT,           ERROR_TRAP,         IDLE_INT,           ERROR_TRAP
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
    DC.B        '            SEGA MEGA DRIVE SHELL                      '            ;; DOMESTIC NAME
    DC.B        '            SEGA MEGA DRIVE SHELL                      '            ;; INTERNATION NAME (NOT USED)
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

                INCLUDE "vectors.asm"
                INCLUDE "vdp.asm"

ENTRY_POINT:
    LEA             VDP_SETTINGS, A5
    MOVE.W          (VDP_CTRL), D0
    MOVE.L          #$00008000, D5

NEXT_VIDEO_BYTE:
    MOVE.B          (A5)+, D5
    MOVE.W          D5, (VDP_CTRL)
    ADD.W           #$0100, D5
    DBRA            D1, NEXT_VIDEO_BYTE

;--------------------------------------------------------
;           INITIALISE THE PALETTE INTO CRAM
;--------------------------------------------------------

PALETTE_DATA:
    DC.W            $0EEE, $0000, $0EEE, $0000, $0EEE, $0000, $0EEE, $0000
    DC.W            $0EEE, $0000, $0EEE, $0000, $0EEE, $0000, $0EEE, $0000
    DC.W            $0EEE, $0000, $0EEE, $0000, $0EEE, $0000, $0EEE, $0000
    DC.W            $0EEE, $0000, $0EEE, $0000, $0EEE, $0000, $0EEE, $0000

ROM_END:
