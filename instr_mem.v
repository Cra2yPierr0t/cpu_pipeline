module instr_mem(
    input   [31:0] addr,
    output  [31:0] instr
);

    reg [31:0] mem[1023:0];

    assign instr = mem[addr >> 2];

    initial begin
        mem[0] = 32'h01400313;
        mem[1] = 32'h01e00393;
        mem[2] = 32'h00730e33;
        mem[3] = 32'h00002e03;
        mem[4] = 32'h01c02223;
        mem[5] = 32'h00000013;
        mem[6] = 32'h00000013;
        mem[7] = 32'h00000013;
        mem[8] = 32'h00000013;
        mem[9] = 32'h00000013;
        mem[10] = 32'h00000013;
        mem[11] = 32'h00000013;
        mem[12] = 32'h00000013;
    end
endmodule
