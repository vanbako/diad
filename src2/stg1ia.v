`include "src2/sizes.vh"

module stg1ia(
    input wire                 iw_clk,
    input wire                 iw_rst,
    output wire [`HBIT_ADDR:0] ow_mem_addr,
    input wire  [`HBIT_ADDR:0] iw_pc,
    output wire [`HBIT_ADDR:0] ow_pc
);
    reg [`HBIT_ADDR:0] r_pc_latch;
    always @(posedge iw_clk or posedge iw_rst) begin
        if (iw_rst) begin
            r_pc_latch <= `SIZE_ADDR'b0;
        end else begin
            r_pc_latch <= iw_pc;
        end
    end
    assign ow_mem_addr = iw_pc;
    assign ow_pc       = r_pc_latch;
endmodule
