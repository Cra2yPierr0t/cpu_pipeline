module computer();
    instr_mem   instr_mem(
                    .addr   (instr_addr ),
                    .instr  (instr      )
                );

    cpu         cpu(
                    .instr              (instr      ),
                    .instr_addr         (instr_addr ),
                    .EX_MEM_mem_w_en    (mem_w_en   ),
                    .EX_MEM_rd_addr     (rd_addr    ),
                    .EX_MEM_alu_out     (alu_out    ),
                    .mem_r_data         (mem_r_data )
                );

    data_mem    data_mem(
                    .w_data (), 
                    .w_en   (mem_w_en   ), 
                    .addr   (alu_out    ),
                    .r_data (mem_r_data ),
                    .clk    ()
                );
endmodule
