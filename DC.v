module DC(clk_dc, instruction, sr_data_0, tr_data_0, sr_addr, tr_addr, dr_addr, sr_data_1, tr_data_1, imm, op_code);
    input clk_dc;
    input [15:0] instruction;
    input [15:0] sr_data_0, tr_data_0;
    output [15:0] sr_data_1, tr_data_1;
    output [2:0] sr_addr, tr_addr, dr_addr;
    output [3:0] op_code;
    output [15:0] imm;

    wire [15:0] sr_data_0, tr_data_0;
    reg [15:0] sr_data_1, tr_data_1;

    assign dr_addr = instruction[6:4];
    assign sr_addr = instruction[9:7];

    always @(posedge clk_dc) begin
        tr_addr = instruction[12:10];
        op_code = instruction[3:0];
        sr_data_1 = sr_data_0;
        tr_data_1 = tr_data_0;
        imm = { instruction[15] ? 13'b1111111111111 : 13'b0000000000000 , instruction[15:13] };
    end
endmodule
