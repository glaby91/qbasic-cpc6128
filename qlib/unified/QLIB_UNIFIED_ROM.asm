; QLIB UNIFIED MATH v0.4.0 — CPC6128 ROM ; startup-safe RSX |MALLTEST
        ORG #C000
        DB 1,0,4,0
        DW RSX_NAMES
        JP ROM_INIT
        JP RUN_TESTS
RSX_NAMES:
        DB 'QLIB','M'+#80
        DB 'MALLTES','T'+#80
        DB 0
ROM_INIT:
        SCF
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



; QLIB_MATRIX 0.1: signed 8x8 -> signed 16 multiply
; Inputs: A=signed coefficient, B=signed component
; Output HL signed 16 product. Clobbers A,B,C,D,E, flags.
MAT_MUL_S8:
        LD C,0
        BIT 7,A
        JR Z,MM_A_POS
        NEG
        INC C
MM_A_POS:
        BIT 7,B
        JR Z,MM_B_POS
        LD D,A
        LD A,B
        NEG
        LD B,A
        LD A,D
        LD D,C
        LD C,1
        LD E,A
        LD A,D
        XOR 1
        LD C,A
        LD A,E
MM_B_POS:
        LD E,A
        LD D,0
        LD HL,0
        LD A,8
MM_LOOP:
        SRL B
        JR NC,MM_NOADD
        ADD HL,DE
MM_NOADD:
        SLA E
        RL D
        DEC A
        JR NZ,MM_LOOP
        BIT 0,C
        RET Z
        XOR A
        SUB L
        LD L,A
        LD A,0
        SBC A,H
        LD H,A
        RET

; MAT2_VEC_S8: IX -> 4 signed coefficients row-major
; IY -> signed x,y, DE -> destination: 2 signed 16-bit results
; clobbers AF,BC,DE,HL, IX/IY preserved.
MAT2_VEC_S8:
        PUSH DE
        LD A,(IX+0)
        LD B,(IY+0)
        CALL MAT_MUL_S8
        PUSH HL
        LD A,(IX+1)
        LD B,(IY+1)
        CALL MAT_MUL_S8
        POP DE
        ADD HL,DE
        POP DE
        LD A,L
        LD (DE),A
        INC DE
        LD A,H
        LD (DE),A
        INC DE
        PUSH DE
        LD A,(IX+2)
        LD B,(IY+0)
        CALL MAT_MUL_S8
        PUSH HL
        LD A,(IX+3)
        LD B,(IY+1)
        CALL MAT_MUL_S8
        POP DE
        ADD HL,DE
        POP DE
        LD A,L
        LD (DE),A
        INC DE
        LD A,H
        LD (DE),A
        RET

; Matrix 3x3 and Q8.8: next development tranche after tests.



; MUL16_LO: unsigned 16x16 -> low 16 bits HL (mod 65536).
; Entry HL=x, DE=y. Clobbers AF,BC,DE. No overflow indication.
MUL16_LO:
        LD B,H
        LD C,L
        LD HL,0
        LD A,16
M16_LOOP:
        SRL D
        RR E
        JR NC,M16_SKIP
        ADD HL,BC
M16_SKIP:
        SLA C
        RL B
        DEC A
        JR NZ,M16_LOOP
        RET

; MAT23_VEC_S8: IX -> 6 signed bytes [a,b,tx,c,d,ty],
; IY -> signed x,y; DE -> 2 signed 16-bit outputs.
MAT23_VEC_S8:
        PUSH DE
        LD A,(IX+0)
        LD B,(IY+0)
        CALL MAT_MUL_S8
        PUSH HL
        LD A,(IX+1)
        LD B,(IY+1)
        CALL MAT_MUL_S8
        POP DE
        ADD HL,DE
        LD A,(IX+2)
        LD E,A
        LD D,0
        BIT 7,E
        JR Z,M23_TXPOS
        DEC D
