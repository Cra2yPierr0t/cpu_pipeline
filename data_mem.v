module data_mem(
    input   wire    [31:0]  w_data,
    input   wire            w_en,
    input   wire    [31:0]  addr,
    input   wire            clk,
    output  wire    [31:0]  r_data
);
    
    reg [31:0]  mem[1023:0];

    assign r_data = mem[addr];
    always @(posedge clk) begin
        if(w_en == 1'b1) begin
            mem[addr >> 2] <= w_data;
        end
    end

endmodule
