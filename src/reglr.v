// reglr.v
// Link Register (24-bit)
module reglr(
    input wire clk,
    input wire rst,
    input wire [23:0] lr_in,
    input wire we,
    output reg [23:0] lr_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) lr_out <= 24'b0;
        else if (we) lr_out <= lr_in;
    end
endmodule
