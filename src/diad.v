`include "src/sizes.vh"
`include "src/sr.vh"

module diad(
    input wire iw_clk,
    input wire iw_rst
);
    wire                w_mem_we;
    wire [`HBIT_ADDR:0] w_mem_addr;
    wire [`HBIT_DATA:0] w_mem_wdata;
    wire [`HBIT_DATA:0] w_mem_rdata;

    mem u_mem(
        .iw_clk  (iw_clk),
        .iw_we   (w_mem_we),
        .iw_addr (w_mem_addr),
        .iw_wdata(w_mem_wdata),
        .or_rdata(w_mem_rdata)
    );

    wire                w_ia_valid;
    reg  [`HBIT_ADDR:0] r_ia_pc;
    wire [`HBIT_ADDR:0] w_iaif_pc;
    wire [`HBIT_ADDR:0] w_ifid_pc;
    wire [`HBIT_ADDR:0] w_idex_pc;
    wire [`HBIT_ADDR:0] w_exma_pc;
    wire [`HBIT_ADDR:0] w_mamo_pc;
    wire [`HBIT_ADDR:0] w_mowb_pc;
    wire [`HBIT_ADDR:0] w_wb_pc;

    wire [`HBIT_DATA:0] w_ifid_instr;
    wire [`HBIT_DATA:0] w_idex_instr;
    wire [`HBIT_DATA:0] w_exma_instr;
    wire [`HBIT_DATA:0] w_mamo_instr;
    wire [`HBIT_DATA:0] w_mowb_instr;
    wire [`HBIT_DATA:0] w_wb_instr;

    wire [`HBIT_TGT_GP:0] w_gp_read_addr1;
    wire [`HBIT_TGT_GP:0] w_gp_read_addr2;
    wire [`HBIT_TGT_GP:0] w_gp_write_addr;
    wire [`HBIT_DATA:0]   w_gp_write_data;
    wire                  w_gp_write_enable;
    wire [`HBIT_DATA:0]   w_gp_read_data1;
    wire [`HBIT_DATA:0]   w_gp_read_data2;

    reggp u_reggp(
        .iw_clk         (iw_clk),
        .iw_rst         (iw_rst),
        .iw_read_addr1  (w_gp_read_addr1),
        .iw_read_addr2  (w_gp_read_addr2),
        .iw_write_addr  (w_gp_write_addr),
        .iw_write_data  (w_gp_write_data),
        .iw_write_enable(w_gp_write_enable),
        .ow_read_data1  (w_gp_read_data1),
        .ow_read_data2  (w_gp_read_data2)
    );

    wire [`HBIT_TGT_SR:0] w_sr_read_addr1;
    wire [`HBIT_TGT_SR:0] w_sr_read_addr2;
    wire [`HBIT_TGT_SR:0] w_sr_write_addr;
    wire [`HBIT_DATA:0]   w_sr_write_data;
    wire                  w_sr_write_enable;
    wire [`HBIT_DATA:0]   w_sr_write_pc;
    wire                  w_sr_write_pc_enable;
    wire [`HBIT_DATA:0]   w_sr_read_data1;
    wire [`HBIT_DATA:0]   w_sr_read_data2;

    reggp u_regsr(
        .iw_clk            (iw_clk),
        .iw_rst            (iw_rst),
        .iw_read_addr1     (w_sr_read_addr1),
        .iw_read_addr2     (w_sr_read_addr2),
        .iw_write_addr     (w_sr_write_addr),
        .iw_write_data     (w_sr_write_data),
        .iw_write_enable   (w_sr_write_enable),
        .ow_read_data1     (w_sr_read_data1),
        .ow_read_data2     (w_sr_read_data2)
    );

    always @(posedge iw_clk or posedge iw_rst) begin
        if (iw_rst) begin
            r_ia_pc <= `SIZE_ADDR'b0;
        end
        else begin
            r_ia_pc <= r_ia_pc + `SIZE_ADDR'd1;
        end
    end

    stg1ia u_stg1ia(
        .iw_clk     (iw_clk),
        .iw_rst     (iw_rst),
        .ow_mem_addr(w_mem_addr),
        .iw_pc      (r_ia_pc),
        .ow_pc      (w_iaif_pc),
        .ow_ia_valid(w_ia_valid)
    );

    stg1if u_stg1if(
        .iw_clk     (iw_clk),
        .iw_rst     (iw_rst),
        .iw_mem_data(w_mem_rdata),
        .iw_ia_valid(w_ia_valid),
        .iw_pc      (w_iaif_pc),
        .ow_pc      (w_ifid_pc),
        .ow_instr   (w_ifid_instr)
    );

    wire [`HBIT_OPC:0]    w_opc;
    wire                  w_sgn_en;
    wire                  w_imm_en;
    wire [`HBIT_IMM:0]    w_imm_val;
    wire [`HBIT_IMMSR:0]  w_immsr_val;
    wire [`HBIT_CC:0]     w_cc;
    wire [`HBIT_TGT_GP:0] w_tgt_gp;
    wire [`HBIT_TGT_GP:0] w_tgt_gp_we;
    wire [`HBIT_TGT_SR:0] w_tgt_sr;
    wire [`HBIT_TGT_SR:0] w_tgt_sr_we;
    wire [`HBIT_SRC_GP:0] w_src_gp;
    wire [`HBIT_SRC_SR:0] w_src_sr;

    stg2id u_stg2id(
        .iw_clk      (iw_clk),
        .iw_rst      (iw_rst),
        .iw_pc       (w_ifid_pc),
        .ow_pc       (w_idex_pc),
        .iw_instr    (w_ifid_instr),
        .ow_instr    (w_idex_instr),
        .ow_opc      (w_opc),
        .ow_sgn_en   (w_sgn_en),
        .ow_imm_en   (w_imm_en),
        .ow_imm_val  (w_imm_val),
        .ow_immsr_val(w_immsr_val),
        .ow_cc       (w_cc),
        .ow_tgt_gp   (w_tgt_gp),
        .ow_tgt_gp_we(w_tgt_gp_we),
        .ow_tgt_sr   (w_tgt_sr),
        .ow_tgt_sr_we(w_tgt_sr_we),
        .ow_src_gp   (w_src_gp),
        .ow_src_sr   (w_src_sr)
    );

    wire [`HBIT_OPC:0]    w_exma_opc;
    wire [`HBIT_TGT_GP:0] w_exma_tgt_gp;
    wire                  w_exma_tgt_gp_we;
    wire [`HBIT_TGT_SR:0] w_exma_tgt_sr;
    wire                  w_exma_tgt_sr_we;
    wire [`HBIT_DATA:0]   w_exma_result;

    wire [`HBIT_OPC:0]    w_mamo_opc;
    wire [`HBIT_TGT_GP:0] w_mamo_tgt_gp;
    wire                  w_mamo_tgt_gp_we;
    wire [`HBIT_TGT_SR:0] w_mamo_tgt_sr;
    wire                  w_mamo_tgt_sr_we;
    wire [`HBIT_DATA:0]   w_mamo_result;

    wire [`HBIT_OPC:0]    w_mowb_opc;
    wire [`HBIT_TGT_GP:0] w_mowb_tgt_gp;
    wire                  w_mowb_tgt_gp_we;
    wire [`HBIT_TGT_SR:0] w_mowb_tgt_sr;
    wire                  w_mowb_tgt_sr_we;
    wire [`HBIT_DATA:0]   w_mowb_result;

    stg3ex u_stg3ex(
        .iw_clk      (iw_clk),
        .iw_rst          (iw_rst),
        .iw_pc           (w_idex_pc),
        .ow_pc           (w_exma_pc),
        .iw_instr        (w_idex_instr),
        .ow_instr        (w_exma_instr),
        .iw_opc          (w_opc),
        .ow_opc          (w_exma_opc),
        .iw_sgn_en       (w_sgn_en),
        .iw_imm_en       (w_imm_en),
        .iw_imm_val      (w_imm_val),
        .iw_immsr_val    (w_immsr_val),
        .iw_cc           (w_cc),
        .iw_tgt_gp       (w_tgt_gp),
        .iw_tgt_gp_we    (w_tgt_gp_we),
        .ow_tgt_gp       (w_exma_tgt_gp),
        .ow_tgt_gp_we    (w_exma_tgt_gp_we),
        .iw_tgt_sr       (w_tgt_sr),
        .iw_tgt_sr_we    (w_tgt_sr_we),
        .ow_tgt_sr       (w_exma_tgt_sr),
        .ow_tgt_sr_we    (w_exma_tgt_sr_we),
        .iw_src_gp       (w_src_gp),
        .iw_src_sr       (w_src_sr),
        .ow_gp_read_addr1(w_gp_read_addr1),
        .ow_gp_read_addr2(w_gp_read_addr2),
        .iw_gp_read_data1(w_gp_read_data1),
        .iw_gp_read_data2(w_gp_read_data2),
        .ow_sr_read_addr1(w_sr_read_addr1),
        .ow_sr_read_addr2(w_sr_read_addr2),
        .iw_sr_read_data1(w_sr_read_data1),
        .iw_sr_read_data2(w_sr_read_data2),
        .ow_result       (w_exma_result)
    );

    stg4ma u_stg4ma(
        .iw_clk      (iw_clk),
        .iw_rst      (iw_rst),
        .iw_pc       (w_exma_pc),
        .ow_pc       (w_mamo_pc),
        .iw_instr    (w_exma_instr),
        .ow_instr    (w_mamo_instr),
        .iw_opc      (w_exma_opc),
        .ow_opc      (w_mamo_opc),
        .iw_tgt_gp   (w_exma_tgt_gp),
        .iw_tgt_gp_we(w_exma_tgt_gp_we),
        .ow_tgt_gp   (w_mamo_tgt_gp),
        .ow_tgt_gp_we(w_mamo_tgt_gp_we),
        .iw_tgt_sr   (w_exma_tgt_sr),
        .iw_tgt_sr_we(w_exma_tgt_sr_we),
        .ow_tgt_sr   (w_mamo_tgt_sr),
        .ow_tgt_sr_we(w_mamo_tgt_sr_we),
        .iw_result   (w_exma_result),
        .ow_result   (w_mamo_result)
    );

    stg4mo u_stg4mo(
        .iw_clk      (iw_clk),
        .iw_rst      (iw_rst),
        .iw_pc       (w_mamo_pc),
        .ow_pc       (w_mowb_pc),
        .iw_instr    (w_mamo_instr),
        .ow_instr    (w_mowb_instr),
        .iw_opc      (w_mamo_opc),
        .ow_opc      (w_mowb_opc),
        .iw_tgt_gp   (w_mamo_tgt_gp),
        .iw_tgt_gp_we(w_mamo_tgt_gp_we),
        .ow_tgt_gp   (w_mowb_tgt_gp),
        .ow_tgt_gp_we(w_mowb_tgt_gp_we),
        .iw_tgt_sr   (w_mamo_tgt_sr),
        .iw_tgt_sr_we(w_mamo_tgt_sr_we),
        .ow_tgt_sr   (w_mowb_tgt_sr),
        .ow_tgt_sr_we(w_mowb_tgt_sr_we),
        .iw_result   (w_mamo_result),
        .ow_result   (w_mowb_result)
    );

    wire [`HBIT_OPC:0]    w_wb_opc;
    wire [`HBIT_TGT_GP:0] w_wb_tgt_gp;
    wire [`HBIT_TGT_SR:0] w_wb_tgt_sr;
    wire [`HBIT_DATA:0]   w_wb_result;

    stg5wb u_stg5wb(
        .iw_clk            (iw_clk),
        .iw_rst            (iw_rst),
        .iw_pc             (w_mowb_pc),
        .ow_pc             (w_wb_pc),
        .iw_instr          (w_mowb_instr),
        .ow_instr          (w_wb_instr),
        .ow_gp_write_addr  (w_gp_write_addr),
        .ow_gp_write_data  (w_gp_write_data),
        .ow_gp_write_enable(w_gp_write_enable),
        .ow_sr_write_addr  (w_sr_write_addr),
        .ow_sr_write_data  (w_sr_write_data),
        .ow_sr_write_enable(w_sr_write_enable),
        .iw_opc            (w_mowb_opc),
        .ow_opc            (w_wb_opc),
        .iw_tgt_gp         (w_mowb_tgt_gp),
        .iw_tgt_gp_we      (w_mowb_tgt_gp_we),
        .ow_tgt_gp         (w_wb_tgt_gp),
        .iw_tgt_sr         (w_mowb_tgt_sr),
        .iw_tgt_sr_we      (w_mowb_tgt_sr_we),
        .ow_tgt_sr         (w_wb_tgt_sr),
        .iw_result         (w_mowb_result),
        .ow_result         (w_wb_result)
    );
endmodule
