
module writeback_mux (
    input  logic [31:0] alu_result,
    input  logic [31:0] memory_data,
    input  logic [31:0] pc_plus4,
    input  logic [31:0] immediate,

    input  logic [1:0] result_src,

    output logic [31:0] writeback_data
);

    always_comb begin

        case (result_src)

            2'b00:
                writeback_data = alu_result;

            2'b01:
                writeback_data = memory_data;

            2'b10:
                writeback_data = pc_plus4;

            2'b11:
                writeback_data = immediate;

            default:
                writeback_data = 32'd0;

        endcase

    end

endmodule
