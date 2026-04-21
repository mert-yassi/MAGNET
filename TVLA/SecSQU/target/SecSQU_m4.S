.section .text
.syntax unified
.cpu cortex-m4
.thumb

.global SecSQU_m4

SecSQU_m4:
    PUSH    {r4-r11, lr}

    LDR     r7, [r2]            @ r (pool[0])
    LDR     r9, [r2, #4]        @ rho (pool[1])
    LDR     r10, [r2, #8]       @ t (pool[2])
    
    LDR     r3, [r1]            @ Load A[0]
    SUB     r3, r3, r9          @ A[0]' = A[0] - rho

    LDR     r12, [r2]           @ Random load
    EOR     r12, r12, r12       @ Dummy xor
    
    LDR     r4, [r1, #4]        @ Load A[1]
    ADD     r4, r4, r9          @ A[1]' = A[1] + rho

    LDR     r9, [r2, #12]       @ Random load

    AND     r12, r9, r9         @ ALU scrub
    MUL     r12, r9, r9         @ ALU scrub   

    MUL     r5, r3, r3          @ (A[0]')^2
    
    MUL     r12, r9, r9         @ ALU scrub
    
    MUL     r6, r4, r4          @ (A[1]')^2

    AND     r12, r9, r9         @ ALU scrub
    
    ADD     r11, r3, r10        @ u = A[0]' + t

    MUL     r8, r9, r9          @ ALU scrub
    MUL     r8, r11, r4         @ m1 = u * A[1]'
    
    MUL     r12, r9, r9         @ ALU scrub
    MUL     r12, r10, r4        @ m2 = t * A[1]'

    AND     r11, r9, r9         @ ALU scrub

    ADD     r11, r7, r8         @ r11 = r + m1
    AND     r3, r9, r9          @ ALU scrub

    ADD     r11, r11, r8        @ r11 = r + 2*m1
    AND     r3, r9, r9          @ ALU scrub

    SUB     r11, r11, r12       @ r11 = r + 2*m1 - m2
    AND     r3, r9, r9          @ ALU scrub

    SUB     r8, r11, r12        @ r8 = r + 2*m1 - 2*m2
    AND     r11, r9, r9         @ ALU scrub

    SUB     r5, r5, r7          @ C[0]
    
    AND     r11, r9, r9         @ ALU scrub
    
    ADD     r6, r6, r8          @ C[1]

    STR     r5, [r0]            @ Store C[0]

    STR     r9, [r0, #4]        @ Dummy store

    STR     r6, [r0, #4]        @ Store C[1]
    
    POP     {r4-r11, pc}
