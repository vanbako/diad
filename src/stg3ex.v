`include "src/sizes.vh"
`include "src/sr.vh"
`include "src/flags.vh"
`include "src/opcodes.vh"

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
    input wire                   iw_tgt_gp_we,
    output wire [`HBIT_TGT_GP:0] ow_tgt_gp,
    output wire                  ow_tgt_gp_we,
    input wire  [`HBIT_TGT_GP:0] iw_tgt_mamo_gp,
    input wire                   iw_tgt_mamo_gp_we,
    input wire  [`HBIT_TGT_GP:0] iw_tgt_mowb_gp,
    input wire                   iw_tgt_mowb_gp_we,
    input wire  [`HBIT_TGT_SR:0] iw_tgt_sr,
    input wire                   iw_tgt_sr_we,
    output wire [`HBIT_TGT_SR:0] ow_tgt_sr,
    output wire                  ow_tgt_sr_we,
    input wire  [`HBIT_TGT_SR:0] iw_tgt_mamo_sr,
    input wire                   iw_tgt_mamo_sr_we,
    input wire  [`HBIT_TGT_SR:0] iw_tgt_mowb_sr,
    input wire                   iw_tgt_mowb_sr_we,
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
    output wire [`HBIT_DATA:0]   ow_result,
    input wire  [`HBIT_DATA:0]   iw_mamo_result,
    input wire  [`HBIT_DATA:0]   iw_mowb_result
);
    reg [`HBIT_IMM:0]  r_ui;
    reg [`HBIT_DATA:0] r_ir;
    reg [`HBIT_DATA:0] r_se_imm_val;
    reg [`HBIT_DATA:0] r_result;
    reg [`HBIT_FLAG:0] r_fl;
    reg [`HBIT_DATA:0] r_src_val;
    reg [`HBIT_DATA:0] r_tgt_val;

    assign ow_gp_read_addr1 = iw_src_gp;
    assign ow_gp_read_addr2 = iw_tgt_gp;
    assign ow_sr_read_addr1 = iw_src_sr;
    assign ow_sr_read_addr2 = iw_tgt_sr;

    always @* begin
        r_fl         = {`SIZE_FLAG{1'b0}};
        r_result     = {`SIZE_DATA{1'b0}};
        r_ir         = {r_ui, iw_imm_val};
        r_se_imm_val = {{`SIZE_IMM{iw_imm_val[`HBIT_IMM]}}, iw_imm_val};
        // r_src_val    = iw_gp_read_data1;
        // r_tgt_val    = iw_gp_read_data2;
        if (ow_tgt_gp_we && (ow_tgt_gp == iw_src_gp))
            r_src_val = ow_result;
        else if (iw_tgt_mamo_gp_we && (iw_tgt_mamo_gp == iw_src_gp))
            r_src_val = iw_mamo_result;
        else if (iw_tgt_mowb_gp_we && (iw_tgt_mowb_gp == iw_src_gp))
            r_src_val = iw_mowb_result;
        else
            r_src_val = iw_gp_read_data1;
        if (ow_tgt_gp_we && (ow_tgt_gp == iw_tgt_gp))
            r_tgt_val = ow_result;
        else if (iw_tgt_mamo_gp_we && (iw_tgt_mamo_gp == iw_tgt_gp))
            r_tgt_val = iw_mamo_result;
        else if (iw_tgt_mowb_gp_we && (iw_tgt_mowb_gp == iw_tgt_gp))
            r_tgt_val = iw_mowb_result;
        else
            r_tgt_val = iw_gp_read_data2;
        case (iw_opc)
            `OPC_R_MOV: begin
                r_result = r_src_val;
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
            end
            `OPC_R_ADD: begin
                r_result = r_src_val + r_tgt_val;
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
                r_fl[`FLAG_C] = (r_result < r_src_val) ? 1'b1 : 1'b0;
            end
            `OPC_R_SUB: begin
                r_result = r_tgt_val - r_src_val;
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
                r_fl[`FLAG_C] = (r_tgt_val < r_src_val) ? 1'b1 : 1'b0;
            end
            `OPC_R_NOT: begin
                r_result = ~r_tgt_val;
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
            end
            `OPC_R_AND: begin
                r_result = r_src_val & r_tgt_val;
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
            end
            `OPC_R_OR: begin
                r_result = r_src_val | r_tgt_val;
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
            end
            `OPC_R_XOR: begin
                r_result = r_src_val ^ r_tgt_val;
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
            end
            `OPC_R_SHL: begin
                if (r_src_val >= `SIZE_DATA) begin
                    r_result = {`SIZE_DATA{1'b0}};
                    r_fl[`FLAG_V] = 1'b1;
                end else begin
                    r_result = r_tgt_val << r_src_val[4:0];
                    r_fl[`FLAG_V] = 1'b0;
                end
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
            end
            `OPC_R_SHR: begin
                if (r_src_val >= `SIZE_DATA) begin
                    r_result = {`SIZE_DATA{1'b0}};
                    r_fl[`FLAG_V] = 1'b1;
                end else begin
                    r_result = r_tgt_val >> r_src_val[4:0];
                    r_fl[`FLAG_V] = 1'b0;
                end
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
            end
            `OPC_R_CMP: begin
                r_fl[`FLAG_Z] = (r_src_val == r_tgt_val) ? 1'b1 : 1'b0;
                r_fl[`FLAG_C] = (r_src_val < r_tgt_val) ? 1'b1 : 1'b0;
            end
            `OPC_RS_ADDs: begin
                r_result = $signed(r_src_val) + $signed(r_tgt_val);
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
                r_fl[`FLAG_N] = ($signed(r_result) < 0) ? 1'b1 : 1'b0;
                r_fl[`FLAG_V] =
                    ((~(r_src_val[`HBIT_DATA-1] ^ r_tgt_val[`HBIT_DATA-1])) &&
                    (r_src_val[`HBIT_DATA-1] ^ r_result[`HBIT_DATA-1])) ? 1'b1 : 1'b0;
            end
            `OPC_RS_SUBs: begin
                r_result = $signed(r_tgt_val) - $signed(r_src_val);
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
                r_fl[`FLAG_N] = ($signed(r_result) < 0) ? 1'b1 : 1'b0;
                r_fl[`FLAG_V] =
                    ((r_src_val[`HBIT_DATA-1] ^ r_tgt_val[`HBIT_DATA-1]) &&
                    (r_tgt_val[`HBIT_DATA-1] ^ r_result[`HBIT_DATA-1])) ? 1'b1 : 1'b0;
            end
            `OPC_RS_SHRs: begin
                if (r_src_val >= `SIZE_DATA) begin
                    r_result = {`SIZE_DATA{1'b0}};
                    r_fl[`FLAG_V] = 1'b1;
                end else begin
                    r_result = $signed(r_tgt_val) >>> r_src_val[4:0];
                    r_fl[`FLAG_V] = 1'b0;
                end
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
                r_fl[`FLAG_N] = (r_result[`HBIT_DATA] == 1'b1) ? 1'b1 : 1'b0;
            end
            `OPC_RS_CMPs: begin
                reg signed [`HBIT_DATA:0] s_diff;
                s_diff = $signed(r_tgt_val) - $signed(r_src_val);
                r_fl[`FLAG_Z] = (r_src_val == r_tgt_val) ? 1'b1 : 1'b0;
                r_fl[`FLAG_N] = (s_diff < 0) ? 1'b1 : 1'b0;
                r_fl[`FLAG_V] =
                    ((r_src_val[`HBIT_DATA] ^ r_tgt_val[`HBIT_DATA]) &
                    (r_src_val[`HBIT_DATA] ^ s_diff[`HBIT_DATA]));
            end
            `OPC_I_MOVi: begin
                r_result = r_ir;
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
            end
            `OPC_I_ADDi: begin
                r_result = r_tgt_val + r_ir;
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
                r_fl[`FLAG_C] = (r_result < r_tgt_val) ? 1'b1 : 1'b0;
            end
            `OPC_I_SUBi: begin
                r_result = r_tgt_val - r_ir;
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
                r_fl[`FLAG_C] = (r_tgt_val < r_ir) ? 1'b1 : 1'b0;
            end
            `OPC_I_ANDi: begin
                r_result = r_tgt_val & r_ir;
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
            end
            `OPC_I_ORi: begin
                r_result = r_tgt_val | r_ir;
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
            end
            `OPC_I_XORi: begin
                r_result = r_tgt_val ^ r_ir;
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
            end
            `OPC_I_SHLi: begin
                if (r_ir >= `SIZE_DATA) begin
                    r_result = {`SIZE_DATA{1'b0}};
                    r_fl[`FLAG_V] = 1'b1;
                end else begin
                    r_result = r_tgt_val << r_ir[4:0];
                    r_fl[`FLAG_V] = 1'b0;
                end
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
            end
            `OPC_I_SHRi: begin
                if (r_ir >= `SIZE_DATA) begin
                    r_result = {`SIZE_DATA{1'b0}};
                    r_fl[`FLAG_V] = 1'b1;
                end else begin
                    r_result = r_tgt_val >> r_ir[4:0];
                    r_fl[`FLAG_V] = 1'b0;
                end
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
            end
            `OPC_I_CMPi: begin
                r_fl[`FLAG_Z] = (r_tgt_val == r_ir) ? 1'b1 : 1'b0;
                r_fl[`FLAG_C] = (r_tgt_val < r_ir) ? 1'b1 : 1'b0;
            end
            `OPC_IS_MOVis: begin
                r_result = r_se_imm_val;
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
            end
            `OPC_IS_ADDis: begin
                r_result = $signed(r_tgt_val) + $signed(r_se_imm_val);
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
                r_fl[`FLAG_N] = ($signed(r_result) < 0) ? 1'b1 : 1'b0;
                r_fl[`FLAG_V] =
                    ((~(r_tgt_val[`HBIT_DATA-1] ^ r_se_imm_val[`HBIT_DATA-1])) &&
                    (r_tgt_val[`HBIT_DATA-1] ^ r_result[`HBIT_DATA-1])) ? 1'b1 : 1'b0;
            end
            `OPC_IS_SUBis: begin
                r_result = $signed(r_tgt_val) - $signed(r_se_imm_val);
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
                r_fl[`FLAG_N] = ($signed(r_result) < 0) ? 1'b1 : 1'b0;
                r_fl[`FLAG_V] =
                    ((r_se_imm_val[`HBIT_DATA-1] ^ r_tgt_val[`HBIT_DATA-1]) &&
                    (r_tgt_val[`HBIT_DATA-1] ^ r_result[`HBIT_DATA-1])) ? 1'b1 : 1'b0;
            end
            `OPC_IS_SHRis: begin
                if (iw_imm_val >= `SIZE_DATA) begin
                    r_result = {`SIZE_DATA{1'b0}};
                    r_fl[`FLAG_V] = 1'b1;
                end else begin
                    r_result = $signed(r_tgt_val) >>> iw_imm_val[4:0];
                    r_fl[`FLAG_V] = 1'b0;
                end
                r_fl[`FLAG_Z] = (r_result == {`SIZE_DATA{1'b0}}) ? 1'b1 : 1'b0;
                r_fl[`FLAG_N] = (r_result[`HBIT_DATA] == 1'b1) ? 1'b1 : 1'b0;
            end
            `OPC_IS_CMPis: begin
                reg signed [`HBIT_DATA:0] s_diff;
                s_diff = $signed(r_tgt_val) - $signed(r_se_imm_val);
                r_fl[`FLAG_Z] = (r_tgt_val == r_se_imm_val) ? 1'b1 : 1'b0;
                r_fl[`FLAG_N] = (s_diff < 0) ? 1'b1 : 1'b0;
                r_fl[`FLAG_V] = ((r_tgt_val[`HBIT_DATA] ^ r_se_imm_val[`HBIT_DATA]) &
                                 (r_tgt_val[`HBIT_DATA] ^ s_diff[`HBIT_DATA]));
            end
            `OPC_S_LUI: begin
                r_ui = iw_imm_val;
            end
            `OPC_S_SRMOV: begin
                r_result = (iw_src_sr == `INDEX_PC) ? iw_pc : r_src_val;
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
    reg                  r_tgt_gp_we;
    reg [`HBIT_TGT_SR:0] r_tgt_sr;
    reg                  r_tgt_sr_we;
    reg [`HBIT_DATA:0]   r_result_latch;
    always @(posedge iw_clk or posedge iw_rst) begin
        if (iw_rst) begin
            r_pc_latch     <= `SIZE_ADDR'b0;
            r_instr_latch  <= `SIZE_DATA'b0;
            r_opc          <= `SIZE_OPC'b0;
            r_tgt_gp       <= `SIZE_TGT_GP'b0;
            r_tgt_gp_we    <= 1'b0;
            r_tgt_sr       <= `SIZE_TGT_SR'b0;
            r_tgt_sr_we    <= 1'b0;
            r_result_latch <= `SIZE_DATA'b0;
        end
        else begin
            r_pc_latch     <= iw_pc;
            r_instr_latch  <= iw_instr;
            r_opc          <= iw_opc;
            r_tgt_gp       <= iw_tgt_gp;
            r_tgt_gp_we    <= iw_tgt_gp_we;
            r_tgt_sr       <= iw_tgt_sr;
            r_tgt_sr_we    <= iw_tgt_sr_we;
            r_result_latch <= r_result;
        end
    end
    assign ow_pc        = r_pc_latch;
    assign ow_instr     = r_instr_latch;
    assign ow_opc       = r_opc;
    assign ow_tgt_gp    = r_tgt_gp;
    assign ow_tgt_gp_we = r_tgt_gp_we;
    assign ow_tgt_sr    = r_tgt_sr;
    assign ow_tgt_sr_we = r_tgt_sr_we;
    assign ow_result    = r_result_latch;
endmodule
