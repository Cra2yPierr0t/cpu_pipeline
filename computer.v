module computer();
    instr_mem instr_mem(
        .addr(),
        .instr()
    );

    cpu cpu();
endmodule
