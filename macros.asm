;--------------------------------------------------------
;           COPYRIGHT (C) HARRY CLARK 2024
;--------------------------------------------------------
;           SEGA MEGA DRIVE SHELL UTILITY
;--------------------------------------------------------

GLOBAL      MACRO
            \symbol
            XDEF \symbol
            ENDM

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

EXTERN_VRAM:        MACRO LOCATION, CONTROL
                    IF CONTROL == ""
                    MOVE.L  #($40000000+(((LOCATION)&$3FFF)<<16)+(((LOCATION)&VDP_DATA)>>14)),(VDP_CTRL).L
                    ELSE
                    MOVE.L  #($40000000+(((LOCATION)&$3FFF)<<16)+(((LOCATION)&VDP_DATA)>>14)),CONTROL
                    ENDIF
                    ENDM    

;--------------------------------------------------------
;       ADDRESSABLE HEADER ARGUMENTS FOR RETURNING
;       BITWISE VALUES FOR ERROR HANDLING 
;--------------------------------------------------------

ERROR_HANDLER_FONT:     EQU     $7C0    
ERROR_TILE_SIZE:        EQU     8*8/2

ADDRESS_ERROR_FLAG      EQU     $01
SR_USP_ERROR_FLAG       EQU     $02

EXCE_DEFAULT            EQU     0
EXCE_RETURN             EQU     $20
EXCE_REG_BUFFER         EQU     $40
EXCE_ALIGN_OFFSET       EQU     $80
ERROR_TYPE              EQU     1
