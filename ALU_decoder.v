module ALU_decoder(
    input   wire    [6:0]   opcode,
    input   wire    [2:0]   funct3,
    input   wire    [6:0]   funct7,
    output  wire    [3:0]   alu_ctrl 
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

    assign alu_ctrl = alu_dec(opcode, funct3, funct7);

    function [3:0] alu_dec(
        input   [6:0]   opcode,
        input   [2:0]   funct3,
        input   [6:0]   funct7
    );
        begin
            case(opcode)
                7'b0110011: begin
                    case(funct3)
                        3'h0: begin
                            case(funct7)
                                7'h00: alu_dec = ALU_ADD;
                                7'h20: alu_dec = ALU_SUB;
                            endcase
                        end
                        3'h4: alu_dec = ALU_XOR;
                        3'h6: alu_dec = ALU_OR;
                        3'h7: alu_dec = ALU_AND;
                        3'h1: alu_dec = ALU_SLL;
                        3'h5: begin
                            case(funct7)
                                7'h00: alu_dec = ALU_SRL;
                                7'h20: alu_dec = ALU_SRA;
                            endcase
                        end
                        3'h2: alu_dec = ALU_SLT;
                        3'h3: alu_dec = ALU_SLTU;
                    endcase
                end
                7'b0010011: begin
                    case(funct3)
                        3'h0: alu_dec = ALU_ADD;
                        3'h4: alu_dec = ALU_XOR;
                        3'h6: alu_dec = ALU_OR;
                        3'h7: alu_dec = ALU_AND;
                        3'h1: alu_dec = ALU_SLL;
                        3'h5: begin
                            case(funct7)
                                7'h00: alu_dec = ALU_SRL;
                                7'h20: alu_dec = ALU_SRA;
                            endcase
                        end
                        3'h2: alu_dec = ALU_SLT;
                        3'h3: alu_dec = ALU_SLTU;
                    endcase
                end
            endcase
        end
    endfunction
endmodule
