.section .text
.syntax unified
.cpu cortex-m4
.thumb

.global SecOR_m4
.extern SecAND_m4

SecOR_m4:
    PUSH    {r4-r7, lr}

    MOV     r4, r0          
    MOV     r5, r1          
    MOV     r6, r2          

    LDR     r7, [r5]
    MVN     r7, r7
    STR     r7, [r5]

    LDR     r7, [r6]
    MVN     r7, r7
    STR     r7, [r6]

    MOV     r0, r4          
    MOV     r1, r6          
    MOV     r2, r5          
    BL      SecAND_m4

    LDR     r7, [r5]
    MVN     r7, r7
    STR     r7, [r5]

    LDR     r7, [r6]
    MVN     r7, r7
    STR     r7, [r6]

    LDR     r7, [r4]
    MVN     r7, r7
    STR     r7, [r4]

    POP     {r4-r7, pc}
