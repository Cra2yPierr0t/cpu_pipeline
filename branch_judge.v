module branch_judge(
    input   wire    [31:0]  rs1_data,
    input   wire    [31:0]  rs2_data,
    input   wire    [2:0]   funct3,
    input   wire            branch_detect,
    output  wire            branch_result
        );

    assign  branch_result = branch_detect ? comparator(rs1_data, rs2_data, funct3) : 0;

    function comparator(
        input [31:0] rs1_data,
        input [31:0] rs2_data,
        input [2:0]  funct3
    );
        begin
            case(funct3)
                3'b000: comparator = rs1_data == rs2_data;  //beq
                3'b001: comparator = rs1_data != rs2_data;  //neq 
                3'b100: comparator = rs1_data <  rs2_data;  //blt
                3'b101: comparator = rs1_data >= rs2_data;  //bge
                3'b110: comparator = $signed(rs1_data) <  $signed(rs2_data);  //bltu
                3'b111: comparator = $signed(rs1_data) >= $signed(rs2_data);  //bgeu
            endcase
        end
    endfunction
endmodule