M23_TXPOS:
        ADD HL,DE
        POP DE
        LD A,L
        LD (DE),A
        INC DE
        LD A,H
        LD (DE),A
        INC DE
        PUSH DE
        LD A,(IX+3)
        LD B,(IY+0)
        CALL MAT_MUL_S8
        PUSH HL
        LD A,(IX+4)
        LD B,(IY+1)
        CALL MAT_MUL_S8
        POP DE
        ADD HL,DE
        LD A,(IX+5)
        LD E,A
        LD D,0
        BIT 7,E
        JR Z,M23_TYPOS
        DEC D
M23_TYPOS:
        ADD HL,DE
        POP DE
        LD A,L
        LD (DE),A
        INC DE
        LD A,H
        LD (DE),A
        RET

; MAT3_VEC_S8: 3x3 signed byte matrix at IX (row-major),
; signed 3-vector at IY. DE -> 3 signed 16-bit outputs.
; Accumulates each row in signed 16 bits.
MAT3_VEC_S8:
        PUSH DE
        LD A,(IX+0)
        LD B,(IY+0)
        CALL MAT_MUL_S8
        PUSH HL
        LD A,(IX+1)
        LD B,(IY+1)
        CALL MAT_MUL_S8
        POP DE
        ADD HL,DE
        PUSH HL
        LD A,(IX+2)
        LD B,(IY+2)
        CALL MAT_MUL_S8
        POP DE
        ADD HL,DE
        POP DE
        LD A,L
        LD (DE),A
        INC DE
        LD A,H
        LD (DE),A
        INC DE
        PUSH DE
        POP DE
        PUSH DE
        LD A,(IX+3)
        LD B,(IY+0)
        CALL MAT_MUL_S8
        PUSH HL
        LD A,(IX+4)
        LD B,(IY+1)
        CALL MAT_MUL_S8
        POP DE
        ADD HL,DE
        PUSH HL
        LD A,(IX+5)
        LD B,(IY+2)
        CALL MAT_MUL_S8
        POP DE
        ADD HL,DE
        POP DE
        LD A,L
        LD (DE),A
        INC DE
        LD A,H
        LD (DE),A
        INC DE
        PUSH DE
        POP DE
        PUSH DE
        LD A,(IX+6)
        LD B,(IY+0)
        CALL MAT_MUL_S8
        PUSH HL
        LD A,(IX+7)
        LD B,(IY+1)
        CALL MAT_MUL_S8
        POP DE
        ADD HL,DE
        PUSH HL
        LD A,(IX+8)
        LD B,(IY+2)
        CALL MAT_MUL_S8
        POP DE
        ADD HL,DE
        POP DE
        LD A,L
        LD (DE),A
        INC DE
        LD A,H
        LD (DE),A
        INC DE
        RET


; QLIB v0.4 additions. Private entry points: ABI not finalized.
; UDIV16: HL dividend, DE non-zero divisor -> HL quotient, BC remainder.
; CF=1 if divisor=0; repeated subtraction baseline, not optimized.
UDIV16:
        LD A,D
        OR E
        JR NZ,UD16_GO
        SCF
        RET
UD16_GO:
        LD BC,0
UD16_LOOP:
        OR A
        SBC HL,DE
        JR C,UD16_DONE
        INC BC
        JR UD16_LOOP
UD16_DONE:
        ADD HL,DE
        PUSH HL
        LD H,B
        LD L,C
        POP BC
        OR A
        RET

; FX88_ADD / FX88_SUB: HL,DE signed Q8.8 -> HL (wrapping).
FX88_ADD:
        ADD HL,DE
        RET
FX88_SUB:
        OR A
        SBC HL,DE
        RET

; TRIG_SIN8: A=full-turn phase 0..255 -> signed A=-127..127.
; 256-byte table, one lookup, approximate; NOT Microsoft QBX SIN.
TRIG_SIN8:
        LD L,A
        LD H,0
        LD DE,SIN256_TABLE
        ADD HL,DE
        LD A,(HL)
        RET
