.section .text
.syntax unified
.cpu cortex-m4
.thumb

.global MaskedLaplace_m4
.extern MaskedBernoulli_m4
.extern MaskedGeometric_m4
.extern SecNEG_m4
.extern SecINC_m4

.equ INC_RC_BERN, 16
.equ INC_PC_BERN, 32
.equ INC_PC_GEO, 40
.equ INC_PC_NEG, 20
.equ INC_PC_INC, 20

.equ STACK_ALLOC, 12

MaskedLaplace_m4:
    PUSH    {r4-r11, lr}
    SUB     sp, sp, #STACK_ALLOC

    LDR     r8, [sp, #48]
    LDR     r7, [sp, #52]

    MOV     r4, r0
    MOV     r5, r1
    MOV     r6, r2
    MOV     r10, r3

    MOV     r0, r4
    MOV     r1, r5
    MOV     r2, r10
    MOV     r3, r8
    STR     r7, [sp]
    BL      MaskedBernoulli_m4

    ADD     r8, r8, #INC_RC_BERN
    ADD     r7, r7, #INC_PC_BERN

    LDR     r9, [r4]

    LDR     r12, [r7, #4]

    LDR     r11, [r4, #4]

    LDR     r12, [r7]

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

    LDR     r12, [r7]

    LDR     r5, [r4]

    NOP
    
    LDR     r6, [r4, #4]

    MVN     r9, r9
    NOP
    EOR     r12, r12, r12

    STR     r9, [sp, #4]

    NOP
    LDR     r12, [r7]

    STR     r11, [sp, #8]
    NOP
    
    ADD     r0, sp, #4
    ADD     r1, sp, #4
    MOV     r2, r7
    BL      SecNEG_m4

    ADD     r7, r7, #INC_PC_NEG

    LDR     r12, [r7]

    STR     r5, [r4]
 
    STR     r6, [r4, #4]

    NOP
    LDR     r12, [r7]

    MOV     r0, r4
    MOV     r1, r4
    MOV     r2, r10
    MOV     r3, r7
    
    BL      SecINC_m4

    ADD     r7, r7, #INC_PC_INC

    LDR     r12, [r7]
    
    LDR     r5, [r4]
    LDR     r12, [r7, #-4]
    LDR     r6, [r4, #4]
    
    LDR     r12, [r7, #-8]
    LDR     r9, [sp, #4]
    
    LDR     r12, [r7, #-12]
    LDR     r10, [sp, #8]
    
    LDR     r8, [r7]

    AND     r0, r5, r9
    EOR     r12, r12, r12

    AND     r1, r6, r10
    EOR     r12, r12, r12

    AND     r2, r5, r10
    EOR     r12, r12, r12

    AND     r3, r6, r9
    EOR     r12, r12, r12

    EOR     r2, r8, r2
    EOR     r12, r12, r12

    EOR     r2, r3, r2
    EOR     r12, r12, r12

    EOR     r0, r0, r8
    EOR     r12, r12, r12

    EOR     r1, r1, r2
    EOR     r12, r12, r12

    LDR     r3, [r7, #-16]
    EOR     r0, r0, r3
    EOR     r12, r12, r12
    EOR     r1, r1, r3
    EOR     r12, r12, r12

    STR     r0, [r4]
    LDR     r12, [r7, #-20]
    STR     r1, [r4, #4]
    
    LDR     r12, [r7, #-24]
    LDR     r8,  [r7, #-28]
    
    STR     r12, [sp, #4]       
    STR     r8,  [sp, #8]       
    
    MOV     r0, r12             
    MOV     r2, r12             
    MOV     r5, r12             
    MOV     r9, r12             
    
    MOV     r1, r8              
    MOV     r3, r8              
    MOV     r6, r8              
    MOV     r10, r8             
    MOV     r11, r8
    
    ADD     sp, sp, #STACK_ALLOC
    POP     {r4-r11, pc}
