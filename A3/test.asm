        org X"00000000"
        start init
init:
        nop
label   add.i   r1,  r0, X"0005" ; r1 <- 5
        add     r2,  r1, r1      ; r2 <- A
        sub.i   r3,  r2, X"0003" ; r3 <- 7
        and     r4,  r3, r1      ; r4 <- 5
        and.i   r5,  r3, X"0004" ; r5 <- 4
        or      r6,  r4, r5      ; r6 <- 5
        or.i    r7,  r3, X"0008" ; r7 <- F
        srl     r8,  r5, r4      ; r8 <- 0
        srl.i   r9,  r3, X"0001" ; r9 <- 3
        sll     r10, r9, r8      ; r10 <- 3
        sll.i   r11, r8, X"0003" ; r11 <- 0
stop    j stop
