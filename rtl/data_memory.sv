
module data_memory (
    input  logic        clk,
    input  logic        reset,

    input  logic        mem_write,
    input  logic        mem_read,

    input  logic [31:0] address,
    input  logic [31:0] write_data,
    input  logic [2:0]  funct3,

    output logic [31:0] read_data
);

    logic [31:0] memory [0:255];

    logic [31:0] selected_word;
    logic [31:0] shifted_word;

    integer i;

    // Initialize and write memory
    always_ff @(posedge clk) begin

        if (reset) begin
            for (i = 0; i < 256; i = i + 1)
                memory[i] <= 32'd0;
        end

        else if (mem_write) begin

            case (funct3)

                // SB: Store byte
                3'b000: begin
                    case (address[1:0])
                        2'b00: memory[address[9:2]][7:0]   <= write_data[7:0];
                        2'b01: memory[address[9:2]][15:8]  <= write_data[7:0];
                        2'b10: memory[address[9:2]][23:16] <= write_data[7:0];
                        2'b11: memory[address[9:2]][31:24] <= write_data[7:0];
                    endcase
                end

                // SH: Store halfword
                3'b001: begin
                    case (address[1])
                        1'b0: memory[address[9:2]][15:0]  <= write_data[15:0];
                        1'b1: memory[address[9:2]][31:16] <= write_data[15:0];
                    endcase
                end

                // SW: Store word
                3'b010: begin
                    memory[address[9:2]] <= write_data;
                end

                default: begin
                    // Unsupported store: no operation
                end

            endcase
        end
    end

    // Select the addressed word
    assign selected_word = memory[address[9:2]];

    // Move the addressed byte/halfword to the least significant bits
    assign shifted_word = selected_word >> (address[1:0] * 8);

    // Load operations
    always_comb begin

        read_data = 32'd0;

        if (mem_read) begin

            case (funct3)

                // LB: Sign-extended byte
                3'b000:
                    read_data = {{24{shifted_word[7]}},
                                  shifted_word[7:0]};

                // LH: Sign-extended halfword
                3'b001:
                    read_data = {{16{shifted_word[15]}},
                                  shifted_word[15:0]};

                // LW: Full word
                3'b010:
                    read_data = selected_word;

                // LBU: Zero-extended byte
                3'b100:
                    read_data = {24'd0, shifted_word[7:0]};

                // LHU: Zero-extended halfword
                3'b101:
                    read_data = {16'd0, shifted_word[15:0]};

                default:
                    read_data = 32'd0;

            endcase
        end
    end

endmodule
