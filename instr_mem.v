module instr_mem(
    input   [31:0] addr,
    output  [31:0] instr
);

    reg [31:0] mem[1023:0];

    assign instr = mem[addr];
endmodule