TRIG_COS8:
        ADD A,64
        JP TRIG_SIN8
SIN256_TABLE:
        DB #00,#03,#06,#09,#0C,#10,#13,#16,#19,#1C,#1F,#22,#25,#28,#2B,#2E
        DB #31,#33,#36,#39,#3C,#3F,#41,#44,#47,#49,#4C,#4E,#51,#53,#55,#58
        DB #5A,#5C,#5E,#60,#62,#64,#66,#68,#6A,#6B,#6D,#6F,#70,#71,#73,#74
        DB #75,#76,#78,#79,#7A,#7A,#7B,#7C,#7D,#7D,#7E,#7E,#7E,#7F,#7F,#7F
        DB #7F,#7F,#7F,#7F,#7E,#7E,#7E,#7D,#7D,#7C,#7B,#7A,#7A,#79,#78,#76
        DB #75,#74,#73,#71,#70,#6F,#6D,#6B,#6A,#68,#66,#64,#62,#60,#5E,#5C
        DB #5A,#58,#55,#53,#51,#4E,#4C,#49,#47,#44,#41,#3F,#3C,#39,#36,#33
        DB #31,#2E,#2B,#28,#25,#22,#1F,#1C,#19,#16,#13,#10,#0C,#09,#06,#03
        DB #00,#FD,#FA,#F7,#F4,#F0,#ED,#EA,#E7,#E4,#E1,#DE,#DB,#D8,#D5,#D2
        DB #CF,#CD,#CA,#C7,#C4,#C1,#BF,#BC,#B9,#B7,#B4,#B2,#AF,#AD,#AB,#A8
        DB #A6,#A4,#A2,#A0,#9E,#9C,#9A,#98,#96,#95,#93,#91,#90,#8F,#8D,#8C
        DB #8B,#8A,#88,#87,#86,#86,#85,#84,#83,#83,#82,#82,#82,#81,#81,#81
        DB #81,#81,#81,#81,#82,#82,#82,#83,#83,#84,#85,#86,#86,#87,#88,#8A
        DB #8B,#8C,#8D,#8F,#90,#91,#93,#95,#96,#98,#9A,#9C,#9E,#A0,#A2,#A4
        DB #A6,#A8,#AB,#AD,#AF,#B2,#B4,#B7,#B9,#BC,#BF,#C1,#C4,#C7,#CA,#CD
        DB #CF,#D2,#D5,#D8,#DB,#DE,#E1,#E4,#E7,#EA,#ED,#F0,#F4,#F7,#FA,#FD

; Each line displays PASS or FAIL. RAM workspace at #9000..#9007.
RUN_TESTS:
        XOR A
        LD (FAIL_COUNT),A
        LD HL,MSG_TITLE
        CALL PRINT_Z
        LD A,12
        LD B,34
        CALL ADD_U8
        CP 46
        LD HL,MSG_ADD
        CALL REPORT_Z

        LD A,255
        LD B,1
        CALL ADD_U8
        CP 0
        LD HL,MSG_ADD_WRAP
        CALL REPORT_Z

        LD A,3
        LD B,7
        CALL SUB_U8
        CP 252
        LD HL,MSG_SUB
        CALL REPORT_Z

        LD A,13
        LD B,17
        CALL MUL_U8
        LD A,H
        OR A
        JR NZ,MUL_FAIL
        LD A,L
        CP 221
        JR MUL_REPORT
MUL_FAIL:
        OR 1
MUL_REPORT:
        LD HL,MSG_MUL
        CALL REPORT_Z

        LD A,255
        LD B,255
        CALL MUL_U8
        LD A,H
        CP #FE
        JR NZ,MULMAX_FAIL
        LD A,L
        CP 1
        JR MULMAX_REPORT
MULMAX_FAIL:
        OR 1
