; Testset covering EX stage instructions
; Each instruction uses a different GP register to avoid hazards

START:
    ; --- LUI normal and edge cases ---
    LUI     #0x000          ; load zero into IR                    ; 0100 0000 0000 0000 0000 0000
    MOVi    #0x000, R0      ; MOVi using IR=0 -> R0 = 0            ; 0010 0010 0000 0000 0000 0000
    LUI     #0xFFF          ; upper immediate all ones             ; 0100 0000 0000 1111 1111 1111
    MOVi    #0xFFF, R1      ; MOVi with max value -> R1 = 0xFFFFFF ; 0010 0010 0001 1111 1111 1111

    ; --- MOVis signed immediate ---
    MOVis   #0x7FF, R2      ; maximum positive 12-bit value        ; 0011 0010 0010 0111 1111 1111
    MOVis   #-1,    R3      ; sign extended -1 -> 0xFFFFFF         ; 0011 0010 0011 1111 1111 1111

    ; --- MOV register ---
    MOV     R2, R4          ; move positive value                  ; 0000 0010 0100 0010 0000 0000
    MOV     R3, R5          ; move negative value                  ; 0000 0010 0101 0011 0000 0000

    ; --- ADD unsigned ---
    MOVis   #1,    R6       ; prepare source                       ; 0011 0010 0110 0000 0000 0001
    ADD     R6, R1          ; R1 was 0xFFFFFF -> test carry        ; 0000 0011 0001 0110 0000 0000
    ADD     R0, R2          ; 0 + 0x7FF -> normal                  ; 0000 0011 0010 0000 0000 0000

    ; --- ADDi unsigned immediate ---
    ADDi    #1,  R2         ; add small value                      ; 0010 0011 0010 0000 0000 0001
    ADDi    #1,  R1         ; add 1 to 0xFFFFFF -> wrap/carry      ; 0010 0011 0001 0000 0000 0001

    ; --- ADDs signed ---
    MOVis   #-1,  R7        ; source -1                            ; 0011 0010 0111 1111 1111 1111
    ADDs    R7,  R6         ; signed add -1 + 1 -> 0               ; 0001 0011 0110 0111 0000 0000
    MOVis   #0x400, R8      ; 0x400 (1024)                         ; 0011 0010 1000 0100 0000 0000
    ADDs    R8,  R8         ; overflow positive + positive         ; 0001 0011 1000 1000 0000 0000

    ; --- ADDis signed immediate ---
    ADDis   #-1, R6         ; 1 + (-1) -> 0                        ; 0011 0011 0110 1111 1111 1111
    ADDis   #0x7FF, R7      ; -1 + 2047 -> edge positive           ; 0011 0011 0111 0111 1111 1111

    ; --- SUB unsigned ---
    SUB     R6,  R2         ; 0x7FF - 1 -> normal                  ; 0000 0100 0010 0110 0000 0000
    SUB     R1,  R0         ; 0 - 0xFFFFFF -> underflow            ; 0000 0100 0000 0001 0000 0000

    ; --- SUBi unsigned immediate ---
    SUBi    #1,  R2         ; subtract small value                 ; 0010 0100 0010 0000 0000 0001
    SUBi    #1,  R0         ; subtract from underflowed value      ; 0010 0100 0000 0000 0000 0001

    ; --- SUBs signed ---
    MOVis   #-2,  R9        ; -2                                   ; 0011 0010 1001 1111 1111 1110
    SUBs    R6,  R9         ; -2 - 1 -> -3                         ; 0001 0100 1001 0110 0000 0000
    MOVis   #1,   R10       ; 1                                    ; 0011 0010 1010 0000 0000 0001
    SUBs    R7,  R10        ; 1 - (-1) -> 2                        ; 0001 0100 1010 0111 0000 0000

    ; --- SUBis signed immediate ---
    SUBis   #-1, R7         ; -1 - (-1) -> 0                       ; 0011 0100 0111 1111 1111 1111
    SUBis   #0x800, R8      ; overflow with min negative immediate ; 0011 0100 1000 1000 0000 0000

    ; --- NOT ---
    NOT     R0              ; complement underflow result          ; 0000 0101 0000 0000 0000 0000
    NOT     R5              ; complement negative value            ; 0000 0101 0101 0000 0000 0000

    ; --- AND ---
    MOVis   #0x0F0, R11     ; 0xF0                                 ; 0011 0010 1011 0000 1111 0000
    AND     R11, R2         ; 0x7FE & 0xF0                         ; 0000 0110 0010 1011 0000 0000
    MOVis   #0,    R12      ; zero                                 ; 0011 0010 1100 0000 0000 0000
    AND     R12, R3         ; -1 & 0 -> 0                          ; 0000 0110 0011 1100 0000 0000

    ; --- ANDi ---
    ANDi    #0x0F, R1       ; apply mask                           ; 0010 0110 0001 0000 0000 1111
    ANDi    #0,    R2       ; result zero                          ; 0010 0110 0010 0000 0000 0000

    ; --- OR ---
    OR      R11, R3         ; -1 OR 0xF0 -> -1                     ; 0000 0111 0011 1011 0000 0000
    OR      R12, R4         ; value | 0 -> unchanged               ; 0000 0111 0100 1100 0000 0000

    ; --- ORi ---
    ORi     #0xF0, R0       ; set high bits                        ; 0010 0111 0000 0000 1111 0000
    ORi     #0,    R6       ; no change                            ; 0010 0111 0110 0000 0000 0000

    ; --- XOR ---
    XOR     R11, R4         ; mix values                           ; 0000 1000 0100 1011 0000 0000
    XOR     R12, R5         ; value XOR 0 -> same                  ; 0000 1000 0101 1100 0000 0000

    ; --- XORi ---
    XORi    #0xFF, R1       ; toggle low byte
    XORi    #0,    R2       ; unchanged

    ; --- SHL ---
    MOVis   #1,    R13      ; shift amount 1
    SHL     R13, R4         ; simple shift
    MOVis   #0x20, R14      ; 32 >= width -> overflow
    SHL     R14, R5         ; result zero, V flag

    ; --- SHLi ---
    SHLi    #4,  R6         ; left by 4
    SHLi    #0x20, R7       ; left by 32 -> zero

    ; --- SHR ---
    MOVis   #4,    R15      ; shift amount 4
    SHR     R15, R4         ; right shift
    MOVis   #0x20, R0       ; >= width
    SHR     R0,  R5         ; result zero

    ; --- SHRi ---
    SHRi    #4,  R6         ; right by 4
    SHRi    #0x20, R7       ; right by 32 -> zero

    ; --- SHRs signed ---
    MOVis   #1,   R8        ; shift amount
    SHRs    R8,  R3         ; arithmetic shift -1
    MOVis   #0x20, R9       ; >= width
    SHRs    R9,  R5         ; result zero

    ; --- SHRis signed immediate ---
    SHRis   #1,   R3        ; -1 >> 1 keeps sign
    SHRis   #0x20, R4       ; shift >=24

    ; --- CMP unsigned ---
    CMP     R0,  R0         ; compare equal
    CMP     R1,  R2         ; compare greater/less

    ; --- CMPi unsigned immediate ---
    CMPi    #0xFF, R1       ; compare with immediate
    CMPi    #0,    R2       ; compare zero

    ; --- CMPs signed ---
    CMPs    R3,  R5         ; compare negatives
    CMPs    R2,  R6         ; compare mixed sign

    ; --- CMPis signed immediate ---
    CMPis   #-1, R7         ; compare with -1
    CMPis   #0x7FF, R8      ; compare positive

    ; --- Special register operations ---
    LUI     #0x123          ; update IR
    SRMOV   PC, LR          ; store PC in LR

    HLT
