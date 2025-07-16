`timescale 1ns/1ps

`include "src2/opcodes.vh"
`include "src2/cc.vh"
`include "src2/sizes.vh"
`include "src2/sr.vh"

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
        $display("tick %03d : rst=%b PC  IA=%h IAIF=%h IFID=%h IDEX=%h   EXMA=%h   MAMO=%h   MOWB=%h   WB=%h",
                 tick, r_rst,
                 u_diad.r_ia_pc,
                 u_diad.w_iaif_pc,
                 u_diad.w_ifid_pc,
                 u_diad.w_idex_pc,
                 u_diad.w_exma_pc,
                 u_diad.w_mamo_pc,
                 u_diad.w_mowb_pc,
                 u_diad.w_wb_pc);
`endif
`ifdef DEBUGGP
        $display("tick %03d : rst=%b GP  0=%h 1=%h 2=%h 3=%h 4=%h 5=%h 6=%h 7=%h",
                 tick, r_rst,
                 u_diad.u_reggp.r_gp[0],
                 u_diad.u_reggp.r_gp[1],
                 u_diad.u_reggp.r_gp[2],
                 u_diad.u_reggp.r_gp[3],
                 u_diad.u_reggp.r_gp[4],
                 u_diad.u_reggp.r_gp[5],
                 u_diad.u_reggp.r_gp[6],
                 u_diad.u_reggp.r_gp[7]);
`endif
`ifdef DEBUGINSTR
        $display("tick %03d : rst=%b INSTR                     IFID=%h IDEX=%h   EXMA=%h   MAMO=%h   MOWB=%h   WB=%h",
                 tick, r_rst,
                 u_diad.w_ifid_instr,
                 u_diad.w_idex_instr,
                 u_diad.w_exma_instr,
                 u_diad.w_mamo_instr,
                 u_diad.w_mowb_instr,
                 u_diad.w_wb_instr);
`endif
`ifdef DEBUGOPC
        $display("tick %03d : rst=%b OPC                                   IDEX=%-8s EXMA=%-8s MAMO=%-8s MOWB=%-8s WB=%-8s",
                 tick, r_rst,
                 opc2str(u_diad.w_opc),
                 opc2str(u_diad.w_exma_opc),
                 opc2str(u_diad.w_mamo_opc),
                 opc2str(u_diad.w_mowb_opc),
                 opc2str(u_diad.w_wb_opc));
`endif
`ifdef DEBUGTGT_GP
        $display("tick %03d : rst=%b TGT_GP                                IDEX=%h        EXMA=%h        MAMO=%h        MOWB=%h        WB=%h",
                 tick, r_rst,
                 u_diad.w_tgt_gp,
                 u_diad.w_exma_tgt_gp,
                 u_diad.w_mamo_tgt_gp,
                 u_diad.w_mowb_tgt_gp,
                 u_diad.w_wb_tgt_gp);
`endif
`ifdef DEBUGTGT_SR
        $display("tick %03d : rst=%b TGT_SR                                IDEX=%h        EXMA=%h        MAMO=%h        MOWB=%h        WB=%h",
                 tick, r_rst,
                 u_diad.w_tgt_sr,
                 u_diad.w_exma_tgt_sr,
                 u_diad.w_mamo_tgt_sr,
                 u_diad.w_mowb_tgt_sr,
                 u_diad.w_wb_tgt_sr);
`endif
`ifdef DEBUGRESULT
        $display("tick %03d : rst=%b RESULT                                              EXMA=%h   MAMO=%h   MOWB=%h   WB=%h",
                 tick, r_rst,
                 u_diad.w_exma_result,
                 u_diad.w_mamo_result,
                 u_diad.w_mowb_result,
                 u_diad.w_wb_result);
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
