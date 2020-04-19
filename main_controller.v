module main_controller(
    input   wire    [6:0]   opcode,
    output  wire            rs2_imm_sel,    // 0: rs2, 1:imm
    output  wire            reg_w_en,       // 0: disable, 1:enable
    output  wire            mem_w_en,       // 0: disable, 1:enable
    output  wire            mem_alu_sel,    // 0: memd, 1: alud
    output  wire            imm_SI_sel      // 0: S_imm, 1:I_imm
);

    assign {rs2_imm_sel, reg_w_en, mem_w_en, mem_alu_sel, imm_SI_sel} = decoder(opcode);

    function [4:0] decoder(
        input [6:0] opcode
    );
        begin
            case(opcode)
                7'b0110011: decoder = 5'b01010;  //Rtype
                7'b0010011: decoder = 5'b11011;  //Itype
                7'b0100011: decoder = 5'b10100;  //Store
                7'b0000011: decoder = 5'b11001;  //Load
                default:    decoder = 5'b00000;
            endcase
        end
    endfunction

endmodule
