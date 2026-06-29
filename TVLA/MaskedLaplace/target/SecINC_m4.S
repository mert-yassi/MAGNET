@ SecINC Adaptation of order-1 [Gou01]-based SecADD

.section .text
.syntax unified
.cpu cortex-m4
.thumb

.global SecINC_m4

.extern SecA2B_m4
.extern SecB2A_m4
.extern Refresh_m4

@ -----------------------------------------------------------------------------
@ void SecINC_m4(uint32_t *z, const uint32_t *x, const uint32_t *one, const uint32_t *pool)
@ -----------------------------------------------------------------------------

.type SecINC_m4, %function
.thumb_func
SecINC_m4:
    PUSH    {r4-r7, lr}
    SUB     sp, sp, #20         @ 8 bytes temp + scratch, keeps stack 8-byte aligned

    MOV     r4, r0              @ z_ptr
    MOV     r5, r1              @ x_ptr
    MOV     r6, r3              @ pool base

    @ -------------------------------------------------------------------------
    @ Step 1: Boolean -> Arithmetic
    @ Uses pool[0]
    @ -------------------------------------------------------------------------
    MOV     r0, sp              @ dst arithmetic temp
    MOV     r1, r5              @ src Boolean input
    MOV     r2, r6              @ pool base
    BL      SecB2A_m4

    @ -------------------------------------------------------------------------
    @ Step 2: increment arithmetic share 0
    @ Use in-frame scratch instead of [sp, #-4].
    @ -------------------------------------------------------------------------
    LDR     r0, [sp, #0]        @ arithmetic share 0

    LDR     r12, [r6, #16]      @ random/dummy word inside reserved INC window
    STR     r12, [sp, #8]       @ in-frame dummy store

    ADD     r0, r0, #1
    STR     r0, [sp, #0]

    LDR     r12, [r6, #16]
    STR     r12, [sp, #12]      @ in-frame dummy store

    @ -------------------------------------------------------------------------
    @ Step 3: Arithmetic -> Boolean
    @ Pass pool + 4 to SecA2B.
    @ SecA2B consumes pool+4 and scratches pool+8, so avoid using pool+8 later.
    @ -------------------------------------------------------------------------
    MOV     r0, r4              @ dst Boolean output
    MOV     r1, sp              @ src arithmetic temp
    ADD     r2, r6, #4          @ pool for SecA2B
    BL      SecA2B_m4

    @ -------------------------------------------------------------------------
    @ Step 4: Refresh output before returning.
    @ Refresh_m4 preserves z[0] ^ z[1].
    @ -------------------------------------------------------------------------
    MOV     r0, r4              @ output z
    ADD     r1, r6, #12         @ fresh word inside reserved INC window
    BL      Refresh_m4

    @ -------------------------------------------------------------------------
    @ Cleanup local arithmetic temp and caller-saved regs.
    @ -------------------------------------------------------------------------
    LDR     r12, [r6, #16]
    STR     r12, [sp, #0]
    STR     r12, [sp, #4]
    STR     r12, [sp, #8]
    STR     r12, [sp, #12]
    STR     r12, [sp, #16]

    EOR     r0, r0, r0
    EOR     r1, r1, r1
    EOR     r2, r2, r2
    EOR     r3, r3, r3
    EOR     r12, r12, r12

    ADD     sp, sp, #20
    POP     {r4-r7, pc}
