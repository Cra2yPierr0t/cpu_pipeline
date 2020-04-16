module ALU(
    input   wire            alu_ctrl,
    input   wire    [31:0]  alu_data_1,
    input   wire    [31:0]  alu_data_2,
    output  wire    [31:0]  alu_out
);

    function [31:0] alu_exec(
        input           alu_ctrl,
        input   [31:0]  alu_data_1,
        input   [31:0]  alu_data_2,
        output  [31:0]  alu_out
    );
        begin
            case(alu_ctrl)
            endcase
        end
    endfunction
endmodule
