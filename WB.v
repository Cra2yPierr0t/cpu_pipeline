module WB(clk_wb, alu_out, op_code_1, dr_addr_1, imm_1, sr_addr, tr_addr, sr_data_0, tr_data_0);
    input clk_wb;
    input [15:0] alu_out, imm_1;
    input [3:0] op_code_1;
    input [2:0] dr_addr_1;
    output [15:0] sr_data_0, tr_data_0;
    
    RAM RAM(clk_wb);
    REG REG(clk_wb);

    always @(posedge clk_wb) begin
        
    end
