`include "src2/sizes.vh"

module diad(
    input wire iw_clk,
    input wire iw_rst
);
    reg                 r_ia_valid;
    reg  [`HBIT_ADDR:0] r_ia_pc;
    wire [`HBIT_ADDR:0] w_iaif_pc;
    wire [`HBIT_ADDR:0] w_ifid_pc;
    wire [`HBIT_ADDR:0] w_idex_pc;
    wire [`HBIT_ADDR:0] w_exma_pc;
    wire [`HBIT_ADDR:0] w_mamo_pc;
    wire [`HBIT_ADDR:0] w_mora_pc;
    wire [`HBIT_ADDR:0] w_raro_pc;
    wire [`HBIT_ADDR:0] w_ro_pc;

    wire [`HBIT_DATA:0] w_ifid_instr;
    wire [`HBIT_DATA:0] w_idex_instr;
    wire [`HBIT_DATA:0] w_exma_instr;
    wire [`HBIT_DATA:0] w_mamo_instr;
    wire [`HBIT_DATA:0] w_mora_instr;
    wire [`HBIT_DATA:0] w_raro_instr;
    wire [`HBIT_DATA:0] w_ro_instr;

    always @(posedge iw_clk or posedge iw_rst) begin
        if (iw_rst) begin
            r_ia_pc    <= `SIZE_ADDR'b0;
        end
        else begin
            r_ia_pc    <= r_ia_pc + `SIZE_ADDR'd1;
        end
    end

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

    stg1ia u_stg1ia(
        .iw_clk     (iw_clk),
        .iw_rst     (iw_rst),
        .ow_mem_addr(w_mem_addr),
        .iw_pc      (r_ia_pc),
        .ow_pc      (w_iaif_pc),
        .ow_ia_valid(r_ia_valid)
    );

    stg1if u_stg1if(
        .iw_clk     (iw_clk),
        .iw_rst     (iw_rst),
        .iw_mem_data(w_mem_rdata),
        .iw_ia_valid(r_ia_valid),
        .iw_pc      (w_iaif_pc),
        .ow_pc      (w_ifid_pc),
        .ow_instr   (w_ifid_instr)
    );

    stg2id u_stg2id(
        .iw_clk  (iw_clk),
        .iw_rst  (iw_rst),
        .iw_pc   (w_ifid_pc),
        .ow_pc   (w_idex_pc),
        .iw_instr(w_ifid_instr),
        .ow_instr(w_idex_instr)
    );

    stg3ex u_stg3ex(
        .iw_clk  (iw_clk),
        .iw_rst  (iw_rst),
        .iw_pc   (w_idex_pc),
        .ow_pc   (w_exma_pc),
        .iw_instr(w_idex_instr),
        .ow_instr(w_exma_instr)
    );

    stg4ma u_stg4ma(
        .iw_clk  (iw_clk),
        .iw_rst  (iw_rst),
        .iw_pc   (w_exma_pc),
        .ow_pc   (w_mamo_pc),
        .iw_instr(w_exma_instr),
        .ow_instr(w_mamo_instr)
    );

    stg4mo u_stg4mo(
        .iw_clk  (iw_clk),
        .iw_rst  (iw_rst),
        .iw_pc   (w_mamo_pc),
        .ow_pc   (w_mora_pc),
        .iw_instr(w_mamo_instr),
        .ow_instr(w_mora_instr)
    );

    stg5ra u_stg5ra(
        .iw_clk  (iw_clk),
        .iw_rst  (iw_rst),
        .iw_pc   (w_mora_pc),
        .ow_pc   (w_raro_pc),
        .iw_instr(w_mora_instr),
        .ow_instr(w_raro_instr)
    );

    stg5ro u_stg5ro(
        .iw_clk  (iw_clk),
        .iw_rst  (iw_rst),
        .iw_pc   (w_raro_pc),
        .ow_pc   (w_ro_pc),
        .iw_instr(w_raro_instr),
        .ow_instr(w_ro_instr)
    );
endmodule
