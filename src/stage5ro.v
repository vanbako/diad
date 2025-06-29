// stage5ro.v
`include "src/opcodes.vh"
`include "src/flags.vh"
`include "src/iset.vh"
module stage5ro(
    input  wire        clk,
    input  wire        rst,
    input  wire        enable_in,
    input  wire [23:0] pc_in,
    input  wire [23:0] instr_in,
    input  wire [23:0] result_in,
    input  wire [3:0]  flags_in,
    // Register address prepared by the RA stage
    input  wire [3:0]  reg_waddr_in,
    output wire [23:0] pc_out,
    output wire [23:0] instr_out,
    output wire [3:0]  reg_waddr,
    output wire [23:0] reg_wdata,
    output wire        reg_we,
    // Write interface for the link register
    output wire [23:0] lr_wdata,
    output wire        lr_we,
    output wire [3:0]  flag_wdata,
    output wire        flag_we
);
    // Bring in the shared reg_write_fn helper
    `define DEFINE_REG_WRITE_FN
    `include "src/iset.vh"
    `undef DEFINE_REG_WRITE_FN
    // Decode opcode for write-back decisions
    // Use the upper byte of the instruction for opcode decoding
    wire [7:0] opcode = instr_in[23:16];

    wire reg_write = reg_write_fn(opcode);

    // Pass through the address computed in the RA stage
    assign reg_waddr  = reg_waddr_in;
    assign reg_wdata  = result_in;
    assign reg_we     = enable_in && reg_write;

    // Write to the link register for the SRMOV instruction
    wire lr_write = (opcode == `OPC_S_SRMOV);
    assign lr_wdata = result_in;
    assign lr_we    = enable_in && lr_write;

    assign flag_wdata = flags_in;
    assign flag_we    = enable_in;

    // Propagate program counter and instruction info
    assign pc_out        = pc_in;
    assign instr_out     = instr_in;
endmodule
