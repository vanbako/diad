`include "src/sizes.vh"

module hazard(
    input wire [`HBIT_OPC:0]    iw_exma_opc,
    input wire [`HBIT_SRC_GP:0] iw_exma_tgt_gp,
    input wire                  iw_exma_tgt_gp_we,
    input wire [`HBIT_TGT_GP:0] iw_tgt_gp,
    input wire [`HBIT_SRC_GP:0] iw_src_gp,
    output reg                  or_stall
);
    assign or_stall = ((iw_exma_opc == `OPC_RU_LDu) && iw_exma_tgt_gp_we && ((iw_exma_tgt_gp == iw_src_gp) || (iw_exma_tgt_gp == iw_tgt_gp)));
endmodule
