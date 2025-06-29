// stage4ma.v
`include "src/iset.vh"
`include "src/opcodes.vh"
module stage4ma(
    input  wire        clk,
    input  wire        rst,
    input  wire        enable_in,
    output wire        enable_out,
    // Full 24-bit wide pipeline signals
    input  wire [23:0] pc_in,
    input  wire [23:0] instr_in,
    input  wire [23:0] result_in,
    input  wire [23:0] store_data_in,
    input  wire [3:0]  flags_in,
    output wire [23:0] pc_out,
    output wire [23:0] instr_out,
    output wire [23:0] result_out,
    output wire [3:0]  flags_out,
    output wire [23:0] store_data_out,
    // Address line for the data memory
    output wire [23:0] mem_addr
);
    // Propagate the enable signal to the next stage.  Any PC update is
    // determined below based on the instruction type.
    assign enable_out = enable_in;

    // Stage output prior to latching.  If the instruction is a branch, the
    // program counter from the execute stage (result_in) contains the next
    // address. Otherwise the original PC is forwarded.  Keeping this in a
    // separate wire allows for future memory address calculations.
    // Decode opcode from the upper byte of the instruction
    wire [7:0] opcode = instr_in[23:16];
    wire branch_instr = (opcode == `OPC_R_BCC)  ||
                        (opcode == `OPC_I_BCCi) ||
                        (opcode == `OPC_IS_BCCis) ||
                        (opcode == `OPC_S_SRBCC);
    wire [23:0] stage_pc = branch_instr ? result_in : pc_in;
    wire [23:0] stage_result = result_in;
    wire [3:0]  stage_flags  = flags_in;
    wire [23:0] stage_store_data = store_data_in;

    // Determine if this is a memory access instruction and set the
    // data memory address accordingly.  The execute stage provides the
    // address to access in result_in for load/store instructions.
    wire mem_instr = (opcode == `OPC_R_LD)  ||
                     (opcode == `OPC_I_LDi) ||
                     (opcode == `OPC_R_ST) ||
                     (opcode == `OPC_I_STi);
    assign mem_addr = mem_instr ? result_in : 24'b0;

    // Latch registers between MA and MO stages
    reg [23:0] pc_latch;
    reg [23:0] instr_latch;
    reg [23:0] result_latch;
    reg [3:0]  flags_latch;
    reg [23:0] store_data_latch;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_latch    <= 24'b0;
            instr_latch <= 24'b0;
            result_latch<= 24'b0;
            flags_latch <= 4'b0;
            store_data_latch <= 24'b0;
        end else if (enable_in) begin
            pc_latch    <= stage_pc;
            instr_latch <= instr_in;
            result_latch<= stage_result;
            flags_latch <= stage_flags;
            store_data_latch <= stage_store_data;
        end
    end

    assign pc_out        = pc_latch;
    assign instr_out     = instr_latch;
    assign result_out    = result_latch;
    assign flags_out     = flags_latch;
    assign store_data_out = store_data_latch;
endmodule
