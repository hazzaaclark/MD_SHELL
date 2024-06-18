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
;               THE FOLLOWING PERTAINS TOWARDS
;   DEFINING SYMBOLS IN A SIMILAR VEIN TO USING EXTERN
;--------------------------------------------------------

GLOBAL_DEF:          EQU         1

ASM_EXTERN      MACRO   *
                if(GLOBAL_DEF)=0
                endif
                ENDM

;--------------------------------------------------------
;       ADDRESSABLE HEADER ARGUMENTS FOR RETURNING
;       BITWISE VALUES FOR ERROR HANDLING 
;--------------------------------------------------------


ADDRESS_ERROR_FLAG      EQU     $01
SR_USP_ERROR_FLAG       EQU     $02

EXCE_RETURN             EQU     $20
EXCE_ALIGN_OFFSET       EQU     $80 

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

ERROR_HANDLER:          ASM_EXTERN
        MOVE            #$2700, SR                      ;; DISABLE INTERRUPTS BASED ON CURRENT SR OFFSET
        MOVEM.L         D0-D6, -(SP)

ERROR_HANDLER_EXT:      ASM_EXTERN


