; Testset covering EX stage instructions
; Each instruction uses a different GP register to avoid hazards

START:
    ; --- LUI normal and edge cases ---
    LUI     #0x000          ; load zero into IR                    ; 0000 0001 0000 0000 0000 0000 ; 010000 ; tick        4
    MOViu   #0x000, R0      ; MOVi using IR=0 -> R0 = 0            ; 0010 0010 0000 0000 0000 0000 ; 220000
    LUI     #0xFFF          ; upper immediate all ones             ; 0000 0001 0000 1111 1111 1111 ; 010fff
    MOViu   #0xFFF, R1      ; MOVi with max value -> R1 = 0xFFFFFF ; 0010 0010 0001 1111 1111 1111 ; 221fff ; tick  11

    ; --- MOVis signed immediate ---
    MOVis   #0x7FF, R2      ; maximum positive 12-bit value        ; 0011 0010 0010 0111 1111 1111 ; 3227ff
    MOVis   #-1,    R3      ; sign extended -1 -> 0xFFFFFF         ; 0011 0010 0011 1111 1111 1111 ; 323fff ; tick  13

    ; --- MOV register ---
    MOVu    R2, R4          ; move positive value                  ; 0000 0010 0100 0010 0000 0000 ; 024200
    MOVu    R3, R5          ; move negative value                  ; 0000 0010 0101 0011 0000 0000 ; 025300 ; tick  17

    ; --- ADD unsigned ---
    MOVis   #1,    R6       ; prepare source                       ; 0011 0010 0110 0000 0000 0001 ; 326001

    ADDu    R6, R1          ; R1 was 0xFFFFFF -> test carry        ; 0000 0011 0001 0110 0000 0000 ; 031600 ; tick  22   18
    ADDu    R0, R2          ; 0 + 0x7FF -> normal                  ; 0000 0011 0010 0000 0000 0000 ; 032000

    LUI     #0x000          ; load zero into IR                    ; 0000 0001 0000 0000 0000 0000 ; 010000

    ; --- ADDi unsigned immediate ---
    ADDiu   #1,  R2         ; add small value                      ; 0010 0011 0010 0000 0000 0001 ; 232001 ; tick  25   21
    MOVis   #-1, R1         ; sign extended -1 -> 0xFFFFFF         ; 0011 0010 0001 1111 1111 1111 ; 321fff
    ADDiu   #1,  R1         ; add 1 to 0xFFFFFF -> wrap/carry      ; 0010 0011 0001 0000 0000 0001 ; 231001 ; tick  30   26

    ; --- ADDs signed ---
    MOVis   #-1,  R7        ; source -1                            ; 0011 0010 0111 1111 1111 1111 ; 327fff ; tick  31
    ADDs    R7,  R6         ; signed add -1 + 1 -> 0               ; 0001 0011 0110 0111 0000 0000 ; 136700 ; tick  35   31
    MOVis   #0x400, R8      ; 0x400 (1024)                         ; 0011 0010 1000 0100 0000 0000 ; 328400
    ADDs    R8,  R8         ; overflow positive + positive         ; 0001 0011 1000 1000 0000 0000 ; 138800 ; tick  40   36

    ; --- ADDis signed immediate ---
    ADDis   #-1, R6         ; 1 + (-1) -> 0                        ; 0011 0011 0110 1111 1111 1111 ; 336fff ; tick  41   37
    ADDis   #0x7FF, R7      ; -1 + 2047 -> edge positive           ; 0011 0011 0111 0111 1111 1111 ; 3377ff ; tick  42

    ; --- SUB unsigned ---
    SUBu    R6,  R2         ; 0x7FF - 1 -> normal                  ; 0000 0100 0010 0110 0000 0000 ; 042600 ; tick  45   41
    SUBu    R1,  R0         ; 0 - 0xFFFFFF -> underflow            ; 0000 0100 0000 0001 0000 0000 ; 040100 ; tick  46   42

    ; --- SUBi unsigned immediate ---
    SUBiu   #1,  R2         ; subtract small value                 ; 0010 0100 0010 0000 0000 0001 ; 242001
    SUBiu   #1,  R0         ; subtract from underflowed value      ; 0010 0100 0000 0000 0000 0001 ; 240001 ; tick  50   46

    ; --- SUBs signed ---
    MOVis   #-2,  R9        ; -2                                   ; 0011 0010 1001 1111 1111 1110 ; 329ffe
    SUBs    R6,  R9         ; -2 - 1 -> -3                         ; 0001 0100 1001 0110 0000 0000 ; 149600 ; tick  55   51
    MOVis   #1,   R10       ; 1                                    ; 0011 0010 1010 0000 0000 0001 ; 32a001
    SUBs    R7,  R10        ; 1 - (-1) -> 2                        ; 0001 0100 1010 0111 0000 0000 ; 14a700 ; tick  60   56
 
    ; --- SUBis signed immediate ---
    SUBis   #-1, R7         ; -1 - (-1) -> 0                       ; 0011 0100 0111 1111 1111 1111 ; 347fff
    SUBis   #0x800, R8      ; overflow with min negative immediate ; 0011 0100 1000 1000 0000 0000 ; 348800 ; tick  62   58

    ; --- NOT ---
    NOTu    R0              ; complement underflow result          ; 0000 0101 0000 0000 0000 0000 ; 050000
    NOTu    R5              ; complement negative value            ; 0000 0101 0101 0000 0000 0000 ; 055000

    ; --- AND ---
    MOVis   #0x0F0, R11     ; 0xF0                                 ; 0011 0010 1011 0000 1111 0000 ; 32b0f0 ; tick  65
    ANDu    R11, R2         ; 0x7FE & 0xF0                         ; 0000 0110 0010 1011 0000 0000 ; 062b00 ; tick  69   65
    MOVis   #0,    R12      ; zero                                 ; 0011 0010 1100 0000 0000 0000 ; 32c000 ; tick  70
    ANDu    R12, R3         ; -1 & 0 -> 0                          ; 0000 0110 0011 1100 0000 0000 ; 063c00 ; tick  74   70

    ; --- ANDi ---
    ANDiu   #0x0F, R1       ; apply mask                           ; 0010 0110 0001 0000 0000 1111 ; 26100f
    ANDiu   #0,    R2       ; result zero                          ; 0010 0110 0010 0000 0000 0000 ; 262000

    ; --- OR ---
    ORu     R11, R3         ; -1 OR 0xF0 -> -1                     ; 0000 0111 0011 1011 0000 0000 ; 073b00 ; tick  78   74
    ORu     R12, R4         ; value | 0 -> unchanged               ; 0000 0111 0100 1100 0000 0000 ; 074c00

    ; --- ORi ---
    ORiu    #0xF0, R0       ; set high bits                        ; 0010 0111 0000 0000 1111 0000 ; 2700f0
    ORiu    #0,    R6       ; no change                            ; 0010 0111 0110 0000 0000 0000 ; 276000 ; tick  81   77

    ; --- XOR ---
    XORu    R11, R4         ; mix values                           ; 0000 1000 0100 1011 0000 0000 ; 084b00
    XORu    R12, R5         ; value XOR 0 -> same                  ; 0000 1000 0101 1100 0000 0000 ; 085c00 ; tick  84   80

    ; --- XORi ---
    XORiu   #0xFF, R1       ; toggle low byte                      ; 0010 1000 0001 0000 ffff ffff ; 2810ff
    XORiu   #0,    R2       ; unchanged                            ; 0010 1000 0010 0000 0000 0000 ; 282000 ; tick  86   82

    ; --- SHL ---
    MOVis   #1,    R13      ; shift amount 1                       ; 0011 0010 1101 0000 0000 0001 ; 32d001
    SHLu    R13, R4         ; simple shift                         ; 0000 1001 0100 1101 0000 0000 ; 094d00 ; tick  91   87
    MOVis   #0x20, R14      ; 32 >= width -> overflow              ; 0011 0010 1110 0000 0010 0000 ; 32e020
    SHLu    R14, R5         ; result zero, V flag                  ; 0000 1001 0101 1110 0000 0000 ; 095e00 ; tick  96   92

    ; --- SHLi ---
    SHLiu   #4,  R6         ; left by 4                            ; 0010 1001 0110 0000 0000 0100 ; 296004
    SHLiu   #0x20, R7       ; left by 32 -> zero                   ; 0010 1001 0111 0000 0010 0000 ; 297020 ; tick  98   94

    ; --- SHR ---
    MOVis   #4,    R15      ; shift amount 4                       ; 0011 0010 1111 0000 0000 0100 ; 32f004
    SHRu    R15, R4         ; right shift                          ; 0000 1010 0100 1111 0000 0000 ; 0a4f00 ; tick 103   99
    MOVis   #0x20, R0       ; >= width                             ; 0011 0010 0000 0000 0010 0000 ; 320020
    SHRu    R0,  R5         ; result zero                          ; 0000 1010 0101 0000 0000 0000 ; 0a5000 ; tick 108  104

    ; --- SHRi ---
    SHRiu   #4,  R6         ; right by 4                           ; 0010 1010 0110 0000 0000 0100 ; 2a6004
    SHRiu   #0x20, R7       ; right by 32 -> zero                  ; 0010 1010 0111 0000 0010 0000 ; 2a7020 ; tick 110  106

    ; --- SHRs signed ---
    MOVis   #1,   R8        ; shift amount                         ; 0011 0010 1000 0000 0000 0001 ; 328001
    SHRs    R8,  R3         ; arithmetic shift -1                  ; 0001 1010 0011 1000 0000 0000 ; 1a3800 ; tick 115  111
    MOVis   #0x20, R9       ; >= width                             ; 0011 0010 1001 0000 0010 0000 ; 329020
    SHRs    R9,  R5         ; result zero                          ; 0001 1010 0101 1001 0000 0000 ; 1a5900 ; tick 120  116

    ; --- SHRis signed immediate ---
    SHRis   #1,   R3        ; -1 >> 1 keeps sign                   ; 0011 1010 0011 0000 0000 0001 ; 3a3001
    SHRis   #0x20, R4       ; shift >=24                           ; 0011 1010 0100 0000 0010 0000 ; 3a4020 ; tick 122  118

    ; --- CMP unsigned ---
    CMPu    R0,  R0         ; compare equal                        ; 0000 1011 0000 0000 0000 0000 ; 0b0000
    CMPu    R1,  R2         ; compare greater/less                 ; 0000 1011 0010 0001 0000 0000 ; 0b2100

    ; --- CMPi unsigned immediate ---
    CMPiu   #0xFF, R1       ; compare with immediate               ; 0010 1011 0001 0000 1111 1111 ; 2b10ff
    CMPiu   #0,    R2       ; compare zero                         ; 0010 1011 0010 0000 0000 0000 ; 2b2000 ; tick 126  122

    ; --- CMPs signed ---
    CMPs    R3,  R5         ; compare negatives                    ; 0001 1011 0101 0011 0000 0000 ; 1b5300
    CMPs    R2,  R6         ; compare mixed sign                   ; 0001 1011 0110 0010 0000 0000 ; 1b6200 ; tick 128  124

    ; --- CMPis signed immediate ---
    CMPis   #-1, R7         ; compare with -1                      ; 0011 1011 0111 1111 1111 1111 ; 3b7fff
    CMPis   #0x7FF, R8      ; compare positive                     ; 0011 1011 1000 0111 1111 1111 ; 3b87ff ; tick 130  126

    ; --- Special register operations ---
    LUI     #0x123          ; update IR                            ; 0000 0001 0000 0001 0010 0011 ; 010123
    SRMOV   PC, LR          ; store PC in LR                       ; 0100 0010 0001 1111 0000 0000 ; 421f00

    HLT                                                            ; 0100 0001 0000 0000 0000 0000 ; 410000