MULMAX_REPORT:
        LD HL,MSG_MULMAX
        CALL REPORT_Z

        LD HL,#6407
        CALL DIVMOD_U8
        CP 14
        JR NZ,DIV_FAIL
        LD A,B
        CP 2
        JR DIV_REPORT
DIV_FAIL:
        OR 1
DIV_REPORT:
        LD HL,MSG_DIV
        CALL REPORT_Z

        LD HL,#FF01
        CALL DIVMOD_U8
        CP 255
        JR NZ,DIVONE_FAIL
        LD A,B
        OR A
        JR DIVONE_REPORT
DIVONE_FAIL:
        OR 1
DIVONE_REPORT:
        LD HL,MSG_DIVONE
        CALL REPORT_Z

        LD HL,#6400
        CALL DIVMOD_U8
        JR C,DIVZERO_PASS
        LD A,1
        OR A
        JR DIVZERO_REPORT
DIVZERO_PASS:
        XOR A
DIVZERO_REPORT:
        LD HL,MSG_DIVZERO
        CALL REPORT_Z

        LD HL,#7FFF
        LD DE,1
        CALL ADD_I16
        LD A,H
        CP #80
        JR NZ,ADD16_FAIL
        LD A,L
        OR A
        JR ADD16_REPORT
ADD16_FAIL:
        OR 1
ADD16_REPORT:
        LD HL,MSG_ADD16
        CALL REPORT_Z

        LD HL,2
        LD DE,7
        CALL SUB_I16
        LD A,H
        CP #FF
        JR NZ,SUB16_FAIL
        LD A,L
        CP #FB
        JR SUB16_REPORT
SUB16_FAIL:
        OR 1
SUB16_REPORT:
        LD HL,MSG_SUB16
        CALL REPORT_Z

        LD HL,#FFFB
        CALL ABS_I16
        LD A,H
        OR A
        JR NZ,ABS_FAIL
        LD A,L
        CP 5
        JR ABS_REPORT
ABS_FAIL:
        OR 1
ABS_REPORT:
        LD HL,MSG_ABS
        CALL REPORT_Z

        LD HL,#8000
        CALL ABS_I16
        JR C,ABS_MIN_PASS
        LD A,1
        OR A
        JR ABS_MIN_REPORT
ABS_MIN_PASS:
        XOR A
ABS_MIN_REPORT:
        LD HL,MSG_ABSMIN
        CALL REPORT_Z

        LD HL,#FFFB
        CALL SGN_I16
        CP #FF
        LD HL,MSG_SGN
        CALL REPORT_Z

        LD HL,144
        CALL ISQRT_U16
        CP 12
        LD HL,MSG_SQRT
        CALL REPORT_Z

        LD HL,65535
        CALL ISQRT_U16
        CP 255
        LD HL,MSG_SQRTMAX
        CALL REPORT_Z

        LD HL,100
        CALL LCG16_STEP
        LD A,H
        CP 1
        JR NZ,LCG_FAIL
        LD A,L
        CP 245
        JR LCG_REPORT
LCG_FAIL:
        OR 1
LCG_REPORT:
        LD HL,MSG_LCG
        CALL REPORT_Z

        LD A,#FE
        LD B,3
        CALL MAT_MUL_S8
        LD A,H
        CP #FF
        JR NZ,SMUL_FAIL
        LD A,L
        CP #FA
        JR SMUL_REPORT
SMUL_FAIL:
        OR 1
SMUL_REPORT:
        LD HL,MSG_SMUL
        CALL REPORT_Z

        LD IX,MAT_COEFF1
        LD IY,MAT_VEC1
        LD DE,MAT_OUT
        CALL MAT2_VEC_S8
        LD HL,(MAT_OUT)
        LD DE,22
        OR A
        SBC HL,DE
        JR NZ,MAT1_FAIL
        LD HL,(MAT_OUT+2)
        LD DE,50
        OR A
        SBC HL,DE
        JR MAT1_REPORT
