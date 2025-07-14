`timescale 1ns/1ps

`include "src2/opcodes.vh"
`include "src2/cc.vh"

module testbench;
    reg r_clk;
    reg r_rst;
    diad u_diad (
        .iw_clk(r_clk),
        .iw_rst(r_rst)
    );
    initial r_clk = 1'b0;
    always #5 r_clk = ~r_clk;
    initial begin
        r_rst = 1'b1;
        #10;
        r_rst = 1'b0;
        repeat (20) @(posedge r_clk);
        $finish;
    end
    integer tick = 0;
    always @(posedge r_clk) begin
`ifdef DEBUGPC
        $display("tick %03d : rst=%b PC  IA=%h IAIF=%h IFID=%h IDEX=%h EXMA=%h MAMO=%h MORA=%h RARO=%h RO=%h",
                 tick, r_rst,
                 u_diad.r_ia_pc,
                 u_diad.w_iaif_pc,
                 u_diad.w_ifid_pc,
                 u_diad.w_idex_pc,
                 u_diad.w_exma_pc,
                 u_diad.w_mamo_pc,
                 u_diad.w_mora_pc,
                 u_diad.w_raro_pc,
                 u_diad.w_ro_pc);
`endif
`ifdef DEBUGINSTR
        $display("tick %03d : rst=%b INSTR                     IFID=%h IDEX=%h EXMA=%h MAMO=%h MORA=%h RARO=%h RO=%h",
                 tick, r_rst,
                 u_diad.w_ifid_instr,
                 u_diad.w_idex_instr,
                 u_diad.w_exma_instr,
                 u_diad.w_mamo_instr,
                 u_diad.w_mora_instr,
                 u_diad.w_raro_instr,
                 u_diad.w_ro_instr);
`endif
`ifdef DEBUGDECODE
        $display("tick %03d : rst=%b DECODE OPC=%-8s SGN_EN=%b IMM_EN=%b IMM_VAL=%h IMMSR_VAL=%h CC=%2s TGT_GP=%h TGT_SR=%h SRC_GP=%h SRC_SR=%h",
                 tick, r_rst,
                 opc2str(u_diad.w_opc),
                 u_diad.w_sgn_en,
                 u_diad.w_imm_en,
                 u_diad.w_imm_val,
                 u_diad.w_immsr_val,
                 cc2str(u_diad.w_cc),
                 u_diad.w_tgt_gp,
                 u_diad.w_tgt_sr,
                 u_diad.w_src_gp,
                 u_diad.w_src_sr);
`endif
        tick = tick + 1;
    end
endmodule
