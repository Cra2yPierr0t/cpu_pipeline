module ALU(
    input   wire    [3:0]   alu_ctrl,
    input   wire    [31:0]  alu_data_1,
    input   wire    [31:0]  alu_data_2,
    output  wire    [31:0]  alu_out
);

parameter ALU_ADD   = 4'h0;
parameter ALU_SUB   = 4'h1;
parameter ALU_XOR   = 4'h2;
parameter ALU_OR    = 4'h3;
parameter ALU_AND   = 4'h4;
parameter ALU_SLL   = 4'h5;
parameter ALU_SRL   = 4'h6;
parameter ALU_SRA   = 4'h7;
parameter ALU_SLT   = 4'h8;
parameter ALU_SLTU  = 4'h9;


    assign alu_out = alu_exec(alu_ctrl, alu_data_1, alu_data_2);

    function [31:0] alu_exec(
        input   [3:0]   alu_ctrl,
        input   [31:0]  alu_data_1,
        input   [31:0]  alu_data_2 
    );
        begin
            case(alu_ctrl)
                ALU_ADD:    alu_exec = alu_data_1 + alu_data_2;
                ALU_SUB:    alu_exec = alu_data_1 - alu_data_2;
                ALU_XOR:    alu_exec = alu_data_1 ^ alu_data_2;
                ALU_OR:     alu_exec = alu_data_1 | alu_data_2;
                ALU_AND:    alu_exec = alu_data_1 & alu_data_2;
                ALU_SLL:    alu_exec = alu_data_1 << alu_data_2;
                ALU_SRL:    alu_exec = alu_data_1 >> alu_data_2;
                ALU_SRA:    alu_exec = $signed(alu_data_1) >>> $signed(alu_data_2);
                ALU_SLT:    alu_exec = alu_data_1 < alu_data_2;
                ALU_SLTU:   alu_exec = $signed(alu_data_1) < $signed(alu_data_2);
            endcase
        end
    endfunction
endmodule
