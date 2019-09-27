module EX(clk_ex, sr_data, tr_data, op_code_0, dr_addr_0, imm_0, alu_out, dr_addr_1, imm_1, op_code_1);
    input clk_ex;
    input [15:0] sr_data, tr_data, imm_0;
    input [3:0] op_code_0;
    input [2:0] dr_addr_0;
    output [15:0] alu_out, imm_1;
    output [3:0] op_code_1
    output [2:0] dr_addr_1;

    alu alu(clk_ex, op_code_0, sr_data, tr_data, imm_0, alu_out);

    always @(posedge clk_ex) begin
        imm_1 = imm_0;
        dr_addr_1 = dr_addr_0;
        op_code_1 = op_code_0;
    end
endmodule
