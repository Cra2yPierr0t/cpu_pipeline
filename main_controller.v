module main_controller(
    input   wire    [6:0]   opcode,
    output  wire            rs2_imm_sel,    // 0: rs2, 1:imm
    output  wire            reg_w_en,       // 0: disable, 1:enable
    output  wire            mem_w_en        // 0: disable, 1:enable
);

    assign {rs2_imm_sel, reg_w_en, mem_w_en} = decoder(opcode);

    function [2:0] decoder(
        input [6:0] opcode
    );
        begin
            case(opcode)
                7'b0110011: decoder <= 3'b010;
                7'b0010011: decoder <= 3'b110;
                7'b0100011: decoder <= 3'b110;
                7'b0000011: decoder <= 3'b101;
                default:    decoder <= 3'b000;
            endcase
        end
    endfunction

endmodule
