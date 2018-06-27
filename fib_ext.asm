;---------------------------------------------------------------
; Calculation of die Fibbonacci numbers F_n for n = 3, ..., 12
; using the extended instruction set.
;
;---------------------------------------------------------------

org X"00000000"
start init

zero  equ  X"0000" ; Offset 0
disp  equ  X"0FFC" ; Offset 0x0FFC
ram   equ  X"0FF8" ; Offset 0x0FF8

; r0 ... const 0
; r1 ... const 1
; r2 ... a_(n-2)
; r3 ... -a_(n-1)
; r4 ... a_n
; r5 ... -lower
; r6 ... upper-lower
; r7 ... i
; r8 ... tmp variable deciding when to exit the for loop

init:
    add.i r1, r0, X"1"  ; r1 <- 1
    add.i r2, r0, r0    ; r2 <- 0
    add r3, r0, r1      ; r3 <- 1
    sub.i r5, r0, X"3"  ; r5 <- -3
    add r6, r5, X"12"   ; r6 <- -3 + 12 = 9
    sub r7, r0, r1      ; r7 <- -1
for:
    add r7, r7, r1      ; i++
    add r4, r2, r3      ; a_n <- a_(n-2) + a_(n-1)
    add r2, r0, r3      ; a_(n-2) <- a_(n-1)
    add r3, r0, r4      ; a_(n-1) <- a_n
    sw.i ram(r7), r4    ; RAM[i] <- a_n
    slt r8, r7, r6      ; r8 <- i < upper
    sub r8, r1, r8      ; r8 <- not r8
    beqz r8, for
stop:
    j stop
