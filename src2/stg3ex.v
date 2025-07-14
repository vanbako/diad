`include "src2/sizes.vh"

module stg3ex(
    input wire                   iw_clk,
    input wire                   iw_rst,
    input wire  [`HBIT_ADDR:0]   iw_pc,
    output wire [`HBIT_ADDR:0]   ow_pc,
    input wire  [`HBIT_DATA:0]   iw_instr,
    output wire [`HBIT_DATA:0]   ow_instr,
    input wire  [`HBIT_OPC:0]    iw_opc,
    input wire                   iw_sgn_en,
    input wire                   iw_imm_en,
    input wire  [`HBIT_IMM:0]    iw_imm_val,
    input wire  [`HBIT_IMMSR:0]  iw_immsr_val,
    input wire  [`HBIT_CC:0]     iw_cc,
    input wire  [`HBIT_TGT_GP:0] iw_tgt_gp,
    input wire  [`HBIT_TGT_SR:0] iw_tgt_sr,
    input wire  [`HBIT_SRC_GP:0] iw_src_gp,
    input wire  [`HBIT_SRC_SR:0] iw_src_sr
);
    reg [`HBIT_ADDR:0] r_pc_latch;
    reg [`HBIT_DATA:0] r_instr_latch;
    always @(posedge iw_clk or posedge iw_rst) begin
        if (iw_rst) begin
            r_pc_latch    <= `SIZE_ADDR'b0;
            r_instr_latch <= `SIZE_DATA'b0;
        end
        else begin
            r_pc_latch    <= iw_pc;
            r_instr_latch <= iw_instr;
        end
    end
    assign ow_pc    = r_pc_latch;
    assign ow_instr = r_instr_latch;
endmodule
