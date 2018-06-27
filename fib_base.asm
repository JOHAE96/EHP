;---------------------------------------------------------------
; Calculation of die Fibbonacci numbers F_n for n = 3, ..., 12
; using the basic instruction set.
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
; r5 ... -lower (= -3)
; r6 ... - (upper-lower) (= -(12-3) = -9)
; r7 ... i
; r8 ... tmp variable deciding when to exit the for loop

init:
    lw.i r31, disp(r0)  ; r31 <- M[0x0000_0FFC]
    slt r1, r0, r31     ; r1 <- 1 since r0 = 0 < 0x2000_0000 = r31
    sub r2, r0, r0      ; r2 <- 0
    sub r3, r0, r1      ; r3 <- -1
    sub r5, r0, r1      ; r5 <- -1
    sub r5, r5, r1      ; r5 <- -2
    sub r5, r5, r1      ; r5 <- -3
    sub r6, r0, r5      ; r6 <- 3
    sub r6, r6, r5      ; r6 <- 6
    sub r6, r6, r5      ; r6 <- 9
    sub r6, r0, r6      ; r6 <- -9
    sub r7, r1, r0      ; r7 <- 1
for:
    sub r7, r7, r1      ; i--
    sub r4, r2, r3      ; a_n     <- a_(n-2) - (-a_(n-1))
    sub r2, r0, r3      ; a_(n-2) <- - (-a_(n-1))
    sub r3, r0, r4      ; a_(n-1) <- -a_n
    sw.i ram(r7), r4    ; RAM[i] <- a_n
    slt r8, r6, r7      ; r8 <- -upper < -i
    sub r8, r1, r8      ; r8 <- not r8
    beqz r8, for        ; another loop if r8 == 0 <=> -upper < -i
stop:
    j stop
