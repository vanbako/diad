// stage2id.v
`include "src/opcodes.vh"
`define DEFINE_REG_SRC_READ_FN
`define DEFINE_REG_TGT_READ_FN
`include "src/iset.vh"
`undef DEFINE_REG_TGT_READ_FN
`undef DEFINE_REG_SRC_READ_FN
module stage2id(
    input  wire        clk,
    input  wire        rst,
    input  wire        enable_in,
    output wire        enable_out,
    input  wire [23:0] pc_in,
    input  wire [23:0] instr_in,
    output wire [23:0] pc_out,
    output wire [23:0] instr_out,
    output wire [3:0]  bcc_out,
    output wire [3:0]  tgt_gp_out,
    output wire [3:0]  tgt_sr_out,
    output wire [3:0]  src_gp_out,
    output wire [3:0]  src_sr_out,
    output wire        imm_en_out,
    // Lower 12 bits hold the immediate value extracted from the instruction
    output wire [11:0] imm_val_out,
    output wire        sgn_en_out,
    // Stall signal from the hazard unit. When asserted, a NOP is
    // inserted instead of the decoded instruction.
    input  wire        stall_in
);
    // Propagate enable to the next stage
    assign enable_out = enable_in;

    // Decode stage: use the current instruction set directly
    wire [7:0] opcode = instr_in[23:16];

    // Replace handled instructions with NOPs
    wire [23:0] forwarded_instr = (opcode == `OPC_NOP) ? 24'b0 : instr_in;

    // Decode immediate, register and branch fields
    wire [3:0]  bcc_w      = forwarded_instr[15:12];
    wire [7:0]  fwd_opcode = forwarded_instr[23:16];
    wire        use_src    = reg_src_read_fn(fwd_opcode);
    wire        use_tgt    = reg_tgt_read_fn(fwd_opcode);
    // Instructions that operate on the special register file rather than the
    // general purpose registers
    wire special_instr = (fwd_opcode == `OPC_S_SRMOV) ||
                         (fwd_opcode == `OPC_S_SRBCC);

    // Target/source register numbers.  When the instruction does not read from
    // the general purpose register file or when it is a special register
    // instruction, the address is forced to zero so that the hazard unit sees
    // no dependency.
    // Extract register numbers using the instruction format defined in
    // design.txt. Target registers reside in bits [15:12] and source
    // registers in bits [11:8]. The previous implementation incorrectly
    // used bits [7:4] and [3:0] which caused immediate instructions like
    // ADDis to read the wrong registers and stalled the pipeline.
    wire [3:0]  tgt_gp_w   = (special_instr || !use_tgt) ? 4'b0
                                               : forwarded_instr[15:12];
    wire [3:0]  tgt_sr_w   = special_instr ? forwarded_instr[15:12] : 4'b0;
    wire [3:0]  src_gp_w   = (special_instr || !use_src) ? 4'b0
                                               : forwarded_instr[11:8];
    wire [3:0]  src_sr_w   = special_instr ? forwarded_instr[11:8] : 4'b0;

    wire [11:0] imm_val_w  = forwarded_instr[11:0];
    // Signed operations and immediate based instructions
    wire signed_instr = (fwd_opcode == `OPC_RS_ADDs)  ||
                        (fwd_opcode == `OPC_RS_SUBs)  ||
                        (fwd_opcode == `OPC_RS_SRs)   ||
                        (fwd_opcode == `OPC_RS_CMPs)  ||
                        (fwd_opcode == `OPC_IS_MOVis) ||
                        (fwd_opcode == `OPC_IS_ADDis) ||
                        (fwd_opcode == `OPC_IS_SUBis) ||
                        (fwd_opcode == `OPC_IS_SRis)  ||
                        (fwd_opcode == `OPC_IS_CMPis) ||
                        (fwd_opcode == `OPC_IS_BCCis);

    wire imm_instr = (fwd_opcode == `OPC_I_MOVi)  ||
                      (fwd_opcode == `OPC_I_ADDi) ||
                      (fwd_opcode == `OPC_I_SUBi) ||
                      (fwd_opcode == `OPC_I_ANDi) ||
                      (fwd_opcode == `OPC_I_ORi)  ||
                      (fwd_opcode == `OPC_I_XORi) ||
                      (fwd_opcode == `OPC_I_SLi)  ||
                      (fwd_opcode == `OPC_I_SRi)  ||
                      (fwd_opcode == `OPC_I_CMPi) ||
                      (fwd_opcode == `OPC_I_BCCi)||
                      (fwd_opcode == `OPC_I_LDi)  ||
                      (fwd_opcode == `OPC_I_STi)  ||
                      (fwd_opcode == `OPC_IS_MOVis) ||
                      (fwd_opcode == `OPC_IS_ADDis) ||
                      (fwd_opcode == `OPC_IS_SUBis)||
                      (fwd_opcode == `OPC_IS_SRis) ||
                      (fwd_opcode == `OPC_IS_CMPis)||
                      (fwd_opcode == `OPC_IS_BCCis)||
                      (fwd_opcode == `OPC_S_LUI);

    wire        sgn_en_w   = signed_instr;
    wire        imm_en_w   = imm_instr;

    // Latch outputs for the next pipeline stage
    reg [23:0]  pc_latch;
    reg [23:0]  instr_latch;
    reg [3:0]   bcc_latch;
    reg [3:0]   tgt_gp_latch;
    reg [3:0]   tgt_sr_latch;
    reg [3:0]   src_gp_latch;
    reg [3:0]   src_sr_latch;
    reg         imm_en_latch;
    reg [11:0]  imm_val_latch;
    reg         sgn_en_latch;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_latch       <= 24'b0;
            instr_latch    <= 24'b0;
            bcc_latch      <= 4'b0;
            tgt_gp_latch   <= 4'b0;
            tgt_sr_latch   <= 4'b0;
            src_gp_latch   <= 4'b0;
            src_sr_latch   <= 4'b0;
            imm_en_latch   <= 1'b0;
            imm_val_latch  <= 12'b0;
            sgn_en_latch   <= 1'b0;
        end else if (enable_in) begin
            if (stall_in) begin
                // Insert a bubble when stalling
                pc_latch       <= pc_in;
                instr_latch    <= 24'b0;
                bcc_latch      <= 4'b0;
                tgt_gp_latch   <= 4'b0;
                tgt_sr_latch   <= 4'b0;
                src_gp_latch   <= 4'b0;
                src_sr_latch   <= 4'b0;
                imm_en_latch   <= 1'b0;
                imm_val_latch  <= 12'b0;
                sgn_en_latch   <= 1'b0;
            end else begin
                pc_latch   <= pc_in;
                instr_latch <= forwarded_instr;
                bcc_latch       <= bcc_w;
                tgt_gp_latch    <= tgt_gp_w;
                tgt_sr_latch    <= tgt_sr_w;
                src_gp_latch    <= src_gp_w;
                src_sr_latch    <= src_sr_w;
                imm_en_latch    <= imm_en_w;
                imm_val_latch   <= imm_val_w;
                sgn_en_latch    <= sgn_en_w;
            end
        end
    end

    assign pc_out        = pc_latch;
    assign instr_out     = instr_latch;
    assign bcc_out       = bcc_latch;
    assign tgt_gp_out    = tgt_gp_latch;
    assign tgt_sr_out    = tgt_sr_latch;
    assign src_gp_out    = src_gp_latch;
    assign src_sr_out    = src_sr_latch;
    assign imm_en_out    = imm_en_latch;
    assign imm_val_out   = imm_val_latch;
    assign sgn_en_out    = sgn_en_latch;
endmodule