MAT1_FAIL:
        OR 1
MAT1_REPORT:
        LD HL,MSG_MAT1
        CALL REPORT_Z

        LD IX,MAT_COEFF2
        LD IY,MAT_VEC2
        LD DE,MAT_OUT
        CALL MAT2_VEC_S8
        LD HL,(MAT_OUT)
        LD DE,#FFF2
        OR A
        SBC HL,DE
        JR NZ,MAT2_FAIL
        LD HL,(MAT_OUT+2)
        LD DE,32
        OR A
        SBC HL,DE
        JR MAT2_REPORT
MAT2_FAIL:
        OR 1
MAT2_REPORT:
        LD HL,MSG_MAT2
        CALL REPORT_Z


        LD HL,123
        LD DE,456
        CALL MUL16_LO
        LD DE,56088
        OR A
        SBC HL,DE
        LD HL,MSG_MUL16
        CALL REPORT_Z

        LD HL,#FFFF
        LD DE,2
        CALL MUL16_LO
        LD DE,#FFFE
        OR A
        SBC HL,DE
        LD HL,MSG_MUL16WRAP
        CALL REPORT_Z

        LD IX,MAT23_COEFF
        LD IY,MAT_VEC1
        LD DE,MAT_OUT
        CALL MAT23_VEC_S8
        LD HL,(MAT_OUT)
        LD DE,27
        OR A
        SBC HL,DE
        JR NZ,M23_BAD
        LD HL,(MAT_OUT+2)
        LD DE,47
        OR A
        SBC HL,DE
        JR M23_SHOW
M23_BAD:
        OR 1
M23_SHOW:
        LD HL,MSG_MAT23
        CALL REPORT_Z

        LD IX,MAT3_COEFF
        LD IY,MAT3_VEC
        LD DE,MAT_OUT
        CALL MAT3_VEC_S8
        LD HL,(MAT_OUT)
        LD DE,14
        OR A
        SBC HL,DE
        JR NZ,M3_BAD
        LD HL,(MAT_OUT+2)
        LD DE,2
        OR A
        SBC HL,DE
        JR NZ,M3_BAD
        LD HL,(MAT_OUT+4)
        LD DE,1
        OR A
        SBC HL,DE
        JR M3_SHOW
M3_BAD:
        OR 1
M3_SHOW:
        LD HL,MSG_MAT3
        CALL REPORT_Z


        LD HL,1000
        LD DE,10
        CALL UDIV16
        JR C,TEST_UDIV_BAD
        LD A,H
        OR A
        JR NZ,TEST_UDIV_BAD
        LD A,L
        CP 100
        JR NZ,TEST_UDIV_BAD
        LD A,B
        OR C
        JR TEST_UDIV_SHOW
TEST_UDIV_BAD:
        LD A,1
        OR A
TEST_UDIV_SHOW:
        LD HL,MSG_UDIV
        CALL REPORT_Z

        LD HL,100
        LD DE,0
        CALL UDIV16
        JR C,TEST_DIV0_OK
        LD A,1
        OR A
        JR TEST_DIV0_SHOW
TEST_DIV0_OK:
        XOR A
TEST_DIV0_SHOW:
        LD HL,MSG_UDIV0
        CALL REPORT_Z

        LD HL,#0180
        LD DE,#0080
        CALL FX88_ADD
        LD DE,#0200
        OR A
        SBC HL,DE
        LD HL,MSG_FXADD
        CALL REPORT_Z

        LD HL,#0180
        LD DE,#0080
        CALL FX88_SUB
        LD DE,#0100
        OR A
        SBC HL,DE
        LD HL,MSG_FXSUB
        CALL REPORT_Z

        XOR A
        CALL TRIG_SIN8
        OR A
        LD HL,MSG_SIN0
        CALL REPORT_Z

        LD A,64
        CALL TRIG_SIN8
        CP 127
        LD HL,MSG_SIN90
        CALL REPORT_Z

        LD A,128
        CALL TRIG_SIN8
        OR A
        LD HL,MSG_SIN180
        CALL REPORT_Z

        XOR A
        CALL TRIG_COS8
        CP 127
        LD HL,MSG_COS0
        CALL REPORT_Z

        LD A,(FAIL_COUNT)
        OR A
        LD HL,MSG_ALL
        CALL REPORT_Z
        RET

