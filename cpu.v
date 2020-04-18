module cpu(
    input   wire            clk,
    input   wire    [31:0]  instr,
    output  reg     [31:0]  pc  = 32'h0000_0000,
    output  reg             EX_MEM_mem_w_en = 0,
    output  reg     [31:0]  EX_MEM_alu_out  = 32'h0000_0000,
    output  reg     [31:0]  EX_MEM_rs2_data = 32'h0000_0000,
    input   wire    [31:0]  mem_r_data
);

    reg [31:0]  IF_ID_instr = 32'h0000_0000;

    reg [31:0]  ID_EX_rs1_data  = 32'h0000_0000;
    reg [31:0]  ID_EX_rs2_data  = 32'h0000_0000;
    reg [4:0]   ID_EX_rs1_addr  = 5'b00000;
    reg [4:0]   ID_EX_rs2_addr  = 5'b00000;
    reg [4:0]   ID_EX_rd_addr   = 5'b00000;
    reg [31:0]  ID_EX_imm_I     = 32'h0000_0000;
    reg [3:0]   ID_EX_alu_ctrl  = 4'h0;
    reg         ID_EX_rs2_imm_sel   = 0;
    reg         ID_EX_reg_w_en      = 0;
    reg         ID_EX_mem_w_en      = 0;
    reg         ID_EX_mem_alu_sel   = 0;

    reg         EX_MEM_reg_w_en = 0;
    reg [4:0]   EX_MEM_rd_addr  = 5'b00000;
    reg         EX_MEM_mem_alu_sel = 0;

    reg [31:0]  MEM_WB_mem_r_data   = 32'h0000_0000;
    reg [31:0]  MEM_WB_alu_out      = 32'h0000_0000;
    reg [4:0]   MEM_WB_rd_addr      = 5'b00000;
    reg         MEM_WB_reg_w_en     = 0;
    reg         MEM_WB_mem_alu_sel  = 0;

    wire    [6:0]   opcode;
    wire    [2:0]   funct3;
    wire    [6:0]   funct7;
    wire    [4:0]   rd_addr;
    wire    [4:0]   rs1_addr;
    wire    [4:0]   rs2_addr;
    wire    [31:0]  imm_I;

    wire            rs2_imm_sel;
    wire            reg_w_en;
    wire            mem_w_en;
    wire            mem_alu_sel;

    wire    [3:0]   alu_ctrl;

    wire    [31:0]  alu_data_1;
    wire    [31:0]  alu_data_2;
    wire    [31:0]  alu_out;

    wire    [31:0]  rs1_data;
    wire    [31:0]  rs2_data;
    wire    [31:0]  reg_w_data;

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
                        .opcode         (opcode         ),
                        .rs2_imm_sel    (rs2_imm_sel    ),
                        .reg_w_en       (reg_w_en       ),
                        .mem_w_en       (mem_w_en       ),
                        .mem_alu_sel    (mem_alu_sel    )
                    );

    ALU_decoder     ALU_decoder(
                        .opcode     (opcode     ),
                        .funct3     (funct3     ),
                        .funct7     (funct7     ),
                        .alu_ctrl   (alu_ctrl   )
                    );

    assign alu_data_1 = (ID_EX_rs1_addr == EX_MEM_rd_addr) ? EX_MEM_alu_out
                      : (ID_EX_rs1_addr == MEM_WB_rd_addr) ? MEM_WB_alu_out
                                                           : ID_EX_rs1_data;

    assign alu_data_2 = ID_EX_rs2_imm_sel                  ? ID_EX_imm_I 
                      : (ID_EX_rs2_addr == EX_MEM_rd_addr) ? EX_MEM_alu_out
                      : (ID_EX_rs2_addr == MEM_WB_rd_addr) ? MEM_WB_alu_out
                      : ID_EX_rs2_data; 
    ALU             ALU(
                        .alu_ctrl   (ID_EX_alu_ctrl ),
                        .alu_data_1 (alu_data_1     ),
                        .alu_data_2 (alu_data_2     ),
                        .alu_out    (alu_out        )
                    );

    assign reg_w_data = MEM_WB_mem_alu_sel ? MEM_WB_alu_out : MEM_WB_mem_r_data;
    regfile         regfile(
                        .rs1_addr   (rs1_addr           ),
                        .rs2_addr   (rs2_addr           ),
                        .rs1_data   (rs1_data           ),
                        .rs2_data   (rs2_data           ),
                        .rd_addr    (MEM_WB_rd_addr     ),
                        .w_data     (reg_w_data         ),
                        .w_en       (MEM_WB_reg_w_en    ),
                        .clk        (clk)
                    );

    always @(posedge clk) begin
        pc = pc + 32'h4;
    end

    always @(posedge clk) begin
        IF_ID_instr <= instr;
    end

    always @(posedge clk) begin
        ID_EX_rs1_data      <= rs1_data;
        ID_EX_rs2_data      <= rs2_data;
        ID_EX_rs1_addr      <= rs1_addr;
        ID_EX_rs2_addr      <= rs2_addr;
        ID_EX_rd_addr       <= rd_addr;
        ID_EX_imm_I         <= imm_I;
        ID_EX_alu_ctrl      <= alu_ctrl;
        ID_EX_rs2_imm_sel   <= rs2_imm_sel;
        ID_EX_reg_w_en      <= reg_w_en;
        ID_EX_mem_w_en      <= mem_w_en;
        ID_EX_mem_alu_sel   <= mem_alu_sel;
    end

    always @(posedge clk) begin
        EX_MEM_alu_out      <= alu_out;
        EX_MEM_rd_addr      <= ID_EX_rd_addr;
        EX_MEM_mem_w_en     <= ID_EX_mem_w_en;
        EX_MEM_reg_w_en     <= ID_EX_reg_w_en;
        EX_MEM_mem_alu_sel  <= ID_EX_mem_alu_sel;
    end

    always @(posedge clk) begin
        MEM_WB_mem_r_data   <= mem_r_data;
        MEM_WB_alu_out      <= EX_MEM_alu_out;
        MEM_WB_rd_addr      <= EX_MEM_rd_addr;
        MEM_WB_reg_w_en     <= EX_MEM_reg_w_en; 
        MEM_WB_mem_alu_sel  <= EX_MEM_mem_alu_sel;
    end
endmodule
