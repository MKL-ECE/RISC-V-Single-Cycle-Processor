
module alu (
    input  logic [31:0] operand_a,
    input  logic [31:0] operand_b,
    input  logic [3:0]  alu_control,

    output logic [31:0] alu_result
);

    always_comb begin

        case (alu_control)

            // Addition
            4'b0000:
                alu_result = operand_a + operand_b;

            // Subtraction
            4'b0001:
                alu_result = operand_a - operand_b;

            // Bitwise AND
            4'b0010:
                alu_result = operand_a & operand_b;

            // Bitwise OR
            4'b0011:
                alu_result = operand_a | operand_b;

            // Bitwise XOR
            4'b0100:
                alu_result = operand_a ^ operand_b;

            // Signed less than
            4'b0101:
                alu_result = ($signed(operand_a) <
                              $signed(operand_b)) ? 32'd1 : 32'd0;

            // Unsigned less than
            4'b0110:
                alu_result = (operand_a < operand_b) ? 32'd1 : 32'd0;

            // Shift left logical
            4'b0111:
                alu_result = operand_a << operand_b[4:0];

            // Shift right logical
            4'b1000:
                alu_result = operand_a >> operand_b[4:0];

            // Shift right arithmetic
            4'b1001:
                alu_result = $signed(operand_a) >>> operand_b[4:0];

            default:
                alu_result = 32'd0;

        endcase

    end

endmodule
