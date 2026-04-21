module riscv_core_2stage (
    input clk,
    input reset
);

// IF Stage
wire [31:0] pc, pc_next, instr;

// IF/EX outputs
wire [31:0] instr_ex, pc_ex;

// EX Stage signals
wire [4:0] rs1, rs2, rd;
wire [31:0] rd1, rd2, imm;
wire [31:0] alu_in2, alu_result;
wire [31:0] mem_data, write_data;
wire zero;

wire reg_write, mem_read, mem_write, branch, alu_src, jump;
wire [2:0] alu_op;

// IF
pc PC(clk, reset, pc_next, pc);
instr_mem IM(pc, instr);

// IF/EX register
if_ex_reg IFEX (
    clk, reset,
    instr, pc,
    instr_ex, pc_ex
);

// Decode
assign rs1 = instr_ex[19:15];
assign rs2 = instr_ex[24:20];
assign rd  = instr_ex[11:7];

// Control
control CTRL(instr_ex[6:0], reg_write, mem_read, mem_write,
             branch, alu_src, alu_op, jump);

// Register file
reg_file RF(clk, reg_write, rs1, rs2, rd,
            write_data, rd1, rd2);

// Immediate
imm_gen IMM(instr_ex, imm);

// ALU input
assign alu_in2 = (alu_src) ? imm : rd2;

// ALU
alu ALU(rd1, alu_in2, alu_op, alu_result, zero);

// Data memory
data_mem DM(clk, mem_read, mem_write,
            alu_result, rd2, mem_data);

// Writeback
assign write_data = (mem_read) ? mem_data : alu_result;

// PC logic
pc_logic PCL(pc_ex, imm, branch, zero, jump, pc_next);

endmodule