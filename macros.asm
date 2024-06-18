;--------------------------------------------------------
;           COPYRIGHT (C) HARRY CLARK 2024
;--------------------------------------------------------
;           SEGA MEGA DRIVE SHELL UTILITY
;--------------------------------------------------------

;--------------------------------------------------------
;       THIS FILE PERTAINS TOWARDS THE DECLARATION OF
;    MACROS THAT WILL BE OF USE TO THE SPECIFIC USE CASE
;                       OF THIS PROGRAM
;--------------------------------------------------------

VDP_DATA            EQU         $C00000
VDP_CTRL            EQU         $C00004

;--------------------------------------------------------
;       ADDRESSABLE HEADER ARGUMENTS FOR RETURNING
;       BITWISE VALUES FOR ERROR HANDLING 
;--------------------------------------------------------


ADDRESS_ERROR_FLAG      EQU     $01
SR_USP_ERROR_FLAG       EQU     $02

EXCE_DEFAULT            EQU     0
EXCE_RETURN             EQU     $20
EXCE_REG_BUFFER         EQU     $40
EXCE_ALIGN_OFFSET       EQU     $80

ERROR_SP_BUFFER         DS.L    1
ERROR_TYPE              DS.B    1

;--------------------------------------------------------
;               GLOBAL PRINT SEMANTIC
;       WORKS ON THE BASIS OF INCREMENTING THE BYTE
;       OF EACH CHARACTER TO PRINT TO SCREEN
;--------------------------------------------------------

PRINT_STDERR:           MACRO       STRING, FLAGS
    JSR                 ERROR_HANDLER(PC)
    DC.B                \STRING, 0
    even
    JMP                 ERROR_HANDLER_EXT(PC)
    ENDM

ERROR_HANDLER:          
        MOVE            #$2700, SR                      ;; DISABLE INTERRUPTS BASED ON CURRENT SR OFFSET
        MOVEM.L         D0-D6, -(SP)

ERROR_HANDLER_EXT:      
    MOVEM.L             D0-D6, -(SP)
    MOVE.W              #0, -(SP)

@MAIN_LOOP:
    LEA                 VDP_CTRL, A5
    LEA                 -4(A5), A6

    BEQ.S               @MAIN_LOOP
