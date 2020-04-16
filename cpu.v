module cpu(
    input   wire            clk,
    input   wire    [31:0]  instr,
    output  wire    [31:0]  instr_addr
);
    regfile regfile();
endmodule
