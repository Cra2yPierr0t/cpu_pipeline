module pipeline_interlock(
    input   wire    [6:0]   opcode,
    input   wire    [4:0]   rd_addr,
    input   wire    [4:0]   rs1_addr,
    input   wire    [4:0]   rs2_addr,
    input   wire            clk,
    output  reg             stall = 0
);

    reg         load_flag = 0; 
    reg [4:0]   p_rd_addr;

    always @(posedge clk) begin
        if(opcode == 7'b0000011) begin
            p_rd_addr <= rd_addr;
            load_flag <= 1;
            stall <= 0;
        end else if(load_flag) begin
            if((p_rd_addr == rs1_addr) || (p_rd_addr == rs2_addr)) begin
                stall <= 1;
            end else begin
                stall <= 0;
            end
            load_flag <= 0;
        end else begin
            stall <= 0;
        end
    end
endmodule
