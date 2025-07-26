`ifndef OPCODES_VH
`define OPCODES_VH

`include "src/sizes.vh"

// OPCODE DEFINITIONS
`define OPC_NOP       8'h00

// REGISTER UNSIGNED
`define OPC_RU_LUI    8'h01
`define OPC_RU_MOVu   8'h02
`define OPC_RU_ADDu   8'h03
`define OPC_RU_SUBu   8'h04
`define OPC_RU_NOTu   8'h05
`define OPC_RU_ANDu   8'h06
`define OPC_RU_ORu    8'h07
`define OPC_RU_XORu   8'h08
`define OPC_RU_SHLu   8'h09
`define OPC_RU_SHRu   8'h0A
`define OPC_RU_CMPu   8'h0B
`define OPC_RU_JCCu   8'h0C
`define OPC_RU_LDu    8'h0E
`define OPC_RU_STu    8'h0F

// REGISTER SIGNED
`define OPC_RS_ADDs   8'h13
`define OPC_RS_SUBs   8'h14
`define OPC_RS_SHRs   8'h1A
`define OPC_RS_CMPs   8'h1B
`define OPC_RS_BCCs   8'h1D

// IMMEDIATE UNSIGNED
`define OPC_IU_MOViu  8'h22
`define OPC_IU_ADDiu  8'h23
`define OPC_IU_SUBiu  8'h24
`define OPC_IU_ANDiu  8'h26
`define OPC_IU_ORiu   8'h27
`define OPC_IU_XORiu  8'h28
`define OPC_IU_SHLiu  8'h29
`define OPC_IU_SHRiu  8'h2A
`define OPC_IU_CMPiu  8'h2B
`define OPC_IU_JCCiu  8'h2C
`define OPC_IU_STiu   8'h2F

// IMMEDIATE SIGNED
`define OPC_IS_MOVis  8'h32
`define OPC_IS_ADDis  8'h33
`define OPC_IS_SUBis  8'h34
`define OPC_IS_SHRis  8'h3A
`define OPC_IS_CMPis  8'h3B
`define OPC_IS_BCCis  8'h3D
`define OPC_IS_STis   8'h3F

// SPECIAL REGISTER
`define OPC_SR_HLT     8'h41
`define OPC_SR_SRMOVu  8'h42
`define OPC_SR_SRJCCu  8'h4C

function automatic [79:0] opc2str;
    input [`HBIT_OPC:0] opc;
    begin
        case (opc)
            `OPC_NOP:       opc2str = "NOP";
            `OPC_RU_LUI:    opc2str = "RU_LUI";
            `OPC_RU_MOVu:   opc2str = "RU_MOVu";
            `OPC_RU_ADDu:   opc2str = "RU_ADDu";
            `OPC_RU_SUBu:   opc2str = "RU_SUBu";
            `OPC_RU_NOTu:   opc2str = "RU_NOTu";
            `OPC_RU_ANDu:   opc2str = "RU_ANDu";
            `OPC_RU_ORu:    opc2str = "RU_ORu";
            `OPC_RU_XORu:   opc2str = "RU_XORu";
            `OPC_RU_SHLu:   opc2str = "RU_SHLu";
            `OPC_RU_SHRu:   opc2str = "RU_SHRu";
            `OPC_RU_CMPu:   opc2str = "RU_CMPu";
            `OPC_RU_JCCu:   opc2str = "RU_JCCu";
            `OPC_RU_LDu:    opc2str = "RU_LDu";
            `OPC_RU_STu:    opc2str = "RU_STu";
            `OPC_RS_ADDs:   opc2str = "RS_ADDs";
            `OPC_RS_SUBs:   opc2str = "RS_SUBs";
            `OPC_RS_SHRs:   opc2str = "RS_SHRs";
            `OPC_RS_CMPs:   opc2str = "RS_CMPs";
            `OPC_RS_BCCs:   opc2str = "RS_BCCs";
            `OPC_IU_MOViu:  opc2str = "IU_MOViu";
            `OPC_IU_ADDiu:  opc2str = "IU_ADDiu";
            `OPC_IU_SUBiu:  opc2str = "IU_SUBiu";
            `OPC_IU_ANDiu:  opc2str = "IU_ANDiu";
            `OPC_IU_ORiu:   opc2str = "IU_ORiu";
            `OPC_IU_XORiu:  opc2str = "IU_XORiu";
            `OPC_IU_SHLiu:  opc2str = "IU_SHLiu";
            `OPC_IU_SHRiu:  opc2str = "IU_SHRiu";
            `OPC_IU_CMPiu:  opc2str = "IU_CMPiu";
            `OPC_IU_JCCiu:  opc2str = "IU_JCCiu";
            `OPC_IU_STiu:   opc2str = "IU_STiu";
            `OPC_IS_MOVis:  opc2str = "IS_MOVis";
            `OPC_IS_ADDis:  opc2str = "IS_ADDis";
            `OPC_IS_SUBis:  opc2str = "IS_SUBis";
            `OPC_IS_SHRis:  opc2str = "IS_SHRis";
            `OPC_IS_CMPis:  opc2str = "IS_CMPis";
            `OPC_IS_BCCis:  opc2str = "IS_BCCis";
            `OPC_IS_STis:   opc2str = "IS_STis";
            `OPC_SR_HLT:    opc2str = "SR_HLT";
            `OPC_SR_SRMOVu: opc2str = "SR_SRMOVu";
            `OPC_SR_SRJCCu: opc2str = "SR_SRJCCu";
            default:        opc2str = "UNKNOWN";
        endcase
    end
endfunction

`endif // OPCODES_VH