; REPORT_Z: input Z=success, HL=label. Preserves original flags through printing.
REPORT_Z:
        PUSH AF
        CALL PRINT_Z
        POP AF
        JR NZ,REPORT_BAD
        LD HL,MSG_PASS
        JP PRINT_Z
REPORT_BAD:
        LD A,(FAIL_COUNT)
        INC A
        LD (FAIL_COUNT),A
        LD HL,MSG_FAIL
        JP PRINT_Z

PRINT_Z:
        LD A,(HL)
        OR A
        RET Z
        PUSH HL
        CALL #BB5A
        POP HL
        INC HL
        JR PRINT_Z

FAIL_COUNT EQU #9000
MAT_OUT EQU #9002
MAT_COEFF1: DB 1,2,3,4
MAT_VEC1: DB 6,8
; [[-1,2],[3,-4]] * [4,-5] = [-14,32]
MAT_COEFF2: DB #FF,2,3,#FC
MAT_VEC2: DB 4,#FB
MSG_TITLE: DB 13,10,'QLIB MATH + MATRIX v0.4.0',13,10,0
MSG_ADD: DB 'ADD8: ',0
MSG_ADD_WRAP: DB 'ADD8 WRAP: ',0
MSG_SUB: DB 'SUB8: ',0
MSG_MUL: DB 'MUL8: ',0
MSG_MULMAX: DB 'MUL8 LIMIT: ',0
MSG_DIV: DB 'DIV8: ',0
MSG_DIVONE: DB 'DIV8 /1: ',0
MSG_DIVZERO: DB 'DIV8 /0 FLAG: ',0
MSG_ADD16: DB 'ADD16: ',0
MSG_SUB16: DB 'SUB16: ',0
MSG_ABS: DB 'ABS16: ',0
MSG_ABSMIN: DB 'ABS16 MIN: ',0
MSG_SGN: DB 'SGN16: ',0
MSG_SQRT: DB 'SQRT16: ',0
MSG_SQRTMAX: DB 'SQRT16 LIMIT: ',0
MSG_LCG: DB 'LCG16: ',0
MSG_SMUL: DB 'MUL S8: ',0
MSG_MAT1: DB 'MATRIX 2x2: ',0
MSG_MAT2: DB 'MATRIX SIGNED: ',0
MAT23_COEFF: DB 1,2,5,3,4,#FD
MAT3_COEFF: DB 1,2,3,#FF,0,1,2,#FE,1
MAT3_VEC: DB 1,2,3
MSG_MUL16: DB 'MUL16: ',0
MSG_MUL16WRAP: DB 'MUL16 WRAP: ',0
MSG_MAT23: DB 'MATRIX 2x3: ',0
MSG_MAT3: DB 'MATRIX 3x3: ',0
MSG_UDIV: DB 'DIV16: ',0
MSG_UDIV0: DB 'DIV16 /0: ',0
MSG_FXADD: DB 'FIXED ADD: ',0
MSG_FXSUB: DB 'FIXED SUB: ',0
MSG_SIN0: DB 'SIN8 0: ',0
MSG_SIN90: DB 'SIN8 90: ',0
MSG_SIN180: DB 'SIN8 180: ',0
MSG_COS0: DB 'COS8 0: ',0
MSG_ALL: DB 'ALL TESTS: ',0
MSG_PASS: DB 'PASS',13,10,0
MSG_FAIL: DB 'FAIL',13,10,0

        DEFS #10000-$,#FF
