module cpu(
    input   wire            clk,
    input   wire    [31:0]  instr,
    output  wire    [31:0]  instr_addr
);

    reg [31:0] IF_ID_instr;

    reg [31:0]  ID_EX_rs1_data;
    reg [31:0]  ID_EX_rs2_data;
    reg [4:0]   ID_EX_rd_addr;
    reg [31:0]  ID_EX_imm_I;
    reg [3:0]   ID_EX_alu_ctrl;

    main_decoder    main_decoder(
                        .instr      (instr      ),
                        .opcode     (opcode     ),
                        .funct3     (funct3     ),
                        .funct7     (funct7     ),
                        .rd_addr    (rd_addr    ),
                        .rs1_addr   (rs1_addr   ),
                        .rs2_addr   (rs2_addr   ),
                        .imm_I      (imm_I      )
                    );

    ALU_decoder     ALU_decoder(
                        .funct3     (funct3     ),
                        .funct7     (funct7     ),
                        .alu_ctrl   (alu_ctrl   )
                    );

    ALU             ALU(
                        .alu_ctrl   (alu_ctrl   ),
                        .alu_data_1 (alu_data_1 ),
                        .alu_data_2 (alu_data_2 ),
                        .alu_out    (alu_out    )
                    );

    regfile         regfile(
                        .rs1_addr(rs1_addr),
                        .rs2_addr(rs2_addr),
                        .rs1_data(rs1_data),
                        .rs2_data(rs2_data)
                    );

    always @(posedge clk) begin
        IF_ID_instr <= instr;
    end

    always @(posedge clk) begin
        ID_EX_rs1_data  <= rs1_data;
        ID_EX_rs2_data  <= rs2_data;
        ID_EX_rd_addr   <= rd_addr;
        ID_EX_imm_I     <= imm_I;
        ID_EX_alu_ctrl  <= alu_ctrl;
    end

    always @(posedge clk) begin
        EX_MEM_alu_out <=  alu_out;
    end
endmodule
