`ifndef OPCODES_VH
`define OPCODES_VH

// OPCODE DEFINITIONS
`define OPC_NOP      8'h00

// REGISTER
`define OPC_R_MOV    8'h02
`define OPC_R_ADD    8'h03
`define OPC_R_SUB    8'h04
`define OPC_R_NOT    8'h05
`define OPC_R_AND    8'h06
`define OPC_R_OR     8'h07
`define OPC_R_XOR    8'h08
`define OPC_R_SL     8'h09
`define OPC_R_SR     8'h0A
`define OPC_R_CMP    8'h0B
`define OPC_R_JCC    8'h0C
`define OPC_R_BCC    8'h0D
`define OPC_R_LD     8'h0E
`define OPC_R_ST     8'h0F

// REGISTER SIGNED
`define OPC_RS_ADDs  8'h13
`define OPC_RS_SUBs  8'h14
`define OPC_RS_SRs   8'h1A
`define OPC_RS_CMPs  8'h1B

// IMMEDIATE
`define OPC_I_MOVi   8'h22
`define OPC_I_ADDi   8'h23
`define OPC_I_SUBi   8'h24
`define OPC_I_ANDi   8'h26
`define OPC_I_ORi    8'h27
`define OPC_I_XORi   8'h28
`define OPC_I_SLi    8'h29
`define OPC_I_SRi    8'h2A
`define OPC_I_CMPi   8'h2B
`define OPC_I_JCCi   8'h2C
`define OPC_I_LDi    8'h2E
`define OPC_I_STi    8'h2F

// IMMEDIATE SIGNED
`define OPC_IS_MOVis 8'h32
`define OPC_IS_ADDis 8'h33
`define OPC_IS_SUBis 8'h34
`define OPC_IS_SRis  8'h3A
`define OPC_IS_CMPis 8'h3B
`define OPC_IS_BCCis 8'h3D

// SPECIAL
`define OPC_S_LUI    8'h40
`define OPC_S_SRMOV  8'h42
`define OPC_S_SRJCC  8'h4C
`define OPC_S_HLT    8'h4F

`endif // OPCODES_VH
