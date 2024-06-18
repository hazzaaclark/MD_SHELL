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
;       THIS VRAM MACRO COROUTINE WILL LOOK TO 
;   DETERMINE IF THERE IS A VALID OFFSET MASK WITHIN
;       A MAX VALUE RELATED TO THE REGISTERS
;
;   THIS WILL SET A VALID VRAM ADDRESS TO THE VDP CTRL PORT
;                       USING DMA
;
;           THIS ROUTINE IS SIMILAR TO SONIC 1
;--------------------------------------------------------

VRAM:               MACRO LOCATION, CONTROL
                    IF("controlport"=="")
                    MOVE.L  #($40000000+(((LOCATION)&$3FFF)<<16)+(((LOCATION)&VDP_DATA)>>14)),(VDP_CTRL).L
                    ELSE
                    MOVE.L  #($40000000+(((LOCATION)&$3FFF)<<16)+(((LOCATION)&VDP_DATA)>>14)),CONTROL
                    ENDIF
                    ENDM

;--------------------------------------------------------
;       ADDRESSABLE HEADER ARGUMENTS FOR RETURNING
;       BITWISE VALUES FOR ERROR HANDLING 
;--------------------------------------------------------

ERROR_FONT:             INCBIN      "text.bin"          ;; THANKS SONIC 1
ERROR_HANDLER_FONT:     EQU     $7C0    
ERROR_TILE_SIZE:        EQU     8*8/2

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
;
;       THIS IS RETOOLED TO FORCEABLY INJECT
;       THE ERROR MESSAGE INTO THE VDP'S DMA
;--------------------------------------------------------

PRINT_STDERR:
    LEA             (VDP_DATA).L, A6
    VRAM            ERROR_HANDLER_FONT*ERROR_TILE_SIZE
    LEA             

PRINT_STDERR_VALUE:


;--------------------------------------------------------
;   SHOW THE CURRENT ALLOCATED ERROR IN THE BUFFER
;   THIS IS SO THAT THE ERROR HANDLER IS ABLE TO
;   PROPERLY ALLOCATE THE ERROR INTO THE STACK
;--------------------------------------------------------

ERROR_ALLOC_IN_BUFFER:
    ADDQ.W              #2, SP
    MOVE.L              (SP)+,(ERROR_SP_BUFFER).W
    ADDQ.W              #2, SP
    MOVEM.L             D0-D7, (EXCE_REG_BUFFER).W
    BSR.W               PRINT_STDERR
    MOVE.K              2(SP), D0
    BSR

@MAIN_LOOP:
    LEA                 VDP_CTRL, A5
    LEA                 -4(A5), A6

    BEQ.S               @MAIN_LOOP
