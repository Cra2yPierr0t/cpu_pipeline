module regfile(
    input   wire [4:0]   rd_addr,
    input   wire [4:0]   rs1_addr,
    input   wire [4:0]   rs2_addr,
    input   wire [31:0]  w_data,
    input   wire         w_en,
    output  wire [31:0]  rs1_data,
    output  wire [31:0]  rs2_data,
    input   wire         clk
);

    reg [31:0] register[0:31];

    assign rs1_data = register[rs1_addr];
    assign rs2_data = register[rs2_addr];

    initial begin
        register[0] = 32'h0000_0000;
    end

    always @(posedge clk) begin
        if(w_en == 1 && rd_addr != 32'h0000_0000) begin
            register[rd_addr] <= w_data;
        end else begin
            register[rd_addr] <= register[rd_addr];
        end
    end
endmodule
