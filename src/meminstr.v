// meminstr.v
// Instruction Memory (4096x24, read-only)
module meminstr(
    input wire clk,
    input wire [23:0] addr,
    output reg [23:0] data
);
    reg [23:0] mem [0:4095];

    // Initialize instruction memory from a hex file
    initial begin
        integer i;
        // Preinitialize all memory locations to zeros.
        for (i = 0; i < 4096; i = i + 1)
            mem[i] = 24'b0;
        // Load specified instructions; remaining words are zero.
        $readmemh("instr_mem_init.hex", mem);
    end

    always @(posedge clk) begin
        data <= mem[addr];
    end
    // Memory initialization can be added here
endmodule
