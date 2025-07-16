`ifndef SIZES_VH
`define SIZES_VH

`define SIZE_ADDR 24
`define SIZE_DATA 24
`define SIZE_FLAG  4

`define SIZE_OPC     8
`define SIZE_CC      4
`define SIZE_IMM    12
`define SIZE_IMMSR   8
`define SIZE_TGT_GP  4
`define SIZE_TGT_SR  4
`define SIZE_SRC_GP  4
`define SIZE_SRC_SR  4

`define HBIT_GP   15
`define HBIT_SR   15
`define HBIT_ADDR 23
`define HBIT_DATA 23
`define HBIT_FLAG  3

`define HBIT_INSTR_OPC    23
`define LBIT_INSTR_OPC    16
`define HBIT_INSTR_CC     15
`define LBIT_INSTR_CC     12
`define HBIT_INSTR_TGT_GP 15
`define LBIT_INSTR_TGT_GP 12
`define HBIT_INSTR_TGT_SR 15
`define LBIT_INSTR_TGT_SR 12
`define HBIT_INSTR_SRC_GP 11
`define LBIT_INSTR_SRC_GP  8
`define HBIT_INSTR_SRC_SR 11
`define LBIT_INSTR_SRC_SR  8
`define HBIT_INSTR_IMM    11
`define LBIT_INSTR_IMM     0
`define HBIT_INSTR_IMMSR   7
`define LBIT_INSTR_IMMSR   0

`define HBIT_OPC     7
`define HBIT_IMM    11
`define HBIT_IMMSR   7
`define HBIT_CC      3
`define HBIT_TGT_GP  3
`define HBIT_TGT_SR  3
`define HBIT_SRC_GP  3
`define HBIT_SRC_SR  3

`endif
