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
; r5 ... lower
; r6 ... upper
; r7 ... i
; r8 ... tmp variable deciding when to exit the for loop
; r31 ... memory address

init:
    add.i r1, r0, X"1"  ; r1 <- 1
    add.i r2, r0, X"0"  ; r2 <- 0
    add.i r3, r0, X"1"  ; r3 <- 1
    add.i r5, r0, X"3"  ; r5 <- 3
    add.i r6, r0, X"C"  ; r6 <- 12
    sub.i r7, r5, X"1"  ; r7 <- 2
    lw.i r31, ram(r0)   ; r31 <- 0x1000_0000
for:
    add r7, r7, X"1"    ; i++
    add r4, r2, r3      ; a_n <- a_(n-2) + a_(n-1)
    add r2, r0, r3      ; a_(n-2) <- a_(n-1)
    add r3, r0, r4      ; a_(n-1) <- a_n
    sw.i zero(r31), r4  ; RAM[i] <- a_n
    add.i r31, X"4"     ; r31 += 4 
    slt r8, r7, r6      ; r8 <- i < upper
    sub r8, r1, r8      ; r8 <- not r8
    beqz r8, for
stop:
    j stop
