`include "src/sizes.vh"

module bpredict #(
    parameter INDEX_BITS = 4
)(
    input wire                   iw_clk,
    input wire                   iw_rst,
    input wire  [`HBIT_ADDR:0]   iw_pc,
    output wire                  ow_taken,
    output wire [`HBIT_ADDR:0]   ow_target,
    input wire                   iw_update,
    input wire  [`HBIT_ADDR:0]   iw_update_pc,
    input wire                   iw_actual_taken,
    input wire  [`HBIT_ADDR:0]   iw_actual_target
);
    localparam ENTRY_NUM = 1 << INDEX_BITS;
    reg                        r_taken [0:ENTRY_NUM-1];
    reg [`HBIT_ADDR:0]         r_target[0:ENTRY_NUM-1];
    integer i;
    wire [INDEX_BITS-1:0] w_index = iw_pc[INDEX_BITS-1:0];
    wire [INDEX_BITS-1:0] w_uindex = iw_update_pc[INDEX_BITS-1:0];

    assign ow_taken  = r_taken[w_index];
    assign ow_target = r_target[w_index];

    always @(posedge iw_clk or posedge iw_rst) begin
        if (iw_rst) begin
            for (i = 0; i < ENTRY_NUM; i = i + 1) begin
                r_taken[i]  <= 1'b0;
                r_target[i] <= {`SIZE_ADDR{1'b0}};
            end
        end else if (iw_update) begin
            r_taken[w_uindex]  <= iw_actual_taken;
            r_target[w_uindex] <= iw_actual_target;
        end
    end
endmodule
