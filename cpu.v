module cpu(
    input   wire            clk,
    input   wire    [31:0]  instr,
    output  wire    [31:0]  instr_addr
);

    reg [31:0] IF_ID_instr;

    main_decoder    main_decoder();
    ALU_decoder     ALU_decoder();
    ALU             ALU();
    regfile         regfile();

    always @(posedge clk) begin
        IF_ID_instr <= instr;
    end
endmodule
