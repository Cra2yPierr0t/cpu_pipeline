module FT(clk_fe, imm, pc_ctrl, instruction);
    input clk_fe;
    input [15:0] imm;
    input pc_ctrl;
    output [15:0] instruction;

    reg [15:0] pc;
    reg [15:0] rom[31:0];
    
    always @(posedge clk_fe) begin
        pc <= pc_ctrl ? pc + imm : pc + 1;
        instruction <= rom[pc];
    end
endmodule
