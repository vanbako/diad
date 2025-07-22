`include "src/sizes.vh"

module hazard(
    input wire                 iw_branch_valid,
    input wire                 iw_branch_taken,
    input wire [`HBIT_ADDR:0]  iw_branch_target,
    input wire [`HBIT_ADDR:0]  iw_branch_pc,
    input wire                 iw_pred_taken,
    input wire [`HBIT_ADDR:0]  iw_pred_pc,
    output reg                 ow_flush,
    output reg [`HBIT_ADDR:0]  ow_correct_pc,
    output reg                 ow_update,
    output reg [`HBIT_ADDR:0]  ow_update_pc,
    output reg                 ow_update_taken,
    output reg [`HBIT_ADDR:0]  ow_update_target
);
    always @(*) begin
        ow_flush         = 1'b0;
        ow_update        = 1'b0;
        ow_correct_pc    = iw_branch_pc + `SIZE_ADDR'd1;
        ow_update_pc     = iw_branch_pc;
        ow_update_taken  = iw_branch_taken;
        ow_update_target = iw_branch_target;
        if (iw_branch_valid) begin
            ow_update     = 1'b1;
            ow_correct_pc = iw_branch_taken ? iw_branch_target : (iw_branch_pc + `SIZE_ADDR'd1);
            if ((iw_branch_taken != iw_pred_taken) || (iw_branch_taken && (iw_branch_target != iw_pred_pc)))
                ow_flush = 1'b1;
        end
    end
endmodule
