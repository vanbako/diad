`include "src2/sizes.vh"

module mem(
    input wire               iw_clk,
    input wire               iw_we,
    input wire [`HBIT_ADDR:0] iw_addr,
    input wire [`HBIT_DATA:0] iw_wdata,
    output reg [`HBIT_DATA:0] or_rdata
);
    reg [`HBIT_DATA:0] r_mem [0:4095];
    always @(posedge iw_clk) begin
        if (iw_we) r_mem[iw_addr] <= iw_wdata;
        or_rdata <= r_mem[iw_addr];
    end
endmodule
