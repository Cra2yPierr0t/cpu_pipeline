module cpu(
    input   wire            clk,
    input   wire    [31:0]  instr,
    output  wire    [31:0]  instr_addr
);

    reg [31:0] IF_ID_instr;

    reg [31:0]  ID_EX_rs1_data;
    reg [31:0]  ID_EX_rs2_data;
    reg [4:0]   ID_EX_rd_addr;
    reg [3:0]   ID_EX_alu_ctrl;

    main_decoder    main_decoder(
                        .instr      (instr      ),
                        .funct3     (funct3     ),
                        .funct7     (funct7     ),
                        .rd_addr    (rd_addr    ),
                        .rs1_addr   (rs1_addr   ),
                        .rs2_addr   (rs2_addr   )
                    );

    ALU_decoder     ALU_decoder(
                        .funct3     (funct3     ),
                        .funct7     (funct7     ),
                        .alu_ctrl   (alu_ctrl   )
                    );

    ALU             ALU(
                        .alu_ctrl(alu_ctrl),
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
        ID_EX_alu_ctrl  <= alu_ctrl;
    end
endmodule
