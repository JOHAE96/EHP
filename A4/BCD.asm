;----------------------------------------------------------------;
; Datei
: dual_b d.asm
;
; Datum
: Mar. 2010
;
; Beschreibung : Dual-BCD-Umsetzung
;
;----------------------------------------------------------------;
org X"00000000" ; legt die Programmstartadresse fest
start init
; markiert den ersten Befehl
; Immediate-Werte fuer Spei heroperationen:
zero equ X"0000" ; Offset 0
disp equ X"0FFC" ; zur Adressierung des letzten
; Wortes im ROM (4KByte)
ram equ X"0FF8" ; zur Adressierung des vorletzten
; Wortes im ROM
; Die letzten beiden ROM-Speicherzellen sind mit zwei Konstanten
; initialisiert. In der Speicherzelle mit der Adresse 0x0000_0FFC
; steht die Adresse fuer das Display Lat h und in der Spei herzelle
; 0x0000_0FF8 wurde die Basisadresse des RAM abgelegt.
; Die in eine BCD-Zahl zu wandelnde Dualzahl sei:
dual_high equ X"0"
dual_low equ X"1e"
;
; Die Binaerdarstellung dieser Dualzahl erfordert 1 Tetrade und 1 Bit:
dualbits equ 5
; Fuer die Darstellung der BCD-Zahl sind 2 Ziffern erforderli h:
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
; r31 Speicheradresse des Display-Latches
init:
;; Initialisierung:
;; ---------------
    nop
ini_bcd or.i r1,r0,dual_high    ; lade die hoeherwertige 16 Bits in r1
        sll.i r1,r1,16          ; Shiftet diese 16 Bits nach links
        or.i r1,r1,dual_low     ; lade die niederwertige 16 Bits in r1
        add.i r9,r0, dualbits   ; init. Laufvariable fuer Anzahl der shifts
        add.i r2,r0,0           ; init. BCD-Ergebnis auf 0
        add.i r3,r0,X"f"        ; init. Tetradenmaske
        add.i r5,r0,5           ; init. Tetradenvergleichswert
        add.i r7,r0,3           ; init. Tetradenkorrekturwert
        lw.i r31,disp(r0)       ; r31 <- Adresse fuer Display-Latch
;; BCD-Korrektur:
;; -------------
;; SHIFTING
bcd     sub.i r9,r9,1           ; dekrementiert Laufvariable
        add.i r10,r0,0-4        ; Tetradenindex auf -4 setzen
        srl r13,r1,r9           ; Dualzahl um r9 nach rechts shiften ...
        and.i r14,r13,1         ; ... um das (r9 + 1)te Bit zu extrahieren
        sll.i r2,r2,1           ; Schiebe BCD-Rahmen um 1 nach links
        or r2,r14,r2            ; Setze extrahiertes Bit rechts in den Rahmen
        beqz r9,displ           ; Zeige das Ergebnis wenn r9 (Laufvar) auf 0
;; TETRADENBETRACHTUNG
te_ko   add.i r10,r10,4         ; Erhoehe den Tetradenindex
        sub.i r12,r10,(digits-1) * 4  ; Abbruchbed, falls alle Tetraden durch
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
displ   sw.i zero(r31),r2       ; Zeige das Ergebnis
ende    j ende                  ; Ende
end                             ; Ende
