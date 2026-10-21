; QLIB_MATRIX 0.1 standalone prototype with QLIB math-compatible ROM header.
        ORG #C000
        DB 1,0,1,0
        DW NAMES
        JP INIT
        JP TEST
NAMES:
        DB 'QMA','T'+#80
        DB 'M2TES','T'+#80
        DB 0
INIT:
        SCF
        RET
TEST:
        LD HL,MSG
        CALL PRINT
        LD IX,COEFF
        LD IY,VEC
        LD DE,MAT_RESULT
        CALL MAT2_VEC_S8
        LD HL,(MAT_RESULT)
        LD DE,22
        OR A
        SBC HL,DE
        JR NZ,BAD
        LD HL,(MAT_RESULT+2)
        LD DE,50
        OR A
        SBC HL,DE
        JR NZ,BAD
        LD HL,GOOD
        JR PRINT
BAD:
        LD HL,BAD_MSG
        JR PRINT
PRINT:
        LD A,(HL)
        OR A
        RET Z
        PUSH HL
        CALL #BB5A
        POP HL
        INC HL
        JR PRINT
MSG: DB 13,10,'QLIB MATRIX 2x2: ',0
GOOD: DB 'PASS',13,10,0
BAD_MSG: DB 'FAIL',13,10,0
COEFF: DB 1,2,3,4
VEC: DB 6,8
MAT_RESULT EQU #8000    ; temporary RAM output during RSX test (not ROM storage)
        INCLUDE 'MATRIX_S8.asm'
        DEFS #10000-$,#FF
