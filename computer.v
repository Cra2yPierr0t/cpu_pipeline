module computer();
    instr_mem   instr_mem(
        .addr   (),
        .instr  ()
    );

    cpu         cpu();

    data_mem    data_mem(
        .w_data (),
        .w_en   (),
        .addr   (),
        .r_data (),
        .clk    ()
    );
endmodule
