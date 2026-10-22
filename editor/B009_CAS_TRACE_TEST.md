# QEDIT B009 — WinAPE CAS trace test

Experimental branch: `qedit-b009-cas-trace`; QEDIT B008 is preserved.

## Background
B008: steps 1, 2, 3 pass. Step 4 hangs/resets without a reported disk access sound. This does NOT prove the disk controller was never reached.

## B009
At launch a separate trace subroutine is copied into #8D00 (RAM) while the original disk bridge remains at #8C00. On step 4, QEDIT writes a byte at **#88B1**, then enters the trace subroutine in RAM and calls CAS_OUT_OPEN. The trace subroutine restores upper ROM slot 1 before returning to the QEDIT ROM.

**Read byte at #88B1 using WinAPE debugger memory view after the failure, before resetting:**
- #10: reached call site in ROM, did not reach first marker in RAM stub
- #11: RAM trace stub entered; about to execute CAS_OUT_OPEN
- #22: CAS_OUT_OPEN returned, but upper ROM select not completed
- #33: ROM select completed; failure is later (e.g. abandoned output stream, firmware/UI path)
- #00: stage 4 not reached or editor reinitialized; reset erases useful state
- Other values: unexpected memory modification; capture screenshot and address.

These markers are the last reached point, not a proof of CAS success. CAS_OUT_OPEN can return without accessing the disk motor. In WinAPE a crash/reset may remove RAM contents; consider setting a breakpoint on #8D00 and #BC8C if RAM tracing is not accessible.

## Test
1. Open a disposable DSK in drive A (no valuable data).
2. Mount B009 ROM in Upper ROM slot 1. Keep AMSDOS ROM 7. Reset emulator.
3. `MEMORY &5FFF`, then `|QEDIT`.
4. Press Ctrl+S repeatedly, close each modal message using Ctrl+S if needed; observe step 1, 2, 3, then step 4.
5. If step 4 hangs/resets, pause WinAPE debugger immediately. Inspect memory #88B1 and PC, SP; report values.

B009 is only a probe; saving user source files remains unsafe. Compiled success does not imply WinAPE validation.
