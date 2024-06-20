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
    DC.B        '           SEGA MEGA DRIVE SHELL                       '            ;; DOMESTIC NAME
    DC.B        '           SEGA MEGA DRIVE SHELL                       '            ;; INTERNATION NAME (NOT USED)
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

;--------------------------------------------------------
;   DEFINE THE ENTRY POINTS FOR THE VDP TO BE SETUP
;
;--------------------------------------------------------

HW_CHECK:
    MOVEQ           #$F, D7
    AND.B           $A10001-$A11100(A3), D7     ;; ACCESS HARDWARE REV
    BEQ             HW_DONE                    ;; BRANCH ASSUMING THAT THE RESULT IS EQUAL TO THE AND COMPARISON (SEE: main.asm)
    MOVE.L          #'SEGA', $A14000             ;; CHECK FOR SEGA CHAR IN ORDER TO INIT VDP


                INCLUDE "vdp.asm"


ENTRY_POINT:
    LEA             VDP_SETTINGS, A5
    MOVE.L          #VDP_SETTINGS_END-VDP_SETTINGS, D1
    MOVE.W          (VDP_CTRL), D0
    MOVE.L          #$00008000, D5

NEXT_VIDEO_BYTE:
    MOVE.B          (A5)+, D5
    MOVE.W          D5, (VDP_CTRL)
    ADD.W           #$0100, D5
    DBRA            D1, NEXT_VIDEO_BYTE

    ;--------------------------------------------------------
    ;                   DEFINE THE PALETTE 
    ;--------------------------------------------------------

    MOVE.L          #$C0000000, D0
    MOVE.L          D0, VDP_CTRL
    MOVE.W          #%0000011000000000, VDP_DATA

    MOVE.L          #$C0020000, D0
    MOVE.L          D0, VDP_CTRL
    MOVE.W          #%0000000011101110, VDP_DATA

    MOVE.L          #$C0040000, D0
    MOVE.L          D0, VDP_CTRL
    MOVE.W          #%0000111011100000, VDP_DATA

    MOVE.L          #$C0060000, D0
    MOVE.L          D0, VDP_CTRL
    MOVE.W          #%1111111111111111, VDP_DATA

    MOVE.L          #$C01E0000, D0
    MOVE.L          D0, VDP_CTRL
    MOVE.W          #%0000000011101110, VDP_DATA

    LEA             FONT, A1
    MOVE.L          #FONT_END-FONT, D6
    MOVE.L          #VDP_CMD_VRAM_WRITE, (VDP_CTRL)

INIT_FONT:
    MOVE.B          (A1)+, D0
    MOVEQ.L         #7, D5
    CLR.L           D1

FONT_NEXT_BIT:
    ROL.L           #3, D1
    ROXL.B          #1, D0
    ROXL.L          #1, D1
    DBRA            D5, FONT_NEXT_BIT

    MOVE.L          D1, D0
    ROL.L           #1, D1
    OR.L            D0, D1

    MOVE.L          D1, (VDP_DATA)
    DBRA            D6, INIT_FONT

    MOVE.W          #$8144, (VDP_CTRL)

    LEA             MESSAGE, A3
    JSR             PRINT_STRING

    JMP             *

MESSAGE:
    DC.B            'HARRY CLARK - SEGA MD SHELL', 255
    even

PRINT_CHAR:
    MOVEM.L         D0-D7/A0-A7, -(SP)
    AND.L           #$FF, D0
    SUB             #32, D0

    MOVE.L          #$40000003, D5
    CLR.L           D4

    MOVE.B          (FONT_POS_Y), D4 
    ROL.L           #8, D4
    ROL.L           #8, D4
    ROL.L           #7, D4
    ADD.L           D4, D5
    
    MOVE.B          (FONT_POS_X), D4
    ROL.L           #8, D4
    ROL.L           #8, D4
    ROL.L           #1, D4
    ADD.L           D4, D5

    MOVE.L          D5, (VDP_CTRL)
    MOVE.W          D0, (VDP_DATA)

    ADDQ.B          #1, (FONT_POS_X)
    MOVE.B          (FONT_POS_X), D0
    CMP.B           #39, D0
    BEQ             NEW_LINE
    

PRINT_STRING:
    MOVE.B          (A3)+,D0
    CMP.B           #255, D0
    BEQ             PRINT_FIN
    JSR             PRINT_CHAR
    BRA             PRINT_STRING

PRINT_FIN: 
    RTS

NEW_LINE:
    ADDQ.B          #1, (FONT_POS_Y)
    CLR.B           (FONT_POS_X)
    RTS



;--------------------------------------------------------
;           INITIALISE THE PALETTE INTO CRAM
;--------------------------------------------------------

PALETTE_DATA:
    DC.W            $0EEE, $0000, $0EEE, $0000, $0EEE, $0000, $0EEE, $0000
    DC.W            $0EEE, $0000, $0EEE, $0000, $0EEE, $0000, $0EEE, $0000
    DC.W            $0EEE, $0000, $0EEE, $0000, $0EEE, $0000, $0EEE, $0000
    DC.W            $0EEE, $0000, $0EEE, $0000, $0EEE, $0000, $0EEE, $0000

ROM_END:
