`ifndef OPCODES_VH
`define OPCODES_VH

`include "src/sizes.vh"

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
`define OPC_R_SHL    8'h09
`define OPC_R_SHR    8'h0A
`define OPC_R_CMP    8'h0B
`define OPC_R_JCC    8'h0C
`define OPC_R_BCC    8'h0D
`define OPC_R_LD     8'h0E
`define OPC_R_ST     8'h0F

// REGISTER SIGNED
`define OPC_RS_ADDs  8'h13
`define OPC_RS_SUBs  8'h14
`define OPC_RS_SHRs  8'h1A
`define OPC_RS_CMPs  8'h1B

// IMMEDIATE
`define OPC_I_MOVi   8'h22
`define OPC_I_ADDi   8'h23
`define OPC_I_SUBi   8'h24
`define OPC_I_ANDi   8'h26
`define OPC_I_ORi    8'h27
`define OPC_I_XORi   8'h28
`define OPC_I_SHLi   8'h29
`define OPC_I_SHRi   8'h2A
`define OPC_I_CMPi   8'h2B
`define OPC_I_JCCi   8'h2C
`define OPC_I_STi    8'h2F

// IMMEDIATE SIGNED
`define OPC_IS_MOVis 8'h32
`define OPC_IS_ADDis 8'h33
`define OPC_IS_SUBis 8'h34
`define OPC_IS_SHRis 8'h3A
`define OPC_IS_CMPis 8'h3B
`define OPC_IS_BCCis 8'h3D
`define OPC_IS_STis  8'h3F

// SPECIAL
`define OPC_S_LUI    8'h40
`define OPC_S_SRMOV  8'h42
`define OPC_S_SRJCC  8'h4C
`define OPC_S_HLT    8'h4F

function automatic [79:0] opc2str;
    input [`HBIT_OPC:0] opc;
    begin
        case (opc)
            `OPC_NOP:      opc2str = "NOP";
            `OPC_R_MOV:    opc2str = "R_MOV";
            `OPC_R_ADD:    opc2str = "R_ADD";
            `OPC_R_SUB:    opc2str = "R_SUB";
            `OPC_R_NOT:    opc2str = "R_NOT";
            `OPC_R_AND:    opc2str = "R_AND";
            `OPC_R_OR:     opc2str = "R_OR";
            `OPC_R_XOR:    opc2str = "R_XOR";
            `OPC_R_SHL:    opc2str = "R_SHL";
            `OPC_R_SHR:    opc2str = "R_SHR";
            `OPC_R_CMP:    opc2str = "R_CMP";
            `OPC_R_JCC:    opc2str = "R_JCC";
            `OPC_R_BCC:    opc2str = "R_BCC";
            `OPC_R_LD:     opc2str = "R_LD";
            `OPC_R_ST:     opc2str = "R_ST";
            `OPC_RS_ADDs:  opc2str = "RS_ADDs";
            `OPC_RS_SUBs:  opc2str = "RS_SUBs";
            `OPC_RS_SHRs:  opc2str = "RS_SHRs";
            `OPC_RS_CMPs:  opc2str = "RS_CMPs";
            `OPC_I_MOVi:   opc2str = "I_MOVi";
            `OPC_I_ADDi:   opc2str = "I_ADDi";
            `OPC_I_SUBi:   opc2str = "I_SUBi";
            `OPC_I_ANDi:   opc2str = "I_ANDi";
            `OPC_I_ORi:    opc2str = "I_ORi";
            `OPC_I_XORi:   opc2str = "I_XORi";
            `OPC_I_SHLi:   opc2str = "I_SHLi";
            `OPC_I_SHRi:   opc2str = "I_SHRi";
            `OPC_I_CMPi:   opc2str = "I_CMPi";
            `OPC_I_JCCi:   opc2str = "I_JCCi";
            `OPC_I_STi:    opc2str = "I_STi";
            `OPC_IS_MOVis: opc2str = "IS_MOVis";
            `OPC_IS_ADDis: opc2str = "IS_ADDis";
            `OPC_IS_SUBis: opc2str = "IS_SUBis";
            `OPC_IS_SHRis: opc2str = "IS_SHRis";
            `OPC_IS_CMPis: opc2str = "IS_CMPis";
            `OPC_IS_BCCis: opc2str = "IS_BCCis";
            `OPC_IS_STis:  opc2str = "IS_STis";
            `OPC_S_LUI:    opc2str = "S_LUI";
            `OPC_S_SRMOV:  opc2str = "S_SRMOV";
            `OPC_S_SRJCC:  opc2str = "S_SRJCC";
            `OPC_S_HLT:    opc2str = "S_HLT";
            default:       opc2str = "UNKNOWN";
        endcase
    end
endfunction

`endif // OPCODES_VH
