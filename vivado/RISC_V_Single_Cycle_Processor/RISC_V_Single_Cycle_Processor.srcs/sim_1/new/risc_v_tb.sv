`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2026 19:00:04
// Design Name: 
// Module Name: risc_v_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////




`timescale 1ns / 1ps

module risc_v_tb;

    logic clk;
    logic reset;

    logic [31:0] pc_out;
    logic [31:0] instruction_out;


    // -----------------------------------------
    // Device Under Test
    // -----------------------------------------

    risc_v_top dut (
        .clk(clk),
        .reset(reset),
        .pc_out(pc_out),
        .instruction_out(instruction_out)
    );


    // -----------------------------------------
    // Clock Generation
    // 10 ns clock period
    // -----------------------------------------

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end


    // -----------------------------------------
    // Reset Generation
    // -----------------------------------------

    initial begin
        reset = 1'b1;
        #20;
        reset = 1'b0;
    end


    // -----------------------------------------
    // Comprehensive Processor Test
    // -----------------------------------------

    initial begin

        // Wait until JALR target instruction executes
        wait (pc_out == 32'd220);

        // Allow nonblocking assignments to settle
        #1;

        $display("--------------------------------");
        $display("RISC-V PROCESSOR TEST RESULTS");
        $display("--------------------------------");


        // Arithmetic and logical operations

        if (dut.RF.registers[1] !== 32'd5)
            $fatal(1, "FAIL: x1");

        if (dut.RF.registers[2] !== 32'd3)
            $fatal(1, "FAIL: x2");

        if (dut.RF.registers[3] !== 32'd8)
            $fatal(1, "FAIL: ADD");

        if (dut.RF.registers[4] !== 32'd2)
            $fatal(1, "FAIL: SUB");

        if (dut.RF.registers[5] !== 32'd1)
            $fatal(1, "FAIL: AND");


        // Signed and unsigned comparisons

        if (dut.RF.registers[17] !== 32'd1)
            $fatal(1, "FAIL: SLTI");

        if (dut.RF.registers[18] !== 32'd0)
            $fatal(1, "FAIL: SLTIU");


        // Memory operations

        if (dut.RF.registers[24] !== 32'd8)
            $fatal(1, "FAIL: LW");

        if (dut.RF.registers[26] !== 32'hFFFFFF80)
            $fatal(1, "FAIL: LB");

        if (dut.RF.registers[27] !== 32'h00000080)
            $fatal(1, "FAIL: LBU");

        if (dut.RF.registers[29] !== 32'hFFFF8001)
            $fatal(1, "FAIL: LH");

        if (dut.RF.registers[30] !== 32'h00008001)
            $fatal(1, "FAIL: LHU");


        // Branch and jump checks

        if (dut.RF.registers[30] !== 32'h00008001)
            $fatal(1, "FAIL: Branch or jump skipped instruction");

        if (dut.RF.registers[6] !== 32'd192)
            $fatal(1, "FAIL: JAL return address");

        if (dut.RF.registers[7] !== 32'd42)
            $fatal(1, "FAIL: JAL target");

        if (dut.RF.registers[8] !== 32'd208)
            $fatal(1, "FAIL: JALR return address");

        if (dut.RF.registers[10] !== 32'd55)
            $fatal(1, "FAIL: JALR target");


        // AUIPC check

        if (dut.RF.registers[23] !== 32'h00001058)
            $fatal(1, "FAIL: AUIPC");


        // x0 must always remain zero

        if (dut.RF.registers[0] !== 32'd0)
            $fatal(1, "FAIL: x0 modified");


        // Data Memory checks

        if (dut.DMEM.memory[0] !== 32'd8)
            $fatal(1, "FAIL: SW memory value");

        if (dut.DMEM.memory[1] !== 32'h00000080)
            $fatal(1, "FAIL: SB memory value");

        if (dut.DMEM.memory[2] !== 32'h00008001)
            $fatal(1, "FAIL: SH memory value");


        $display("Arithmetic tests       : PASSED");
        $display("Logical tests           : PASSED");
        $display("Comparison tests        : PASSED");
        $display("Memory tests            : PASSED");
        $display("Branch tests            : PASSED");
        $display("Jump tests              : PASSED");
        $display("Upper immediate tests   : PASSED");

        $display("--------------------------------");
        $display("ALL TESTS PASSED!");
        $display("--------------------------------");

        $finish;

    end


    // -----------------------------------------
    // Simulation Timeout
    // -----------------------------------------

    initial begin
        #1000;
        $fatal(1, "TEST FAILED: Simulation timeout");
    end

endmodule
