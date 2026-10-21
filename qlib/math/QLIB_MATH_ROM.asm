; QLIB_MATH v0.1 / CPC6128 - standalone prototype upper ROM
; Primitive calls are INTERNAL until a bank-switch ABI has been validated.
; Copyright project contributors. MIT.
        ORG #C000
        DB 1,0,1,0
        DW QLIB_NAMES
        JP QLIB_INIT
        JP QLIB_INFO
        JP QLIB_SELFTEST
QLIB_NAMES:
        DB 'QLIB','M'+#80
        DB 'MTES','T'+#80
        DB 0
QLIB_INIT:
        SCF
        RET
QLIB_INFO:
        ; Return version in HL, no service-address ABI promised.
        LD HL,#0001
        RET

; Fixed public diagnostic entry: CALL #C040 from RAM, C=service ID.
; C=0 ADD_U8 (A,B -> A), 1 MUL_U8 (A,B -> HL),
; C=2 DIVMOD_U8 (H,L -> A quotient, B remainder),
; C=3 ISQRT_U16 (HL -> A), 4 LCG16_STEP (HL -> HL).
; Changing this ABI requires incrementing the interface version.
        DEFS #C040-$,#FF
QLIB_MATH_API:
        LD E,A
        LD A,C
        OR A
        JR Z,API_ADD
        CP 1
        JR Z,API_MUL
        CP 2
        JR Z,API_DIV
        CP 3
        JR Z,API_SQRT
        CP 4
        JR Z,API_RND
        SCF
        RET
API_ADD:
        LD A,E
        JP ADD_U8
API_MUL:
        LD A,E
        JP MUL_U8
API_DIV:
        JP DIVMOD_U8
API_SQRT:
        JP ISQRT_U16
API_RND:
        JP LCG16_STEP

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


; RSX |MTEST: execute real ROM routines and print results with firmware.
; Reports one line per routine. A BASIC caller invokes |MTEST.
QLIB_SELFTEST:
        LD HL,TITLE_MSG
        CALL PRINT_Z
        LD A,12
        LD B,34
        LD C,0
        CALL QLIB_MATH_API
        CP 46
        LD HL,ADD_MSG
        CALL TEST_RESULT

        LD A,13
        LD B,17
        LD C,1
        CALL QLIB_MATH_API
        LD A,H
        OR A
        JR NZ,MUL_BAD
        LD A,L
        CP 221
        JR Z,MUL_GOOD
MUL_BAD:
        OR A
        JR TEST_MUL_SHOW
MUL_GOOD:
        SCF
TEST_MUL_SHOW:
        LD HL,MUL_MSG
        CALL TEST_CARRY

        LD H,100
        LD L,7
        LD C,2
        CALL QLIB_MATH_API
        CP 14
        JR NZ,DIV_BAD
        LD A,B
        CP 2
        JR NZ,DIV_BAD
        SCF
        JR DIV_SHOW
DIV_BAD:
        OR A
DIV_SHOW:
        LD HL,DIV_MSG
        CALL TEST_CARRY

        LD HL,144
        LD C,3
        CALL QLIB_MATH_API
        CP 12
        LD HL,SQRT_MSG
        CALL TEST_RESULT

        LD HL,100
        LD C,4
        CALL QLIB_MATH_API
        LD A,H
        CP 1
        JR NZ,RND_BAD
        LD A,L
        CP 245
        JR NZ,RND_BAD
        SCF
        JR RND_SHOW
RND_BAD:
        OR A
RND_SHOW:
        LD HL,RND_MSG
        CALL TEST_CARRY
        RET

; TEST_RESULT: compare flags Z from CP immediately preceding call.
TEST_RESULT:
        SCF
        JR Z,TEST_CARRY
        OR A
TEST_CARRY:
        PUSH AF
        CALL PRINT_Z
        POP AF
        LD HL,FAIL_MSG
        JR NC,TR_PRINT
        LD HL,PASS_MSG
TR_PRINT:
        CALL PRINT_Z
        RET
PRINT_Z:
        LD A,(HL)
        OR A
        RET Z
        PUSH HL
        CALL #BB5A
        POP HL
        INC HL
        JR PRINT_Z
TITLE_MSG: DB 13,10,'QLIB MATH ROM SELFTEST',13,10,0
ADD_MSG: DB 'ADD8 12+34: ',0
MUL_MSG: DB 'MUL8 13*17: ',0
DIV_MSG: DB 'DIV8 100/7: ',0
SQRT_MSG: DB 'SQRT 144: ',0
RND_MSG: DB 'LCG16 100: ',0
PASS_MSG: DB 'PASS',13,10,0
FAIL_MSG: DB 'FAIL',13,10,0

        DEFS #10000-$,#FF
