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
    add.i r31, r31, X"4"; r31 += 4 
    slt r8, r7, r6      ; r8 <- i < upper
    sub r8, r1, r8      ; r8 <- not r8
    beqz r8, for

; r0 ... const 0
; r1 ... const 1
; r2 ... a_(n-2)
; r3 ... -a_(n-1)
; r4 ... a_n
; r5 ... -lower (= -3)
; r6 ... -upper (= -12)
; r7 ... i
; r8 ... tmp variable deciding when to exit the for loop
; r30 ... const -4
; r31 ... memory address

    slt r1, r0, r31     ; r1 <- 1 since r0 = 0 < r31
    sub r2, r0, r0      ; r2 <- 0
    sub r3, r0, r1      ; r3 <- -1
    sub r5, r0, r1      ; r5 <- -1
    sub r5, r5, r1      ; r5 <- -2
    sub r5, r5, r1      ; r5 <- -3
    sub r6, r0, r5      ; r6 <- 3
    sub r6, r6, r5      ; r6 <- 6
    sub r6, r6, r5      ; r6 <- 9
    sub r6, r6, r5      ; r6 <- 12
    sub r6, r0, r6      ; r6 <- -12
    sub r6, r6, r1      ; r6 <- -13
    sub r7, r5, r0      ; r7 <- -3
    sub r30, r5, r1     ; r30 <- -4
for2:
    sub r4, r2, r3      ; a_n     <- a_(n-2) - (-a_(n-1))
    sub r2, r0, r3      ; a_(n-2) <- - (-a_(n-1))
    sub r3, r0, r4      ; a_(n-1) <- -a_n
    sw.i zero(r31), r4  ; RAM[i] <- a_n
    sub r31, r31, r30   ; r31 -= -4
    sub r7, r7, r1      ; i--
    slt r8, r6, r7      ; r8 <- -upper < -i
    sub r8, r1, r8      ; r8 <- not r8
    beqz r8, for2        ; another loop if r8 == 0 <=> -upper < -i
stop:
    j stop
end
