module main_decoder(
    input   wire    [31:0]  instr,
    output  wire    [6:0]   opcode,
    output  wire    [2:0]   funct3,
    output  wire    [6:0]   funct7,
    output  wire    [4:0]   rd_addr,
    output  wire    [4:0]   rs1_addr,
    output  wire    [4:0]   rs2_addr,
    output  wire    [31:0]  imm_I,
    output  wire    [31:0]  imm_S,
    output  wire    [31:0]  imm_B,
    output  wire    [31:0]  uimm_B,
    output  wire    [31:0]  imm_U,
    output  wire    [31:0]  imm_J,
    output  wire    [31:0]  uimm_J
);

    assign opcode   = instr[6:0];
    assign funct3   = instr[14:12];
    assign funct7   = instr[31:25];
    assign rd_addr  = instr[11:7];
    assign rs1_addr = instr[19:15];
    assign rs2_addr = instr[24:20];
    assign imm_I    = instr[31] ? {20'hfffff, instr[31:20]} 
                                : {20'h00000, instr[31:20]};
    assign imm_S   = {20'h00000, instr[31:25], instr[11:7]};
    assign imm_B    = instr[31] ? {16'hffff, 3'b111, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}
                                : {16'h0000, 3'b000, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
    assign uimm_B   = {16'h0000, 3'b000, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
    assign imm_U    = {instr[31:12], 12'h000};
    assign imm_J    = instr[31] ? {8'hff, 3'b111, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}
                                : {8'h00, 3'b000, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
    assign uimm_J   = {8'h00, 3'b000, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
endmodule
