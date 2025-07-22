`include "src/sizes.vh"

module stg1ia(
    input wire                 iw_clk,
    input wire                 iw_rst,
    input wire                 iw_flush,
    output wire [`HBIT_ADDR:0] ow_mem_addr [0:1],
    input wire  [`HBIT_ADDR:0] iw_pc,
    output wire [`HBIT_ADDR:0] ow_pc,
    output wire                ow_ia_valid,
    input wire  [`HBIT_ADDR:0] iw_pred_pc,
    input wire                 iw_pred_taken,
    output wire [`HBIT_ADDR:0] ow_pred_pc,
    output wire                ow_pred_taken
);
    reg [`HBIT_ADDR:0] r_pc_latch;
    reg                r_ia_valid_latch;
    reg [`HBIT_ADDR:0] r_pred_pc_latch;
    reg                r_pred_taken_latch;
    always @(posedge iw_clk or posedge iw_rst) begin
        if (iw_rst) begin
            r_pc_latch        <= `SIZE_ADDR'b0;
            r_pred_pc_latch   <= `SIZE_ADDR'b0;
            r_pred_taken_latch<= 1'b0;
            r_ia_valid_latch  <= 1'b0;
        end else begin
            r_pc_latch        <= iw_pc;
            r_pred_pc_latch   <= iw_pred_pc;
            r_pred_taken_latch<= iw_pred_taken;
            r_ia_valid_latch  <= ~iw_flush;
        end
    end
    assign ow_mem_addr[0] = iw_pc;
    assign ow_pc          = r_pc_latch;
    assign ow_pred_pc     = r_pred_pc_latch;
    assign ow_pred_taken  = r_pred_taken_latch;
    assign ow_ia_valid    = r_ia_valid_latch;
endmodule
