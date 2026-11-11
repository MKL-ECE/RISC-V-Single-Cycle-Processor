
module program_counter (
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] pc_next,
    output logic [31:0] pc_current
);

    always_ff @(posedge clk) begin
        if (reset)
            pc_current <= 32'd0;
        else
            pc_current <= pc_next;
    end

endmodule
