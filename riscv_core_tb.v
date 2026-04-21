`timescale 1ns/1ps

module riscv_core_tb;

reg clk;
reg reset;

// Outputs from DUT
wire [31:0] pc_out;
wire [31:0] instr_out;
wire [31:0] alu_result_out;
wire [31:0] mem_data_out;

// Instantiate DUT
riscv_core uut (
    .clk(clk),
    .reset(reset),
    .pc_out(pc_out),
    .instr_out(instr_out),
    .alu_result_out(alu_result_out),
    .mem_data_out(mem_data_out)
);


// Clock Generation

initial begin
    clk = 0;
    forever #5 clk = ~clk;   // 10ns clock
end


// Reset Sequence

initial begin
    reset = 1;
    #20;
    reset = 0;
end


// Monitor (Waveform understanding)

initial begin
    $display("Time | PC | Instr | ALU | MEM | x1 x2 x3 x4 x5 x6");
    $monitor("%0t | %h | %h | %d | %d | %d %d %d %d %d %d",
        $time,
        pc_out,
        instr_out,
        alu_result_out,
        mem_data_out,
        uut.RF.regs[1],
        uut.RF.regs[2],
        uut.RF.regs[3],
        uut.RF.regs[4],
        uut.RF.regs[5],
        uut.RF.regs[6]
    );
end


// Self-Checking Logic

initial begin
    // Wait for program execution
    #200;

    $display("\n===== RESULT CHECK =====");

    if (uut.RF.regs[1] == 5)
        $display("x1 correct");
    else
        $display("x1 WRONG");

    if (uut.RF.regs[2] == 10)
        $display("x2 correct");
    else
        $display("x2 WRONG");

    if (uut.RF.regs[3] == 15)
        $display("x3 correct (ADD)");
    else
        $display("x3 WRONG");

    if (uut.RF.regs[4] == 15)
        $display("x4 correct (LW)");
    else
        $display("x4 WRONG");

    // Branch skip check
    if (uut.RF.regs[5] == 0)
        $display("x5 correct (branch skipped)");
    else
        $display("x5 WRONG");

    if (uut.RF.regs[6] == 1)
        $display("x6 correct");
    else
        $display("x6 WRONG");

    // Memory check
    if (uut.DM.mem[0] == 15)
        $display("Memory correct");
    else
        $display("Memory WRONG");

    $display("===== TEST COMPLETE =====");
    $finish;
end


// Dump Waveform

initial begin
    $dumpfile("riscv.vcd");
    $dumpvars(0, riscv_core_tb);
end

endmodule
