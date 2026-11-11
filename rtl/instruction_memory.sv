
module instruction_memory (
    input  logic [31:0] address,
    output logic [31:0] instruction
);

    logic [31:0] memory [0:255];

    integer i;

    initial begin

        // Fill unused instruction locations with NOP
        for (i = 0; i < 256; i = i + 1) begin
            memory[i] = 32'h00000013;
        end

        // Load the test program
        $readmemh("comprehensive_test.mem", memory);

    end

    // Word-aligned instruction addressing
    assign instruction = memory[address[9:2]];

endmodule
