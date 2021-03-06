module cpu(
    input   wire            clk,
    input   wire    [31:0]  instr,
    output  reg     [31:0]  pc  = 32'h0000_0000,
    output  reg             EX_MEM_mem_w_en = 0,
    output  reg     [31:0]  EX_MEM_alu_out  = 32'h0000_0000,
    output  wire    [31:0]  mem_w_data,
    input   wire    [31:0]  mem_r_data
);

    reg [31:0]  IF_ID_instr = 32'h0000_0000;

    reg [31:0]  ID_EX_rs1_data  = 32'h0000_0000;
    reg [31:0]  ID_EX_rs2_data  = 32'h0000_0000;
    reg [4:0]   ID_EX_rs1_addr  = 5'b00000;
    reg [4:0]   ID_EX_rs2_addr  = 5'b00000;
    reg [4:0]   ID_EX_rd_addr   = 5'b00000;
    reg [31:0]  ID_EX_imm_I     = 32'h0000_0000;
    reg [31:0]  ID_EX_imm_S     = 32'h0000_0000;
    reg [3:0]   ID_EX_alu_ctrl  = 4'h0;
    reg [6:0]   ID_EX_opcode    = 7'b0000000;
    reg         ID_EX_rs2_imm_sel   = 0;
    reg         ID_EX_reg_w_en      = 0;
    reg         ID_EX_mem_w_en      = 0;
    reg         ID_EX_mem_alu_sel   = 0;
    reg         ID_EX_imm_SI_sel    = 0;

    reg         EX_MEM_reg_w_en = 0;
    reg [4:0]   EX_MEM_rd_addr  = 5'b00000;
    reg [4:0]   EX_MEM_rs2_addr = 5'b00000;
    reg         EX_MEM_mem_alu_sel = 0;
    reg [31:0]  EX_MEM_rs2_data = 32'h0000_0000;

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
    wire    [31:0]  imm_S;
    wire    [31:0]  imm_B;
    wire    [31:0]  uimm_B;
    wire    [31:0]  imm_data;

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

    wire            stall;

    wire            branch_detect;
    wire            branch_result;
    wire    [31:0]  branch_dest;

    main_decoder    main_decoder(
                        .instr      (IF_ID_instr),
                        .opcode     (opcode     ),
                        .funct3     (funct3     ),
                        .funct7     (funct7     ),
                        .rd_addr    (rd_addr    ),
                        .rs1_addr   (rs1_addr   ),
                        .rs2_addr   (rs2_addr   ),
                        .imm_I      (imm_I      ),
                        .imm_S      (imm_S      ),
                        .imm_B      (imm_B      ),
                        .uimm_B     (uimm_B     )
                    );

    main_controller main_controller(
                        .opcode         (opcode         ),
                        .rs2_imm_sel    (rs2_imm_sel    ),
                        .reg_w_en       (reg_w_en       ),
                        .mem_w_en       (mem_w_en       ),
                        .mem_alu_sel    (mem_alu_sel    ),
                        .imm_SI_sel     (imm_SI_sel     ),
                        .branch_detect  (branch_detect  )
                    );

    ALU_decoder     ALU_decoder(
                        .opcode     (opcode     ),
                        .funct3     (funct3     ),
                        .funct7     (funct7     ),
                        .alu_ctrl   (alu_ctrl   )
                    );

    assign imm_data = ID_EX_imm_SI_sel ? ID_EX_imm_I : ID_EX_imm_S;
    assign alu_data_1 = (ID_EX_rs1_addr == EX_MEM_rd_addr) & EX_MEM_reg_w_en    ? EX_MEM_alu_out
                      : (ID_EX_rs1_addr == MEM_WB_rd_addr) & MEM_WB_reg_w_en    ? reg_w_data     //MEM_WB_alu_out
                                                                                : ID_EX_rs1_data;
    assign alu_data_2 = ID_EX_rs2_imm_sel                  ? imm_data 
                      : (ID_EX_rs2_addr == EX_MEM_rd_addr) & EX_MEM_reg_w_en    ? EX_MEM_alu_out
                      : (ID_EX_rs2_addr == MEM_WB_rd_addr) & MEM_WB_reg_w_en    ? reg_w_data     //MEM_WB_alu_out
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

    assign mem_w_data = (MEM_WB_rd_addr == EX_MEM_rs2_addr) ? reg_w_data
                                                            : EX_MEM_rs2_data;

    pipeline_interlock  pipeline_interlock(
                            .opcode     (opcode   ),
                            .rd_addr    (rd_addr  ),
                            .rs1_addr   (rs1_addr ),
                            .rs2_addr   (rs2_addr ),
                            .clk        (clk      ),
                            .stall      (stall    )
                        );

    branch_judge  branch_judge(
                    .rs1_data       (rs1_data       ),
                    .rs2_data       (rs2_data       ),
                    .funct3         (funct3         ),
                    .branch_detect  (branch_detect  ),
                    .branch_result  (branch_result  )
                );

    assign branch_dest = pc + ((funct3 == 3'b110 || funct3 == 3'b111) ? uimm_B
                                                                      : imm_B);
    always @(posedge clk) begin
        if(stall) begin
            pc = pc;
        end else if(branch_result) begin
            pc = branch_dest;
        end else begin
            pc = pc + 32'h4;
        end
    end

    always @(posedge clk) begin
        if(stall) begin
            IF_ID_instr <= IF_ID_instr;
        end else if(branch_detect && branch_result) begin
            IF_ID_instr <= 32'h00000033;
        end else begin
            IF_ID_instr <= instr;
        end
    end

    always @(posedge clk) begin
        if(stall) begin
            ID_EX_rs1_data      <= ID_EX_rs1_data;
            ID_EX_rs2_data      <= ID_EX_rs2_data;
            ID_EX_rs1_addr      <= ID_EX_rs1_addr;
            ID_EX_rs2_addr      <= ID_EX_rs2_addr;
            ID_EX_rd_addr       <= ID_EX_rd_addr;
            ID_EX_imm_I         <= ID_EX_imm_I;
            ID_EX_imm_S         <= ID_EX_imm_S;
            ID_EX_alu_ctrl      <= ID_EX_alu_ctrl;
            ID_EX_rs2_imm_sel   <= ID_EX_rs2_imm_sel;
            ID_EX_reg_w_en      <= ID_EX_reg_w_en;
            ID_EX_mem_w_en      <= ID_EX_mem_w_en;
            ID_EX_mem_alu_sel   <= ID_EX_mem_alu_sel;
            ID_EX_imm_SI_sel    <= ID_EX_imm_SI_sel;
            ID_EX_opcode        <= ID_EX_opcode;
        end else begin
            ID_EX_rs1_data      <= rs1_data;
            ID_EX_rs2_data      <= rs2_data;
            ID_EX_rs1_addr      <= rs1_addr;
            ID_EX_rs2_addr      <= rs2_addr;
            ID_EX_rd_addr       <= rd_addr;
            ID_EX_imm_I         <= imm_I;
            ID_EX_imm_S         <= imm_S;
            ID_EX_alu_ctrl      <= alu_ctrl;
            ID_EX_rs2_imm_sel   <= rs2_imm_sel;
            ID_EX_reg_w_en      <= reg_w_en;
            ID_EX_mem_w_en      <= mem_w_en;
            ID_EX_mem_alu_sel   <= mem_alu_sel;
            ID_EX_imm_SI_sel    <= imm_SI_sel;
            ID_EX_opcode        <= opcode;
        end
    end

    always @(posedge clk) begin
        EX_MEM_alu_out      <= alu_out;
        EX_MEM_rd_addr      <= ID_EX_rd_addr;
        EX_MEM_rs2_addr     <= ID_EX_rs2_addr;
        if(stall) begin
            EX_MEM_mem_w_en     <= 0;
            EX_MEM_reg_w_en     <= 0;
        end else begin
            EX_MEM_mem_w_en     <= ID_EX_mem_w_en;
            EX_MEM_reg_w_en     <= ID_EX_reg_w_en;
        end
        EX_MEM_rs2_data     <= ID_EX_rs2_data;
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
