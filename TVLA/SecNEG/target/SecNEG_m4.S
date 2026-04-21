.section .text
.syntax unified
.cpu cortex-m4
.thumb

.global SecNEG_m4
.extern Refresh_m4

@ -----------------------------------------------------------------------------
@ void SecNEG(uint32_t* z, const uint32_t* x, const uint32_t* pool)
@ Arguments:
@   R0 = z    (Output pointer)
@   R1 = x    (Input pointer)
@   R2 = pool (Randomness pointer)
@ -----------------------------------------------------------------------------
SecNEG_m4:
    PUSH    {r4-r6, lr}
    
    MOV     r4, r0              @ r4 = z
    MOV     r5, r2              @ r5 = pool

    LDR     r3, [r1]            @ Load x[0]
    AND     r3, r3, #1          @ Mask LSB
    RSB     r3, r3, #0          @ Negate: 0 - r3 (0 -> 0, 1 -> -1)
    STR     r3, [r4]            @ Store z[0]

    LDR     r6, [r5]            @ Load Random
    EOR     r3, r3, r6
    NOP
    STR     r6, [r4, #4]
    EOR     r3, r3, r3

    LDR     r3, [r1, #4]        @ Load x[1]
    AND     r3, r3, #1          @ Mask LSB
    RSB     r3, r3, #0          @ Negate
    STR     r3, [r4, #4]        @ Store z[1]

    MOV     r3, #0

    MOV     r0, r4              @ R0 = z
    MOV     r1, r5              @ R1 = pool
    
    BL      Refresh_m4

    POP     {r4-r6, pc}
    
