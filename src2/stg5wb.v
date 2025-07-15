`include "src2/sizes.vh"

module stg5wb(
    input wire                   iw_clk,
    input wire                   iw_rst,
    input wire  [`HBIT_ADDR:0]   iw_pc,
    output wire [`HBIT_ADDR:0]   ow_pc,
    input wire  [`HBIT_DATA:0]   iw_instr,
    output wire [`HBIT_DATA:0]   ow_instr,
    // output reg  [`HBIT_DATA:0]   or_gp[`HBIT_GP:0],
    // output reg  [`HBIT_DATA:0]   or_sr[`HBIT_SR:0],
    input wire  [`HBIT_OPC:0]    iw_opc,
    output wire [`HBIT_OPC:0]    ow_opc,
    input wire  [`HBIT_TGT_GP:0] iw_tgt_gp,
    output wire [`HBIT_TGT_GP:0] ow_tgt_gp,
    input wire  [`HBIT_TGT_SR:0] iw_tgt_sr,
    output wire [`HBIT_TGT_SR:0] ow_tgt_sr,
    input wire  [`HBIT_DATA:0]   iw_result,
    output wire [`HBIT_DATA:0]   ow_result
);
    reg [`HBIT_ADDR:0]   r_pc_latch;
    reg [`HBIT_DATA:0]   r_instr_latch;
    reg [`HBIT_OPC:0]    r_opc_latch;
    reg [`HBIT_TGT_GP:0] r_tgt_gp_latch;
    reg [`HBIT_TGT_SR:0] r_tgt_sr_latch;
    reg [`HBIT_DATA:0]   r_result_latch;
    always @(posedge iw_clk or posedge iw_rst) begin
        if (iw_rst) begin
            r_pc_latch     <= `SIZE_ADDR'b0;
            r_instr_latch  <= `SIZE_DATA'b0;
            r_opc_latch    <= `SIZE_OPC'b0;
            r_tgt_gp_latch <= `SIZE_TGT_GP'b0;
            r_tgt_sr_latch <= `SIZE_TGT_SR'b0;
            r_result_latch <= `SIZE_DATA'b0;
        end
        else begin
            // case (iw_opc)
            //     `OPC_R_MOV,
            //     `OPC_R_ADD,
            //     `OPC_R_SUB,
            //     `OPC_R_NOT,
            //     `OPC_R_AND,
            //     `OPC_R_OR,
            //     `OPC_R_XOR,
            //     `OPC_R_SHL,
            //     `OPC_R_SHR,
            //     `OPC_RS_ADDs,
            //     `OPC_RS_SUBs,
            //     `OPC_RS_SHRs,
            //     `OPC_I_MOVi,
            //     `OPC_I_ADDi,
            //     `OPC_I_SUBi,
            //     `OPC_I_ANDi,
            //     `OPC_I_ORi,
            //     `OPC_I_XORi,
            //     `OPC_I_SHLi,
            //     `OPC_I_SHRi,
            //     `OPC_IS_MOVis,
            //     `OPC_IS_ADDis,
            //     `OPC_IS_SUBis,
            //     `OPC_IS_SHRis: begin
            //         or_gp[iw_tgt_gp] <= iw_result;
            //     end
            //     `OPC_S_SRMOV: begin
            //         or_sr[iw_tgt_sr] <= iw_result;
            //     end
            // endcase
            r_pc_latch     <= iw_pc;
            r_instr_latch  <= iw_instr;
            r_opc_latch    <= iw_opc;
            r_tgt_gp_latch <= iw_tgt_gp;
            r_tgt_sr_latch <= iw_tgt_sr;
            r_result_latch <= iw_result;
        end
    end
    assign ow_pc     = r_pc_latch;
    assign ow_instr  = r_instr_latch;
    assign ow_opc    = r_opc_latch;
    assign ow_tgt_gp = r_tgt_gp_latch;
    assign ow_tgt_sr = r_tgt_sr_latch;
    assign ow_result = r_result_latch;
endmodule
