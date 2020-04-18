module instr_mem(
    input   [31:0] addr,
    output  [31:0] instr
);

    reg [31:0] mem[1023:0];

    assign instr = mem[addr >> 2];

    initial begin
        mem[0] = 32'h01400313;
        mem[1] = 32'h01e00393;
        mem[2] = 32'h02800e13;
        mem[3] = 32'h01c30eb3;
        mem[4] = 32'h00000013;
        mem[5] = 32'h00000013;
        mem[6] = 32'h00000013;
        mem[7] = 32'h00000013;
        mem[8] = 32'h00000013;
    end
endmodule
