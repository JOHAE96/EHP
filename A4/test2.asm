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

lower equ 3
upper equ 12

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
    add.i r1, r0, 1     ; r1 <- 1
    add.i r2, r0, 0     ; r2 <- 0
    add.i r3, r0, 1     ; r3 <- 1
    add.i r5, r0, 3     ; r5 <- 3
    add.i r6, r0, 12    ; r6 <- 12
    sub.i r7, r5, 1     ; r7 <- 2
    lw.i r31, ram(r0)   ; r31 <- 0x1000_0000
for:
    add.i r7, r7, X"1"    ; i++
    add r4, r2, r3      ; a_n <- a_(n-2) + a_(n-1)
    add r2, r0, r3      ; a_(n-2) <- a_(n-1)
    add r3, r0, r4      ; a_(n-1) <- a_n
    sw.i zero(r31), r4  ; RAM[i] <- a_n
    add.i r31, r31, X"4"; r31 += 4 
    slt r8, r7, r6      ; r8 <- i < upper
    sub r8, r1, r8      ; r8 <- not r8
    beqz r8, for

; Die Binaerdarstellung der hoechsten Zahl benoetigt 2 Tetraden:
dualbits equ 8
; Fuer die Darstellung der BCD-Zahl sind jeweils 2 Ziffern erforderlich:
digits equ 2
;
; verwendete Register:
; -------------------
; r1 Dualzahl
; r2 aktueller BCD-Wert
; r3 initiale Tetradenmaske (X"f")
; r4 aktuelle Tetradenmaske
; r5 initialer Tetradenvergleichswert (4+1)
; r6 aktueller Tetradenvergleichswert
; r7 initialer Tetradenkorrekturwert (3)
; r8 aktueller Tetradenkorrekturwert
; r9 Laufvariable i (Dualzahlindex)
; r10 Tetradenindex
; r11 Sprungbedingung fuer Tetradenkorrektur
; r12 Abbru hbedingung fuer die Tetradenkorrektur
; r13 aktueller Dualwert
; r14 aktuelles Dualzahlbit
; r15 Laufvariable f. die umzuwandelnden Zahlen
; r16 Obergrenze f. die umzuwandelnden Zahlen
; r17 tmp-Register fuer Vergleich i < upper
; r30 read-Speicheradresse im RAM
; r31 write-Speicheradresse im RAM


ini_bcd lw.i r30, ram(r0)       ; lade die erste RAM-Adresse in r30
        sub.i r30, r30, 4       ; dekrementiere r30 um 4,um mit dem loop konform zu sein
        sub.i r31, r31, 4       ; init. write-Speicheradresse
        sub.i r15, r0, 1        ; init. Laufvariable fuer Anzahl der umzuwand. Zahlen
        add.i r16, r0, 9    ; init. Obergrenze fuer Anzahl der umzuwand. Zahlen
        add.i r16, r16, 1
;; Kommentar oder whatever
;;
loop    add.i r9,r0, dualbits   ; init. Laufvariable fuer Anzahl der shifts
        add.i r2,r0,0           ; init. BCD-Ergebnis auf 0
        add.i r3,r0,X"f"        ; init. Tetradenmaske
        add.i r5,r0,5           ; init. Tetradenvergleichswert
        add.i r7,r0,3           ; init. Tetradenkorrekturwert
        lw.i r1, zero(r30)      ; lade die Dualzahl in r1
        add.i r15, r15, 1       ; i++
        add.i r30, r30, 4       ; 
        add.i r31, r31, 4       ; 
;; BCD-Korrektur:
;; -------------
;; SHIFTING
bcd     sub.i r9,r9,1           ; dekrementiert Laufvariable
        add.i r10,r0,0-4        ; Tetradenindex auf -4 setzen
        srl r13,r1,r9           ; Dualzahl um r9 nach rechts shiften ...
        and.i r14,r13,1         ; ... um das (r9 + 1)te Bit zu extrahieren
        sll.i r2,r2,1           ; Schiebe BCD-Rahmen um 1 nach links
        or r2,r14,r2            ; Setze extrahiertes Bit rechts in den Rahmen
        beqz r9,write           ; Zeige das Ergebnis wenn r9 (Laufvar) auf 0
;; TETRADENBETRACHTUNG
te_ko   add.i r10,r10,4         ; Erhoehe den Tetradenindex
        sub.i r12,r10,(digits-1) * 4  ; Abbruchbedingung, falls alle Tetraden durch
        sll r4,r3,r10           ; Shifte Tetradenmaske zum Tetradenindex
        sll r6,r5,r10           ; Shifte den Tetradenvergleichswert zum Index
        sll r8,r7,r10           ; Shifte den Tetradenkorrekturwert zum Index
        and r14,r2,r4           ; Betrachte vom BCD-Rahmen nur best. Tetrade
        slt r11,r14,r6          ; Setze auf 0, falls Tetrade > 4 ...
        beqz r11,plus_3         ; ... um fuer die Korrektur springen zu koennen
        beqz r12,bcd            ; Breche Korrektur ab falls alle Tetraden durch
        j te_ko                 ; korrigiere naechste Tetrade
;; EIGENTLICHE KORREKTUR
plus_3  add r2,r2,r8            ; addiere 3 auf die Tetrade im BCD-Rahmen
        beqz r12,bcd            ; Abbruchbed. siehe 3 Zeilen drueber
        j te_ko                 ; weiterkorrigieren, siehe 3 Zeilen drueber
write   sw.i zero(r31),r2       ; Zeige das Ergebnis
        slt r17, r15, r16       ; r17 <- i < upper
        sub.i r17, r17, 1       ; r17 <- not r17
        beqz r17, loop

ende    j ende                  ; Ende
end                             ; Ende
