.section .text
.syntax unified
.cpu cortex-m4
.thumb

.global SecINC_m4

.extern SecAB_m4
.extern SecBA_m4

@ -----------------------------------------------------------------------------
@ void SecINC_m4(uint32_t *z, const uint32_t *x, const uint32_t *one, const uint32_t *pool)
@ -----------------------------------------------------------------------------
SecINC_m4:
    PUSH    {r4-r6, lr}
    SUB     sp, sp, #8      @ Allocate 8 bytes for intermediate Arithmetic Shares

    MOV     r4, r0          @ z_ptr (Output)
    MOV     r5, r1          @ x_ptr (Input)
    MOV     r6, r3          @ pool_ptr

    MOV     r0, sp          @ Arg0: dst (Stack -> Arithmetic Temp)
    MOV     r1, r5          @ Arg1: src (x_ptr -> Boolean Input)
    MOV     r2, r6          @ Arg2: pool
    BL      SecBA_m4        

    ADD     r6, r6, #4

    MOV     r12, #0
    STR     r12, [sp, #-4]

    NOP
    EOR     r12, r12, r12

    LDR     r0, [sp, #0]    @ Load Arithmetic Share 0
 
    MOV     r12, #0
    STR     r12, [sp, #-4]
 
    ADD     r0, r0, #1      @ Increment
    STR     r0, [sp, #0]    @ Store back

    MOV     r12, #0
    STR     r12, [sp, #-4]

    MOV     r0, r4          @ Arg0: dst (z_ptr -> Boolean Output)
    MOV     r1, sp          @ Arg1: src (Stack -> Arithmetic Temp)
    MOV     r2, r6          @ Arg2: pool
 
    BL      SecAB_m4        

    MOV     r0, #0
    STR     r0, [sp, #0]
    STR     r0, [sp, #4]

    ADD     sp, sp, #8
    POP     {r4-r6, pc}
