module cpu(clk);
    input clk;

    wire clk_fe, clk_dc, clk_ex, clk_wb;

    clk_gen clk_gen(clk, clk_fe, clk_dc, clk_ex, clk_wb);
    
    FE FE(clk_fe, imm_2, pc_ctrl, instruction);
    DC DC(clk_dc, instruction, sr_data_0, tr_data_0, sr_addr, tr_addr, dr_addr_0, sr_data_1, tr_data_1, imm_0, op_code_0);
    EX EX(clk_ex, sr_data_1, tr_data_1, op_code_0, dr_addr_0, imm_0, alu_out, dr_addr_1, imm_1, op_code_1);
    WB WB(clk_wb, sr_addr, tr_addr, alu_out, dr_1, imm_2, reg_data, reg_we, ram_we, ram_out, sr_data, tr_data);
endmodule
