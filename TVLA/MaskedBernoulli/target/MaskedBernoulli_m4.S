.section .text
.syntax unified
.cpu cortex-m4
.thumb

.global MaskedBernoulli_m4

@ Params: R0=x, R1=p, R2=one, R3=rs, [SP]=pool
MaskedBernoulli_m4:
    PUSH    {r4-r11, lr}
    LDR     r7, [sp, #36]       @ R7 = pool ptr
    MOV     r4, r0              @ R4 = x
    MOV     r5, r1              @ R5 = p
    MOV     r6, r3              @ R6 = rs
    SUB     sp, sp, #24         @ Stack
    MOV     r9, sp              @ R9 = buffers base
    
    LDR     r10, [r2]           @ Load one[0]
    LDR     r12, [r7]           @ Load Random
    LDR     r11, [r2, #4]       @ Load one[1]
    
    STR     r10, [r4]           @ Store x[0]
    LDR     r12, [r7]           @ Load Random
    STR     r12, [r7, #-4]      @ Dummy Store
    STR     r11, [r4, #4]       @ Store x[1]
    
    EOR     r10, r10, r10
    EOR     r11, r11, r11
    MOV     r8, #1              @ Loop counter (mu-1)

loop_start:
    @ ----------------------------------------------------------
    @ Step 1: Calculate t = p ^ r
    @ ----------------------------------------------------------
    LDR     r10, [r6], #4       @ r[0]
    LDR     r12, [r7]           @ DUMMY LOAD
    LDR     r11, [r6], #4       @ r[1]
    
    LSL     r12, r8, #3         @ Offset
    ADD     r12, r5, r12        @ p_ptr
    
    @ --- SHARE 0 ---
    LDR     r0, [r12]           @ p[0]
    EOR     r0, r0, r10         @ t[0]
    STR     r0, [r9]            @ Store t[0]
    
    MOV     r0, #0              @ Scrub Reg
    LDR     r14, [r7]           @ Load Random
    STR     r14, [r9, #16]      @ Scrub Stack Bus
    
    @ --- SHARE 1 ---
    LDR     r1, [r12, #4]       @ p[1]
    EOR     r1, r1, r11         @ t[1]
    STR     r1, [r9, #4]        @ Store t[1]
    
    @ ----------------------------------------------------------
    @ Step 2: Calculate u = x ^ ~r
    @ ----------------------------------------------------------
    MVN     r10, r10            @ ~r[0]
    
    @ --- SHARE 0 ---
    LDR     r0, [r4]            @ x[0]
    EOR     r0, r0, r10         @ u[0]
    STR     r0, [r9, #8]        @ Store u[0]
    
    MOV     r0, #0              @ Scrub Reg
    LDR     r12, [r7]           @ Load Random
    STR     r12, [r9, #16]      @ Scrub Stack Bus
    
    @ --- SHARE 1 ---
    LDR     r1, [r4, #4]        @ x[1]
    EOR     r1, r1, r11         @ u[1]
    STR     r1, [r9, #12]       @ Store u[1]

    @ Clear registers
    MOV     r0, #0
    MOV     r1, #0
    MOV     r10, #0
    MOV     r11, #0
    
    @ ----------------------------------------------------------
    @ Step 3: SecAND_m4
    @ ----------------------------------------------------------
    ADD     r0, r9, #16         @ v ptr
    MOV     r1, r9              @ t ptr
    ADD     r2, r9, #8          @ u ptr
    MOV     r3, r7              @ pool ptr
    BL      SecAND_m4
    
    ADD     r7, r7, #4          @ pool++

    @ ----------------------------------------------------------
    @ Step 4: Update x
    @ ----------------------------------------------------------

    LDR     r12, [r7]           @ Load Random 
    
    @ --- SHARE 0 ---
    LDR     r0, [r9, #16]       @ Load v[0]

    LDR     r12, [r7]           @ Scrub Read Bus
    LDR     r10, [r4]           @ Load x[0]
    EOR     r10, r10, r0        @ x[0] ^= v[0]

    LDR     r12, [r7]           @ Load Random
    STR     r12, [r4]           @ Scrub x[0]
    
    LDR     r12, [r7]           @ Load Random

    STR     r10, [r4]           @ Store x[0]

    LDR     r12, [r7]           @ Load Random
    STR     r12, [r7, #-4]      @ Dummy Store   
    
    EOR     r10, r10, r10       @ Clear x[0] reg
    MOV     r0, #0              @ Clear v[0] reg

    @ --- SHARE 1 ---
    LDR     r1, [r9, #20]       @ Load v[1]
    LDR     r12, [r7]           @ Load Random
 

    LDR     r0, [r4, #4]        @ Load x[1]
    EOR     r10, r10, r10       @ Dummy xor

    EOR     r0, r0, r1          @ x[1]

    LDR     r12, [r7]           @ Load Random
    STR     r12, [r9, #20]      @ Dummy Store
    
    STR     r0, [r4, #4]        @ Store x[1]

    @ Cleanup
    MOV     r0, #0
    MOV     r1, #0
    
    SUB     r8, r8, #1
    CMP     r8, #0
    BGE     loop_start

    ADD     sp, sp, #24
    POP     {r4-r11, pc}
    
