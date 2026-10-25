; SYMBIOSE CPC HARDWARE DETECTOR v0.1
; Assemble at &8000, launch CALL &8000
; WARNING: assumes standard RAM mapping; test touches &4000.
        ORG &8000
TXT_OUT EQU &BB5A
START:  LD HL,HEADER
        CALL PRINT
        LD HL,CPU_MSG
        CALL PRINT
        CALL TEST_EXT_RAM
        JR Z,NO_EXT
        LD HL,EXT_MSG
        JR SHOW_RAM
NO_EXT: LD HL,BASE_MSG
SHOW_RAM:
        CALL PRINT
        LD HL,FOOTER
        CALL PRINT
        RET
TEST_EXT_RAM:
        DI
        LD A,(&4000)
        LD (BASE_OLD),A
        LD BC,&7FC4
        OUT (C),C
        LD A,(&4000)
        LD (BANK_OLD),A
        LD A,&A5
        LD (&4000),A
        LD BC,&7FC0
        OUT (C),C
        LD A,&5A
        LD (&4000),A
        LD BC,&7FC4
        OUT (C),C
        LD A,(&4000)
        CP &A5
        LD D,0
        JR NZ,RESTORE
        LD D,1
RESTORE:
        LD A,(BANK_OLD)
        LD (&4000),A
        LD BC,&7FC0
        OUT (C),C
        LD A,(&4000)
        CP &5A
        JR NZ,BASE_MISMATCH
        JR BASE_RESTORE
BASE_MISMATCH:
        LD D,0
BASE_RESTORE:
        LD A,(BASE_OLD)
        LD (&4000),A
        EI
        LD A,D
        OR A
        RET
PRINT:  LD A,(HL)
        OR A
        RET Z
        PUSH HL
        CALL TXT_OUT
        POP HL
        INC HL
        JR PRINT
BASE_OLD: DB 0
BANK_OLD: DB 0
HEADER: DB 13,10,'SYMBIOSE CPC DETECTOR 0.1',13,10
        DB '------------------------',13,10,0
CPU_MSG: DB 'CPU : Z80 (PLATFORM)',13,10,0
BASE_MSG: DB 'RAM : 64K / NO BANK 4',13,10,0
EXT_MSG: DB 'RAM : BANK 4 PRESENT (>=128K)',13,10,0
FOOTER: DB 'DETECTION COMPLETE',13,10,0
