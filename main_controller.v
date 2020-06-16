module main_controller(
    input   wire    [6:0]   opcode,
    output  wire            rs2_imm_sel,    // 0: rs2, 1:imm
    output  wire            reg_w_en,       // 0: disable, 1:enable
    output  wire            mem_w_en,       // 0: disable, 1:enable
    output  wire            mem_alu_sel,    // 0: memd, 1: alud
    output  wire            imm_SI_sel,     // 0: S_imm, 1:I_imm
    output  wire            branch_detect   // 0: other, 1:branch
);

    assign {rs2_imm_sel, reg_w_en, mem_w_en, mem_alu_sel, imm_SI_sel, branch_detect} = decoder(opcode);

    function [5:0] decoder(
        input [6:0] opcode
    );
        begin
            case(opcode)
                7'b0110011: decoder = 6'b010100;  //Rtype
                7'b0010011: decoder = 6'b110110;  //Itype
                7'b0100011: decoder = 6'b101000;  //Store
                7'b0000011: decoder = 6'b110010;  //Load
                7'b1100011: decoder = 6'b000001;  //Btype
                default:    decoder = 6'b000000;
            endcase
        end
    endfunction

endmodule
