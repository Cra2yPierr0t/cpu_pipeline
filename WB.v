module WB(clk_wb, alu_out, op_code_1, dr_addr_1, imm_1, sr_addr, tr_addr, sr_data_0, tr_data_0);
    input clk_wb;
    input [15:0] alu_out, imm_1;
    input [3:0] op_code_1;
    input [2:0] dr_addr_1, sr_addr, tr_addr;
    output [15:0] sr_data_0, tr_data_0;
    
    reg [15:0] dr_data, ram_out;

    RAM RAM(clk_wb, imm_1, alu_out, ram_we, ram_out);
    REG REG(clk_wb, sr_addr, tr_addr, dr_addr, reg_we, dr_data, sr_data_0, dr_data_0);

    always @(posedge clk_wb) begin
        case(op_code_1)
            4'b0110: dr_data = ram_out;
            default: dr_data = alu_out;
        endcase

        case(op_code_1)
            4'b0111: ram_we = 1'b1;
            default: ram_we = 1'b0;
        endcase

        case(op_code_1)
            4'b0101: reg_we = 1'b0;
            4'b0100: reg_we = 1'b0;
            4'b0111: reg_we = 1'b0;
            default: reg_we = 1'b0;
        endcase
    end
endmodule
