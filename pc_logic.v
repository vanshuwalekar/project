module pc_logic (
    input [31:0] pc,
    input [31:0] imm,
    input branch,
    input zero,
    input jump,
    output reg [31:0] pc_next
);

always @(*) begin
    if (jump)
        pc_next = pc + imm;
    else if (branch && zero)
        pc_next = pc + imm;
    else
        pc_next = pc + 4;
end

endmodule