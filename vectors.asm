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


HW_CHECK:
    MOVEQ           #$F, D7
    AND.B           $A10001-$A11100(A3), D7     ;; ACCESS HARDWARE REV
    BEQ.S           HW_DONE                    ;; BRANCH ASSUMING THAT THE RESULT IS EQUAL TO THE AND COMPARISON (SEE: main.asm)
    MOVE.L          #'SEGA', $A14000             ;; CHECK FOR SEGA CHAR IN ORDER TO INIT VDP

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
