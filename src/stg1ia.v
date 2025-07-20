`include "src/sizes.vh"

module stg1ia(
    input wire                 iw_clk,
    input wire                 iw_rst,
    output wire [`HBIT_ADDR:0] ow_mem_addr,
    input wire  [`HBIT_ADDR:0] iw_pc,
    output wire [`HBIT_ADDR:0] ow_pc,
    output wire                ow_ia_valid
);
    reg [`HBIT_ADDR:0] r_pc_latch;
    reg                r_ia_valid_latch;
    always @(posedge iw_clk or posedge iw_rst) begin
        if (iw_rst) begin
            r_pc_latch       <= `SIZE_ADDR'b0;
            r_ia_valid_latch <= 1'b0;
        end else begin
            r_pc_latch       <= iw_pc;
            r_ia_valid_latch <= 1'b1;
        end
    end
    assign ow_mem_addr = iw_pc;
    assign ow_pc       = r_pc_latch;
    assign ow_ia_valid = r_ia_valid_latch;
endmodule
