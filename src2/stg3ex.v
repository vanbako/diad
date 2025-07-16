`include "src2/sizes.vh"
`include "src2/sr.vh"
`include "src2/flags.vh"
`include "src2/opc.vh"

module stg3ex(
    input wire                   iw_clk,
    input wire                   iw_rst,
    input wire  [`HBIT_ADDR:0]   iw_pc,
    output wire [`HBIT_ADDR:0]   ow_pc,
    input wire  [`HBIT_DATA:0]   iw_instr,
    output wire [`HBIT_DATA:0]   ow_instr,
    input wire  [`HBIT_OPC:0]    iw_opc,
    output wire [`HBIT_OPC:0]    ow_opc,
    input wire                   iw_sgn_en,
    input wire                   iw_imm_en,
    input wire  [`HBIT_IMM:0]    iw_imm_val,
    input wire  [`HBIT_IMMSR:0]  iw_immsr_val,
    input wire  [`HBIT_CC:0]     iw_cc,
    input wire  [`HBIT_TGT_GP:0] iw_tgt_gp,
    output wire [`HBIT_TGT_GP:0] ow_tgt_gp,
    input wire  [`HBIT_TGT_SR:0] iw_tgt_sr,
    output wire [`HBIT_TGT_SR:0] ow_tgt_sr,
    input wire  [`HBIT_SRC_GP:0] iw_src_gp,
    input wire  [`HBIT_SRC_SR:0] iw_src_sr,
    output wire [`HBIT_TGT_GP:0] ow_gp_read_addr1,
    output wire [`HBIT_TGT_GP:0] ow_gp_read_addr2,
    input wire  [`HBIT_DATA:0]   iw_gp_read_data1,
    input wire  [`HBIT_DATA:0]   iw_gp_read_data2,
    output wire [`HBIT_TGT_SR:0] ow_sr_read_addr1,
    output wire [`HBIT_TGT_SR:0] ow_sr_read_addr2,
    input wire  [`HBIT_DATA:0]   iw_sr_read_data1,
    input wire  [`HBIT_DATA:0]   iw_sr_read_data2,
    output wire [`HBIT_DATA:0]   ow_result
);
    reg [`HBIT_IMM:0]  r_ui;
    reg [`HBIT_DATA:0] r_ir;
    reg [`HBIT_DATA:0] r_se_imm_val;
    reg [`HBIT_DATA:0] r_result;
    reg [`HBIT_FLAG:0] r_fl;

    assign ow_gp_read_addr1 = iw_src_gp;
    assign ow_gp_read_addr2 = iw_tgt_gp;
    assign ow_sr_read_addr1 = iw_src_sr;
    assign ow_sr_read_addr2 = iw_tgt_sr;

    always @* begin
        r_fl         = {`SIZE_FLAG{1'b0}};
        r_result     = {`SIZE_DATA{1'b0}};
        r_ir         = {r_ui, iw_imm_val};
        r_se_imm_val = {{`SIZE_IMM{iw_imm_val[`HBIT_IMM]}}, iw_imm_val};
        case (iw_opc)
            `OPC_R_MOV: begin
                r_result = iw_gp_read_data1;
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
            end
            `OPC_R_ADD: begin
                r_result = iw_gp_read_data1 + iw_gp_read_data2;
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
                r_fl[`FLAG_C] = (r_result < iw_gp_read_data1) ? 1'b1 : 1'b0;
            end
            `OPC_R_SUB: begin
                r_result = iw_gp_read_data1 - iw_gp_read_data2;
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
                r_fl[`FLAG_C] = (iw_gp_read_data1 < iw_gp_read_data2) ? 1'b1 : 1'b0;
            end
            `OPC_R_NOT: begin
                r_result = ~iw_gp_read_data2;
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
            end
            `OPC_R_AND: begin
                r_result = iw_gp_read_data1 & iw_gp_read_data2;
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
            end
            `OPC_R_OR: begin
                r_result = iw_gp_read_data1 | iw_gp_read_data2;
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
            end
            `OPC_R_XOR: begin
                r_result = iw_gp_read_data1 ^ iw_gp_read_data2;
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
            end
            `OPC_R_SHL: begin
                if (iw_gp_read_data1 >= `SIZE_DATA) begin
                    r_result = {`SIZE_DATA{1'b0}};
                    r_fl[`FLAG_V] = 1'b1;
                end else begin
                    r_result = iw_gp_read_data2 << iw_gp_read_data1[4:0];
                    r_fl[`FLAG_V] = 1'b0;
                end
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
            end
            `OPC_R_SHR: begin
                if (iw_gp_read_data1 >= `SIZE_DATA) begin
                    r_result = {`SIZE_DATA{1'b0}};
                    r_fl[`FLAG_V] = 1'b1;
                end else begin
                    r_result = iw_gp_read_data2 >> iw_gp_read_data1[4:0];
                    r_fl[`FLAG_V] = 1'b0;
                end
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
            end
            `OPC_R_CMP: begin
                r_fl[`FLAG_Z] = (iw_gp_read_data1 == iw_gp_read_data2) ? 1'b1 : 1'b0;
                r_fl[`FLAG_C] = (iw_gp_read_data1 < iw_gp_read_data2) ? 1'b1 : 1'b0;
            end
            `OPC_RS_ADDs: begin
                r_result = $signed(iw_gp_read_data1) + $signed(iw_gp_read_data2);
            end
            `OPC_RS_SUBs: begin
                r_result = $signed(iw_gp_read_data1) - $signed(iw_gp_read_data2);
            end
            `OPC_RS_SHRs: begin
                r_result = $signed(iw_gp_read_data2) >>> iw_gp_read_data1[4:0];
            end
            `OPC_RS_CMPs: begin
                reg signed [`HBIT_DATA:0] s_diff;
                s_diff = $signed(iw_gp_read_data1) - $signed(iw_gp_read_data2);
                r_fl[`FLAG_Z] = (iw_gp_read_data1 == iw_gp_read_data2) ? 1'b1 : 1'b0;
                r_fl[`FLAG_N] = (s_diff < 0) ? 1'b1 : 1'b0;
                r_fl[`FLAG_V] = ((iw_gp_read_data1[`HBIT_DATA] ^ iw_gp_read_data2[`HBIT_DATA]) &
                                 (iw_gp_read_data1[`HBIT_DATA] ^ s_diff[`HBIT_DATA]));
            end
            `OPC_I_MOVi: begin
                r_result = r_ir;
            end
            `OPC_I_ADDi: begin
                r_result = iw_gp_read_data1 + r_ir;
            end
            `OPC_I_SUBi: begin
                r_result = iw_gp_read_data1 - r_ir;
            end
            `OPC_I_ANDi: begin
                r_result = iw_gp_read_data1 & r_ir;
            end
            `OPC_I_ORi: begin
                r_result = iw_gp_read_data1 | r_ir;
            end
            `OPC_I_XORi: begin
                r_result = iw_gp_read_data1 ^ r_ir;
            end
            `OPC_I_SHLi: begin
                r_result = iw_gp_read_data1 << iw_imm_val[4:0];
            end
            `OPC_I_SHRi: begin
                r_result = iw_gp_read_data1 >> iw_imm_val[4:0];
            end
            `OPC_R_CMPi: begin
                r_fl[`FLAG_Z] = (iw_gp_read_data1 == r_ir) ? 1'b1 : 1'b0;
                r_fl[`FLAG_C] = (iw_gp_read_data1 < r_ir) ? 1'b1 : 1'b0;
            end
            `OPC_IS_MOVis: begin
                r_result = r_se_imm_val;
            end
            `OPC_IS_ADDis: begin
                r_result = $signed(iw_gp_read_data1) + $signed(r_se_imm_val);
            end
            `OPC_IS_SUBis: begin
                r_result = $signed(iw_gp_read_data1) - $signed(r_se_imm_val);
            end
            `OPC_IS_SHRis: begin
                r_result = $signed(iw_gp_read_data1) >> iw_imm_val[4:0];
            end
            `OPC_RS_CMPis: begin
                reg signed [`HBIT_DATA:0] s_diff;
                s_diff = $signed(iw_gp_read_data1) - $signed(r_se_imm_val);
                r_fl[`FLAG_Z] = (iw_gp_read_data1 == r_se_imm_val) ? 1'b1 : 1'b0;
                r_fl[`FLAG_N] = (s_diff < 0) ? 1'b1 : 1'b0;
                r_fl[`FLAG_V] = ((iw_gp_read_data1[`HBIT_DATA] ^ r_se_imm_val[`HBIT_DATA]) &
                                 (iw_gp_read_data1[`HBIT_DATA] ^ s_diff[`HBIT_DATA]));
            end
            `OPC_S_LUI: begin
                r_ui = iw_imm_val;
            end
            `OPC_S_SRMOV: begin
                r_result = (iw_src_sr == `INDEX_PC) ? iw_pc : iw_sr_read_data1;
            end
            default: begin
                r_result = `SIZE_DATA'b0;
                r_fl     = `SIZE_FLAG'b0;
            end
        endcase
    end

    reg [`HBIT_ADDR:0]   r_pc_latch;
    reg [`HBIT_DATA:0]   r_instr_latch;
    reg [`HBIT_OPC:0]    r_opc;
    reg [`HBIT_TGT_GP:0] r_tgt_gp;
    reg [`HBIT_TGT_SR:0] r_tgt_sr;
    reg [`HBIT_DATA:0]   r_result_latch;
    always @(posedge iw_clk or posedge iw_rst) begin
        if (iw_rst) begin
            r_pc_latch     <= `SIZE_ADDR'b0;
            r_instr_latch  <= `SIZE_DATA'b0;
            r_opc          <= `SIZE_OPC'b0;
            r_tgt_gp       <= `SIZE_TGT_GP'b0;
            r_tgt_sr       <= `SIZE_TGT_SR'b0;
            r_result_latch <= `SIZE_DATA'b0;
        end
        else begin
            r_pc_latch     <= iw_pc;
            r_instr_latch  <= iw_instr;
            r_opc          <= iw_opc;
            r_tgt_gp       <= iw_tgt_gp;
            r_tgt_sr       <= iw_tgt_sr;
            r_result_latch <= r_result;
        end
    end
    assign ow_pc     = r_pc_latch;
    assign ow_instr  = r_instr_latch;
    assign ow_opc    = r_opc;
    assign ow_tgt_gp = r_tgt_gp;
    assign ow_tgt_sr = r_tgt_sr;
    assign ow_result = r_result_latch;
endmodule
