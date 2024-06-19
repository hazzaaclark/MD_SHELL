;--------------------------------------------------------
;           COPYRIGHT (C) HARRY CLARK 2024
;--------------------------------------------------------
;           SEGA MEGA DRIVE SHELL UTILITY
;--------------------------------------------------------

;--------------------------------------------------------
;      THIS FILE PERTAINS TOWARDS THE DECLARATION 
;   OF SETTINGS PERTAINING TOWARDING THE VDP AND OTHER
;           RELEVANT AREAS OF CONCENTRATION 
;--------------------------------------------------------

            INCLUDE "macros.asm"

VDP_CMD_VRAM_WRITE          EQU         $40000000
VDP_CMD_CRAM_WRITE          EQU         $C0000000
VRAM_ADDR_TILES             EQU         $0000
VRAM_ADDR_PLANE_A           EQU         $C000
VRAM_ADDR_PLANE_B           EQU         $E000
VDP_SCREEN_WIDTH            EQU         $0140
VDP_SCREEN_HEIGHT           EQU         $00F0
VDP_PLANE_WIDTH             EQU         $40
VDP_PLANE_HEIGHT            EQU         $20

VDP_SETTINGS:               
    DC.B            $04
    DC.B            $04
    DC.B            $30
    DC.B            $3C
    DC.B            $07
    DC.B            $6C
    DC.B            $00
    DC.B            $00
    DC.B            $00
    DC.B            $00
    DC.B            $FF
    DC.B            $00
    DC.B            $81
    DC.B            $37
    DC.B            $00
    DC.B            $02
    DC.B            $01
    DC.B            $00
    DC.B            $00
    DC.B            $FF
    DC.B            $FF
    DC.B            $00
    DC.B            $00
    DC.B            $80

FONT:
    INCBIN "text.bin"