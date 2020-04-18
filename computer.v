module computer(
    input   wire    clk
);

    wire    [31:0]  pc;
    wire    [31:0]  instr;
    wire            mem_w_en;
    wire    [31:0]  alu_out;
    wire    [31:0]  rs2_data;
    wire    [31:0]  mem_r_data;

    instr_mem   instr_mem(
                    .addr   (pc     ),
                    .instr  (instr  )
                );

    cpu         cpu(
                    .clk                (clk        ),
                    .pc                 (pc         ),
                    .instr              (instr      ),
                    .EX_MEM_mem_w_en    (mem_w_en   ),
                    .EX_MEM_alu_out     (alu_out    ),
                    .EX_MEM_rs2_data    (rs2_data   ),
                    .mem_r_data         (mem_r_data ) 
                );

    data_mem    data_mem(
                    .w_data (rs2_data   ), 
                    .w_en   (mem_w_en   ), 
                    .addr   (alu_out    ),
                    .r_data (mem_r_data ),
                    .clk    (clk        )
                );
endmodule
