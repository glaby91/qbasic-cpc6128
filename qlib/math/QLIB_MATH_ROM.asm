; QLIB_MATH v0.1 / CPC6128 - standalone prototype upper ROM
; Primitive calls are INTERNAL until a bank-switch ABI has been validated.
; Copyright project contributors. MIT.
        ORG #C000
        DB 1,0,1,0
        DW QLIB_NAMES
        JP QLIB_INIT
        JP QLIB_INFO
QLIB_NAMES:
        DB 'QLIB','M'+#80
        DB 0
QLIB_INIT:
        SCF
        RET
QLIB_INFO:
        ; Return version in HL, no service-address ABI promised.
        LD HL,#0001
        RET

; Registers/flags are specified per primitive.
; ADD_U8: A+B -> A; carry flags ordinary Z80 arithmetic.
ADD_U8:
        ADD A,B
        RET
SUB_U8:
        SUB B
        RET
; MUL_U8: H=0, L=A*B low, A=high; destroys B,C,D,E.
; Unsigned full 16-bit product in HL.
MUL_U8:
        LD E,A
        LD D,0
        LD HL,0
        LD C,8
MU8_LOOP:
        SRL B
        JR NC,MU8_SKIP
        ADD HL,DE
MU8_SKIP:
        SLA E
        RL D
        DEC C
        JR NZ,MU8_LOOP
        RET

; DIVMOD_U8: H=dividend, L=divisor; returns A=quotient, B=remainder.
; Carry set on divisor=0 (results undefined); destroys C,D,E.
DIVMOD_U8:
        LD A,L
        OR A
        SCF
        RET Z
        LD E,L
        LD D,H
        LD C,0
DU8_LOOP:
        LD A,D
        CP E
        JR C,DU8_DONE
        SUB E
        LD D,A
        INC C
        JR DU8_LOOP
DU8_DONE:
        LD A,C
        LD B,D
        OR A
        RET

; ADD_I16: HL+DE -> HL, flags ordinary ADD HL,DE (carry unsigned).
ADD_I16:
        ADD HL,DE
        RET
; SUB_I16: HL-DE -> HL, standard borrow carry from SBC.
SUB_I16:
        OR A
        SBC HL,DE
        RET
; ABS_I16: signed HL -> magnitude HL, carry on -32768 (unrepresentable signed).
ABS_I16:
        BIT 7,H
        JR Z,ABS_I16_OK
        LD A,H
        CP #80
        JR NZ,ABS_I16_NEG
        LD A,L
        OR A
        JR NZ,ABS_I16_NEG
        SCF
        RET
ABS_I16_NEG:
        XOR A
        SUB L
        LD L,A
        LD A,0
        SBC A,H
        LD H,A
ABS_I16_OK:
        OR A
        RET
; SGN_I16: HL signed -> A = FF(-1), 00, 01.
SGN_I16:
        LD A,H
        OR L
        RET Z
        BIT 7,H
        JR Z,SGN_POS
        LD A,#FF
        RET
SGN_POS:
        LD A,1
        RET

; ISQRT_U16: floor(sqrt(HL)), result A (0..255).
; Non-restoring variant using 8 bit-pairs. DE=input remainder; BC=trial.
; For now simple bounded subtraction; correctness before speed.
ISQRT_U16:
        LD DE,1
        LD B,0
SQ_LOOP:
        OR A
        SBC HL,DE
        JR C,SQ_DONE
        INC B
        INC DE
        INC DE
        JR SQ_LOOP
SQ_DONE:
        LD A,B
        RET

; LCG16_STEP: HL=state; state := (5*state+1) modulo 65536.
; Deterministic PRNG primitive, NOT yet QBX RND semantics.
LCG16_STEP:
        LD D,H
        LD E,L
        ADD HL,HL
        ADD HL,HL
        ADD HL,DE
        INC HL
        RET

        DEFS #10000-$,#FF
