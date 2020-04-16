module regfile(
    input [4:0] rd_addr,
    input [4:0] rs1_addr,
    input [4:0] rs2_addr,
    input [31:0] w_data,
    input w_en,
    output [31:0] rs1_data,
    output [31:0] rs2_data,
    input clock);

    reg [31:0] register[0:31];

    assign rs1_data = register[rs1_addr];
    assign rs2_data = register[rs2_addr];

    initial begin
        register[0] = 32'h0000_0000;
    end

    always @(posedge clock) begin
        if(w_en == 1 && rd_addr != 32'h0000_0000) begin
            register[rd_addr] <= w_data;
        end else begin
            register[rd_addr] <= register[rd_addr];
        end
    end
endmodule
