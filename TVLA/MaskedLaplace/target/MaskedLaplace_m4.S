.section .text
.syntax unified
.cpu cortex-m4
.thumb

.global MaskedLaplace_m4
.extern MaskedBernoulli_m4
.extern MaskedGeometric_m4
.extern SecNEG_m4
.extern SecINC_m4
.extern SecAND_m4

.equ INC_RC_BERN, 16
.equ INC_PC_BERN, 32
.equ INC_PC_GEO, 40
.equ INC_PC_NEG, 20
.equ INC_PC_INC, 20

@ Stack layout, relative to SP after allocation:
@   [sp, #0]   child stack argument: pool
@   [sp, #4]   b[0]
@   [sp, #8]   b[1]
@   [sp, #12]  mask[0] = -(!b)[0]
@   [sp, #16]  mask[1] = -(!b)[1]
@   [sp, #20]  gp1[0] = (g + 1)[0]
@   [sp, #24]  gp1[1] = (g + 1)[1]
@   [sp, #28]  padding / scratch
.equ STACK_ALLOC, 32
.equ B_OFF,      4
.equ MASK_OFF,   12
.equ GP1_OFF,    20

.type MaskedLaplace_m4, %function
.thumb_func
MaskedLaplace_m4:
    PUSH    {r4-r11, lr}
    SUB     sp, sp, #STACK_ALLOC

    @ Original stack arguments are shifted by PUSH + STACK_ALLOC.
    @ [caller_sp]     = rs
    @ [caller_sp + 4] = pool
    LDR     r8, [sp, #(36 + STACK_ALLOC)]      @ r8 = rs
    LDR     r7, [sp, #(36 + STACK_ALLOC + 4)]  @ r7 = pool

    MOV     r4, r0          @ output z / temporary geometric accumulator
    MOV     r5, r1          @ p_bern
    MOV     r6, r2          @ p_geo
    MOV     r10, r3         @ one

    @ -------------------------------------------------------------------------
    @ Step 1: b <- MaskedBernoulli(...)
    @ Store b in a dedicated stack buffer, not in the final output buffer.
    @ -------------------------------------------------------------------------
    ADD     r0, sp, #B_OFF
    MOV     r1, r5
    MOV     r2, r10
    MOV     r3, r8
    STR     r7, [sp]
    BL      MaskedBernoulli_m4

    ADD     r8, r8, #INC_RC_BERN
    ADD     r7, r7, #INC_PC_BERN

    @ -------------------------------------------------------------------------
    @ Step 2: mask <- -(!b)
    @ Boolean NOT: invert only share 0, then SecNEG expands the LSB to a word mask.
    @ -------------------------------------------------------------------------
    LDR     r0, [sp, #B_OFF]
    MVN     r0, r0
    STR     r0, [sp, #B_OFF]

    ADD     r0, sp, #MASK_OFF      @ z = mask
    ADD     r1, sp, #B_OFF         @ x = !b
    MOV     r2, r7                 @ pool
    BL      SecNEG_m4

    ADD     r7, r7, #INC_PC_NEG

    @ -------------------------------------------------------------------------
    @ Step 3: g <- MaskedGeometric(...)
    @ MaskedGeometric accumulates into its output, so initialize it to zero.
    @ -------------------------------------------------------------------------
    MOV     r0, #0
    STR     r0, [r4]
    STR     r0, [r4, #4]

    MOV     r0, r4
    MOV     r1, r6
    MOV     r2, r10
    MOV     r3, r8
    STR     r7, [sp]
    BL      MaskedGeometric_m4

    ADD     r7, r7, #INC_PC_GEO

    @ -------------------------------------------------------------------------
    @ Step 4: gp1 <- g + 1
    @ -------------------------------------------------------------------------
    ADD     r0, sp, #GP1_OFF       @ z = gp1
    MOV     r1, r4                 @ x = g
    MOV     r2, r10                @ one
    MOV     r3, r7                 @ pool
    BL      SecINC_m4

    ADD     r7, r7, #INC_PC_INC

    @ -------------------------------------------------------------------------
    @ Step 5: z <- gp1 & mask using the tested SecAND gadget.
    @ -------------------------------------------------------------------------
    MOV     r0, r4                 @ z = output
    ADD     r1, sp, #MASK_OFF      @ y = mask
    ADD     r2, sp, #GP1_OFF       @ x = gp1
    MOV     r3, r7                 @ pool
    BL      SecAND_m4

    ADD     sp, sp, #STACK_ALLOC
    POP     {r4-r11, pc}
