`include "src2/sizes.vh"

module stg4mo(
    input wire                 iw_clk,
    input wire                 iw_rst,
    input wire  [`HBIT_ADDR:0] iw_pc,
    output wire [`HBIT_ADDR:0] ow_pc,
    input wire  [`HBIT_DATA:0] iw_instr,
    output wire [`HBIT_DATA:0] ow_instr
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
