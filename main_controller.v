module main_controller(
    input   wire    [6:0]   opcode,
    output  wire            rs2_imm_sel,    // 0: rs2, 1:imm
    output  wire            reg_w_en        // 0: disable, 1:enable
);

    assign {rs2_imm_sel, reg_w_en} = decoder(opcode);

    function [1:0] decoder(
        input [6:0] opcode
    );
        begin
            case(opcode)
                7'b0110011: decoder <= 2'b01;
                7'b0010011: decoder <= 2'b11;
                default:    decoder <= 2'b00;
            endcase
        end
    endfunction

endmodule
