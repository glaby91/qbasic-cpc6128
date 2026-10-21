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
        LD (DE),L
        INC DE
        LD (DE),H
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
        LD (DE),L
        INC DE
        LD (DE),H
        RET

; Matrix 3x3 and Q8.8: next development tranche after tests.
