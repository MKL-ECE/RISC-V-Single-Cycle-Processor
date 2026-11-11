
module control_unit (
    input  logic [31:0] instruction,

    output logic        reg_write,
    output logic        mem_write,
    output logic        mem_read,
    output logic        alu_src,

    output logic        branch,
    output logic        jump,
    output logic        jalr,

    output logic [3:0]  alu_control,
    output logic [1:0]  result_src
);

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];

    always_comb begin

        // Default control signals: no operation
        reg_write  = 1'b0;
        mem_write  = 1'b0;
        mem_read   = 1'b0;
        alu_src    = 1'b0;

        branch     = 1'b0;
        jump       = 1'b0;
        jalr       = 1'b0;

        alu_control = 4'b0000;
        result_src  = 2'b00;


        case (opcode)

            // -----------------------------------------
            // R-TYPE: ADD, SUB, AND, OR, XOR,
            //         SLT, SLTU, SLL, SRL, SRA
            // -----------------------------------------

            7'b0110011: begin

                case (funct3)

                    3'b000: begin
                        if (funct7 == 7'b0000000) begin
                            reg_write = 1'b1;
                            alu_control = 4'b0000; // ADD
                        end
                        else if (funct7 == 7'b0100000) begin
                            reg_write = 1'b1;
                            alu_control = 4'b0001; // SUB
                        end
                    end

                    3'b111: begin
                        if (funct7 == 7'b0000000) begin
                            reg_write = 1'b1;
                            alu_control = 4'b0010; // AND
                        end
                    end

                    3'b110: begin
                        if (funct7 == 7'b0000000) begin
                            reg_write = 1'b1;
                            alu_control = 4'b0011; // OR
                        end
                    end

                    3'b100: begin
                        if (funct7 == 7'b0000000) begin
                            reg_write = 1'b1;
                            alu_control = 4'b0100; // XOR
                        end
                    end

                    3'b010: begin
                        if (funct7 == 7'b0000000) begin
                            reg_write = 1'b1;
                            alu_control = 4'b0101; // SLT
                        end
                    end

                    3'b011: begin
                        if (funct7 == 7'b0000000) begin
                            reg_write = 1'b1;
                            alu_control = 4'b0110; // SLTU
                        end
                    end

                    3'b001: begin
                        if (funct7 == 7'b0000000) begin
                            reg_write = 1'b1;
                            alu_control = 4'b0111; // SLL
                        end
                    end

                    3'b101: begin
                        if (funct7 == 7'b0000000) begin
                            reg_write = 1'b1;
                            alu_control = 4'b1000; // SRL
                        end
                        else if (funct7 == 7'b0100000) begin
                            reg_write = 1'b1;
                            alu_control = 4'b1001; // SRA
                        end
                    end

                    default: begin
                    end

                endcase
            end


            // -----------------------------------------
            // I-TYPE: ADDI, ANDI, ORI, XORI,
            //         SLTI, SLTIU, SLLI, SRLI, SRAI
            // -----------------------------------------

            7'b0010011: begin

                case (funct3)

                    3'b000: begin
                        reg_write = 1'b1;
                        alu_src = 1'b1;
                        alu_control = 4'b0000; // ADDI
                    end

                    3'b111: begin
                        reg_write = 1'b1;
                        alu_src = 1'b1;
                        alu_control = 4'b0010; // ANDI
                    end

                    3'b110: begin
                        reg_write = 1'b1;
                        alu_src = 1'b1;
                        alu_control = 4'b0011; // ORI
                    end

                    3'b100: begin
                        reg_write = 1'b1;
                        alu_src = 1'b1;
                        alu_control = 4'b0100; // XORI
                    end

                    3'b010: begin
                        reg_write = 1'b1;
                        alu_src = 1'b1;
                        alu_control = 4'b0101; // SLTI
                    end

                    3'b011: begin
                        reg_write = 1'b1;
                        alu_src = 1'b1;
                        alu_control = 4'b0110; // SLTIU
                    end

                    3'b001: begin
                        if (funct7 == 7'b0000000) begin
                            reg_write = 1'b1;
                            alu_src = 1'b1;
                            alu_control = 4'b0111; // SLLI
                        end
                    end

                    3'b101: begin
                        if (funct7 == 7'b0000000) begin
                            reg_write = 1'b1;
                            alu_src = 1'b1;
                            alu_control = 4'b1000; // SRLI
                        end
                        else if (funct7 == 7'b0100000) begin
                            reg_write = 1'b1;
                            alu_src = 1'b1;
                            alu_control = 4'b1001; // SRAI
                        end
                    end

                    default: begin
                    end

                endcase
            end


            // -----------------------------------------
            // LOAD: LB, LH, LW, LBU, LHU
            // -----------------------------------------

            7'b0000011: begin

                case (funct3)

                    3'b000,
                    3'b001,
                    3'b010,
                    3'b100,
                    3'b101: begin

                        reg_write = 1'b1;
                        mem_read = 1'b1;
                        alu_src = 1'b1;

                        alu_control = 4'b0000; // Address addition
                        result_src = 2'b01;    // Memory data
                    end

                    default: begin
                    end

                endcase
            end


            // -----------------------------------------
            // STORE: SB, SH, SW
            // -----------------------------------------

            7'b0100011: begin

                case (funct3)

                    3'b000,
                    3'b001,
                    3'b010: begin

                        mem_write = 1'b1;
                        alu_src = 1'b1;

                        alu_control = 4'b0000; // Address addition
                    end

                    default: begin
                    end

                endcase
            end


            // -----------------------------------------
            // BRANCH: BEQ, BNE, BLT, BGE,
            //         BLTU, BGEU
            // -----------------------------------------

            7'b1100011: begin

                case (funct3)

                    3'b000,
                    3'b001,
                    3'b100,
                    3'b101,
                    3'b110,
                    3'b111: begin

                        branch = 1'b1;
                        alu_control = 4'b0001; // SUB
                    end

                    default: begin
                    end

                endcase
            end


            // -----------------------------------------
            // JAL
            // -----------------------------------------

            7'b1101111: begin

                reg_write = 1'b1;
                jump = 1'b1;

                result_src = 2'b10; // PC + 4
            end


            // -----------------------------------------
            // JALR
            // -----------------------------------------

            7'b1100111: begin

                if (funct3 == 3'b000) begin

                    reg_write = 1'b1;
                    jump = 1'b1;
                    jalr = 1'b1;

                    result_src = 2'b10; // PC + 4
                end
            end


            // -----------------------------------------
            // LUI
            // -----------------------------------------

            7'b0110111: begin

                reg_write = 1'b1;

                result_src = 2'b11; // Immediate
            end


            // -----------------------------------------
            // AUIPC
            // -----------------------------------------

            7'b0010111: begin

                reg_write = 1'b1;
                alu_src = 1'b1;

                alu_control = 4'b0000; // PC + Immediate
            end


            // -----------------------------------------
            // FENCE
            // Simplified single-cycle model: no operation
            // -----------------------------------------

            7'b0001111: begin
                // No memory-ordering implementation
            end


            default: begin
                // Unsupported instruction: no operation
            end

        endcase

    end

endmodule
