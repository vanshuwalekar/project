`timescale 1ns/1ps

module riscv_core_tb;

reg clk;
reg reset;

// DUT outputs (optional if exposed)
wire [31:0] pc;

// Instantiate DUT
riscv_core_2stage uut (
    .clk(clk),
    .reset(reset)
);

//////////////////////////////////////////////////////
// Clock Generation
//////////////////////////////////////////////////////
initial begin
    clk = 0;
    forever #5 clk = ~clk;   // 10ns clock
end

//////////////////////////////////////////////////////
// Reset
//////////////////////////////////////////////////////
initial begin
    reset = 1;
    #20;
    reset = 0;
end

//////////////////////////////////////////////////////
// Monitor (Pipeline Observation)
//////////////////////////////////////////////////////
initial begin
    $display("Time | PC | x1 x2 x3 x4 x5 x6");
    $monitor("%0t | %h | %d %d %d %d %d %d",
        $time,
        uut.pc,
        uut.RF.regs[1],
        uut.RF.regs[2],
        uut.RF.regs[3],
        uut.RF.regs[4],
        uut.RF.regs[5],
        uut.RF.regs[6]
    );
end

//////////////////////////////////////////////////////
// Self-Checking
//////////////////////////////////////////////////////
initial begin
    #300;   // pipeline ke liye extra time diya

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

    // branch skip check
    if (uut.RF.regs[5] == 0)
        $display("x5 correct (branch skipped)");
    else
        $display("x5 WRONG");

    if (uut.RF.regs[6] == 1)
        $display("x6 correct");
    else
        $display("x6 WRONG");

    // memory check
    if (uut.DM.mem[0] == 15)
        $display("Memory correct");
    else
        $display("Memory WRONG");

    $display("===== TEST COMPLETE =====");
    $finish;
end

//////////////////////////////////////////////////////
// Waveform Dump
//////////////////////////////////////////////////////
initial begin
    $dumpfile("riscv.vcd");
    $dumpvars(0, riscv_core_tb);
end

endmodule