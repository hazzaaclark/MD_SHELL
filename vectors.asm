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

;--------------------------------------------------------
;   THIS COROUTINE WILL LOOK TO MAKE SURE THAT THE Z80
;   BUS IS ABLE TO COMMUNICATE WITH THE VDP IN ORDER TO INIT
;--------------------------------------------------------

HW_DONE:              
    MOVE.W      D1, (A3)
    MOVE.W      D1, (A4)
    
BUS_ERROR:          
    MOVE.B          #2, (ERROR_TYPE).W     

ADDRESS_ERROR:      
    MOVE.B          #4, (ERROR_TYPE).W

ILLEGAL_INSTR:
    MOVE.B          #6, (ERROR_TYPE).W
    ADDQ.L          #2, 2(SP)

ZERO_DIV:
    MOVE.B          #8, (ERROR_TYPE).W

CHK_INSTR:
    MOVE.B          #$A, (ERROR_TYPE).W

TRAPV_INSTR:
    MOVE.B          #$C, (ERROR_TYPE).W

PRIV_VIOL:
    MOVE.B          #$E, (ERROR_TYPE).W

TRACE:
    MOVE.B          #$10, (ERROR_TYPE).W

LINE_1010:
    MOVE.B          #$12, (ERROR_TYPE).W
    ADDQ.L          #2, 2(SP)

LINE_1111:
    MOVE.B          #$14, (ERROR_TYPE).W
    ADDQ.L          #2, 2(SP)

ERROR_EXCEPT:
    MOVE.B          #0, (ERROR_TYPE).W       

IDLE_INT:           
    RTE

;--------------------------------------------------------
;       THINK OF THIS AS A MAKESHIFT HALT COROUTINE
;   SUCH THAT IF THERE IS NO CONCURRENT INSTRUCTION
;       TRAP WILL LOOK TO STOP CPU EXECUTION
;--------------------------------------------------------

ERROR_TRAP:         
    NOP
    BRA.S   ERROR_TRAP

;--------------------------------------------------------
;       SETUP DIRECTIVES AND VALUES THAT CORRESPOND
;   WITH THE VDP, Z80, INITALISATION OF PORTS, TMSS, ETC
;--------------------------------------------------------

SETUP_VALUES:      

    DC.L            $C00004                 ; VDP CTRL
    DC.L            $A11100                 ; Z80 BUS REQ
    DC.L            $A11200                 ; Z80 RESET
