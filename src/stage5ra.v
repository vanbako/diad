// stage5ra.v
`include "src/iset.vh"
module stage5ra(
    input  wire        clk,
    input  wire        rst,
    input  wire        enable_in,
    output wire        enable_out,
    input  wire [23:0] pc_in,
    input  wire [23:0] instr_in,
    input  wire [23:0] result_in,
    input  wire [3:0]  flags_in,
    output wire [23:0] pc_out,
    output wire [23:0] instr_out,
    output wire [23:0] result_out,
    output wire [3:0]  flags_out,
    // Decoded register address for the writeback stage
    output wire [3:0]  reg_waddr_out
);
    // Propagate enable directly to the next stage
    assign enable_out = enable_in;

    // The Register Address stage currently performs no logic and simply
    // forwards the program counter.
    wire [23:0] stage_pc     = pc_in;
    wire [23:0] stage_result = result_in;
    wire [3:0]  stage_flags  = flags_in;
    // Target register address extracted from the instruction.  General
    // purpose instructions encode the destination register in bits [15:12]
    // regardless of whether the instruction uses a register or immediate
    // operand.  Earlier revisions decoded bits [7:4], which meant that
    // an ADDis like "ADDis #1, R1" erroneously wrote the result to R0.
    // Using bits [15:12] ensures the register write address matches the
    // architectural specification.
    wire [3:0]  stage_waddr  = instr_in[15:12];

    // Latch registers between RA and RO stages
    reg [23:0] pc_latch;
    reg [23:0] instr_latch;
    reg [23:0] result_latch;
    reg [3:0]  flags_latch;
    reg [3:0]  waddr_latch;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_latch    <= 24'b0;
            instr_latch <= 24'b0;
            result_latch<= 24'b0;
            flags_latch <= 4'b0;
            waddr_latch <= 4'b0;
        end else if (enable_in) begin
            pc_latch     <= stage_pc;
            instr_latch  <= instr_in;
            result_latch <= stage_result;
            flags_latch  <= stage_flags;
            waddr_latch  <= stage_waddr;
        end
    end

    assign pc_out        = pc_latch;
    assign instr_out     = instr_latch;
    assign result_out    = result_latch;
    assign flags_out     = flags_latch;
    assign reg_waddr_out = waddr_latch;
endmodule
