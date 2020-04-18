module main_controller(
    input   wire    [6:0]   opcode,
    output  wire            rs2_imm_sel,    // 0: rs2, 1:imm
    output  wire            reg_w_en,       // 0: disable, 1:enable
    output  wire            mem_w_en,       // 0: disable, 1:enable
    output  wire            mem_alu_sel     // 0: memd, 1: alud
);

    assign {rs2_imm_sel, reg_w_en, mem_w_en, mem_alu_sel} = decoder(opcode);

    function [3:0] decoder(
        input [6:0] opcode
    );
        begin
            case(opcode)
                7'b0110011: decoder <= 4'b0101;
                7'b0010011: decoder <= 4'b1101;
                7'b0100011: decoder <= 4'b1100;
                7'b0000011: decoder <= 4'b1010;
                default:    decoder <= 4'b0000;
            endcase
        end
    endfunction

endmodule
