`include "src/sizes.vh"

module stg1if(
    input wire                 iw_clk,
    input wire                 iw_rst,
    input wire  [`HBIT_DATA:0] iw_mem_data [0:1],
    input wire                 iw_ia_valid,
    input wire  [`HBIT_ADDR:0] iw_pc,
    input wire  [`HBIT_ADDR:0] iw_pred_pc,
    input wire                 iw_pred_taken,
    input wire                 iw_flush,
    output wire [`HBIT_ADDR:0] ow_pc,
    output wire [`HBIT_ADDR:0] ow_pred_pc,
    output wire                ow_pred_taken,
    output wire [`HBIT_DATA:0] ow_instr
);
    reg [`HBIT_ADDR:0] r_pc_latch;
    reg [`HBIT_DATA:0] r_instr_latch;
    reg [`HBIT_ADDR:0] r_pred_pc_latch;
    reg                r_pred_taken_latch;
    always @(posedge iw_clk or posedge iw_rst) begin
        if (iw_rst || iw_flush) begin
            r_pc_latch        <= `SIZE_ADDR'b0;
            r_instr_latch     <= `SIZE_DATA'b0;
            r_pred_pc_latch   <= `SIZE_ADDR'b0;
            r_pred_taken_latch<= 1'b0;
        end else if (iw_ia_valid) begin
            r_pc_latch        <= iw_pc;
            r_instr_latch     <= iw_mem_data[0];
            r_pred_pc_latch   <= iw_pred_pc;
            r_pred_taken_latch<= iw_pred_taken;
        end
    end
    assign ow_pc         = r_pc_latch;
    assign ow_pred_pc    = r_pred_pc_latch;
    assign ow_pred_taken = r_pred_taken_latch;
    assign ow_instr      = r_instr_latch;
endmodule
