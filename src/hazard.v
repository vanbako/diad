`include "src/sizes.vh"
`include "src/opcodes.vh"

module hazard(
    input wire                  iw_clk,
    input wire                  iw_rst,
    input wire [`HBIT_OPC:0]    iw_exma_opc,
    input wire [`HBIT_SRC_GP:0] iw_exma_tgt_gp,
    input wire                  iw_exma_tgt_gp_we,
    input wire [`HBIT_TGT_GP:0] iw_tgt_gp,
    input wire [`HBIT_SRC_GP:0] iw_src_gp,
    output wire                 ow_stall
);
    reg [1:0] r_cnt;
    wire w_hazard = (iw_exma_opc == `OPC_RU_LDu) && iw_exma_tgt_gp_we && ((iw_exma_tgt_gp == iw_src_gp) || (iw_exma_tgt_gp == iw_tgt_gp));
    always @(posedge iw_clk or posedge iw_rst) begin
        if (iw_rst) begin
            r_cnt <= 2'd0;
        end else if (r_cnt != 2'd0) begin
            r_cnt <= r_cnt - 2'd1;
        end else if (w_hazard) begin
            r_cnt <= 2'd2;
        end
    end
    assign ow_stall = (r_cnt != 2'd0);
endmodule
