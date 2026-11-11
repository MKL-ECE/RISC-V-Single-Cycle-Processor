
module risc_v_top (
    input  logic        clk,
    input  logic        reset,

    output logic [31:0] pc_out,
    output logic [31:0] instruction_out
);

    // ------------------------------------------------
    // Internal signals
    // ------------------------------------------------

    logic [31:0] pc_current;
    logic [31:0] pc_next;
    logic [31:0] pc_plus4;

    logic [31:0] instruction;

    logic [31:0] rs1_data;
    logic [31:0] rs2_data;
    logic [31:0] immediate;

    logic [31:0] alu_operand_a;
    logic [31:0] alu_operand_b;
    logic [31:0] alu_result;

    logic [31:0] memory_data;
    logic [31:0] writeback_data;

    logic [31:0] branch_target;
    logic [31:0] jalr_target;

    // Control signals
    logic reg_write;
    logic mem_write;
    logic mem_read;
    logic alu_src;

    logic branch;
    logic jump;
    logic jalr;
    logic branch_taken;

    logic [3:0] alu_control;
    logic [1:0] result_src;

    // Instruction fields
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;

    logic [6:0] opcode;
    logic [2:0] funct3;

    assign opcode = instruction[6:0];
    assign funct3 = instruction[14:12];

    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rd  = instruction[11:7];


    // ------------------------------------------------
    // 1. Program Counter
    // ------------------------------------------------

    program_counter PC (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc_current(pc_current)
    );

    assign pc_plus4 = pc_current + 32'd4;


    // ------------------------------------------------
    // 2. Instruction Memory
    // ------------------------------------------------

    instruction_memory IMEM (
        .address(pc_current),
        .instruction(instruction)
    );


    // ------------------------------------------------
    // 3. Control Unit
    // ------------------------------------------------

    control_unit CU (
        .instruction(instruction),

        .reg_write(reg_write),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .alu_src(alu_src),

        .branch(branch),
        .jump(jump),
        .jalr(jalr),

        .alu_control(alu_control),
        .result_src(result_src)
    );


    // ------------------------------------------------
    // 4. Register File
    // ------------------------------------------------

    register_file RF (
        .clk(clk),
        .reset(reset),

        .reg_write(reg_write),

        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),

        .write_data(writeback_data),

        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );


    // ------------------------------------------------
    // 5. Immediate Generator
    // ------------------------------------------------

    immediate_generator IMM (
        .instruction(instruction),
        .immediate(immediate)
    );


    // ------------------------------------------------
    // 6. ALU Input Selection
    // ------------------------------------------------

    // AUIPC uses PC as its first operand.
    assign alu_operand_a =
        (opcode == 7'b0010111) ? pc_current : rs1_data;

    // Select register data or immediate.
    assign alu_operand_b =
        alu_src ? immediate : rs2_data;


    // ------------------------------------------------
    // 7. ALU
    // ------------------------------------------------

    alu ALU (
        .operand_a(alu_operand_a),
        .operand_b(alu_operand_b),
        .alu_control(alu_control),
        .alu_result(alu_result)
    );


    // ------------------------------------------------
    // 8. Branch Unit
    // ------------------------------------------------

    branch_unit BU (
        .operand_a(rs1_data),
        .operand_b(rs2_data),
        .funct3(funct3),
        .branch_taken(branch_taken)
    );


    // ------------------------------------------------
    // 9. Data Memory
    // ------------------------------------------------

    data_memory DMEM (
        .clk(clk),
        .reset(reset),

        .mem_write(mem_write),
        .mem_read(mem_read),

        .address(alu_result),
        .write_data(rs2_data),
        .funct3(funct3),

        .read_data(memory_data)
    );


    // ------------------------------------------------
    // 10. Writeback Multiplexer
    // ------------------------------------------------

    writeback_mux WBMUX (
        .alu_result(alu_result),
        .memory_data(memory_data),
        .pc_plus4(pc_plus4),
        .immediate(immediate),

        .result_src(result_src),

        .writeback_data(writeback_data)
    );


    // ------------------------------------------------
    // 11. Next PC Selection
    // ------------------------------------------------

    assign branch_target = pc_current + immediate;

    // Clear bit 0 for JALR.
    assign jalr_target =
        (rs1_data + immediate) & 32'hFFFFFFFE;

    always_comb begin

        if (jalr)
            pc_next = jalr_target;

        else if (jump)
            pc_next = branch_target;

        else if (branch && branch_taken)
            pc_next = branch_target;

        else
            pc_next = pc_plus4;

    end


    // ------------------------------------------------
    // 12. Output signals
    // ------------------------------------------------

    assign pc_out = pc_current;
    assign instruction_out = instruction;

endmodule
