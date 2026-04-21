module control (
    input [6:0] opcode,
    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg branch,
    output reg alu_src,
    output reg [2:0] alu_op,
    output reg jump
);

always @(*) begin
    case (opcode)

        7'b0110011: begin
            reg_write = 1; alu_src = 0; alu_op = 3'b000;
            mem_read = 0; mem_write = 0; branch = 0; jump = 0;
        end

        7'b0010011: begin
            reg_write = 1; alu_src = 1; alu_op = 3'b000;
            mem_read = 0; mem_write = 0; branch = 0; jump = 0;
        end

        7'b0000011: begin
            reg_write = 1; alu_src = 1; alu_op = 3'b000;
            mem_read = 1; mem_write = 0; branch = 0; jump = 0;
        end

        7'b0100011: begin
            reg_write = 0; alu_src = 1; alu_op = 3'b000;
            mem_read = 0; mem_write = 1; branch = 0; jump = 0;
        end

        7'b1100011: begin
            reg_write = 0; alu_src = 0; alu_op = 3'b001;
            mem_read = 0; mem_write = 0; branch = 1; jump = 0;
        end

        default: begin
            reg_write = 0; mem_read = 0; mem_write = 0;
            branch = 0; alu_src = 0; alu_op = 3'b000; jump = 0;
        end
    endcase
end

endmodule