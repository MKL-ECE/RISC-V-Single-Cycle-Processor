
module register_file (
    input  logic        clk,
    input  logic        reset,

    input  logic        reg_write,

    input  logic [4:0]  rs1,
    input  logic [4:0]  rs2,
    input  logic [4:0]  rd,

    input  logic [31:0] write_data,

    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data
);

    logic [31:0] registers [0:31];

    integer i;

    always_ff @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'd0;
        end
        else if (reg_write && rd != 5'd0) begin
            registers[rd] <= write_data;
        end
    end

    assign rs1_data =
        (rs1 == 5'd0) ? 32'd0 : registers[rs1];

    assign rs2_data =
        (rs2 == 5'd0) ? 32'd0 : registers[rs2];

endmodule
