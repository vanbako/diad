`ifndef CC_VH
`define CC_VH

`include "src2/sizes.vh"

`define CC_RA 4'h0
`define CC_EQ 4'h1
`define CC_NE 4'h2
`define CC_LT 4'h3
`define CC_GT 4'h4
`define CC_LE 4'h5
`define CC_GE 4'h6

function automatic [79:0] cc2str;
    input [`HBIT_CC:0] cc;
    begin
        case (cc)
            `CC_RA:  cc2str = "RA";
            `CC_EQ:  cc2str = "EQ";
            `CC_NE:  cc2str = "NE";
            `CC_LT:  cc2str = "LT";
            `CC_GT:  cc2str = "GT";
            `CC_LE:  cc2str = "LE";
            `CC_GE:  cc2str = "GE";
            default: cc2str = "UN";
        endcase
    end
endfunction

`endif
