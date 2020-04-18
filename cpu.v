module cpu(
    input   wire            clk,
    input   wire    [31:0]  instr,
    output  wire    [31:0]  instr_addr,
    output  reg             EX_MEM_mem_w_en,
    output  reg     [31:0]  EX_MEM_rd_addr,
    output  reg     [31:0]  EX_MEM_alu_out,
    input   wire    [31:0]  mem_r_data
);

    reg [31:0] IF_ID_instr;

    reg [31:0]  ID_EX_rs1_data;
    reg [31:0]  ID_EX_rs2_data;
    reg [4:0]   ID_EX_rd_addr;
    reg [31:0]  ID_EX_imm_I;
    reg [3:0]   ID_EX_alu_ctrl;
    reg         ID_EX_rs2_imm_sel;
    reg         ID_EX_reg_w_en;

    reg [31:0]  EX_MEM_alu_out;
    reg         EX_MEM_reg_w_en;

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

    main_controller main_controller(
                        .opcode     (opcode     ),
                        .rs2_imm_sel(rs2_imm_sel),
                        .reg_w_en   (rs2_w_en   ),
                        .mem_w_en   (mem_w_en   )
                    );

    ALU_decoder     ALU_decoder(
                        .funct3     (funct3     ),
                        .funct7     (funct7     ),
                        .alu_ctrl   (alu_ctrl   )
                    );
    
    assign alu_data_2 = ID_EX_rs2_imm_sel ? ID_EX_imm_I : ID_EX_rs2_data; 
    ALU             ALU(
                        .alu_ctrl   (alu_ctrl   ),
                        .alu_data_1 (alu_data_1 ),
                        .alu_data_2 (alu_data_2 ),
                        .alu_out    (alu_out    )
                    );

    regfile         regfile(
                        .rs1_addr   (rs1_addr           ),
                        .rs2_addr   (rs2_addr           ),
                        .rs1_data   (rs1_data           ),
                        .rs2_data   (rs2_data           ),
                        .rd_addr    (MEM_WB_mem_rd_addr ),
                        .w_data     (MEM_WB_mem_r_data  ),
                        .w_en       (MEM_WB_reg_w_en    ),
                        .clk        ()
                    );

    always @(posedge clk) begin
        IF_ID_instr <= instr;
    end

    always @(posedge clk) begin
        ID_EX_rs1_data      <= rs1_data;
        ID_EX_rs2_data      <= rs2_data;
        ID_EX_rd_addr       <= rd_addr;
        ID_EX_imm_I         <= imm_I;
        ID_EX_alu_ctrl      <= alu_ctrl;
        ID_EX_rs2_imm_sel   <= rs2_imm_sel;
        ID_EX_reg_w_en      <= reg_w_en;
        ID_EX_mem_w_en      <= mem_w_en;
    end

    always @(posedge clk) begin
        EX_MEM_alu_out  <= alu_out;
        EX_MEM_rd_addr  <= ID_EX_rd_addr;
        EX_MEM_mem_w_en <= ID_EX_mem_w_en;
        EX_MEM_reg_w_en <= ID_EX_reg_w_en;
    end

    always @(posedge clk) begin
        MEM_WB_mem_r_data   <= mem_r_data;
        MEM_WB_rd_addr      <= EX_MEM_rd_addr;
        MEM_WB_reg_w_en     <= EX_MEM_reg_w_en; 
    end
endmodule
