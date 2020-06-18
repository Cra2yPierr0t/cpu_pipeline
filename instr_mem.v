module instr_mem(
    input   [31:0] addr,
    output  [31:0] instr
);

    reg [31:0] mem[1023:0];

    assign instr = mem[addr >> 2];

    initial begin
     	mem[1] = 32'h0ff10113;       //	addi	sp,sp,255
     	mem[2] = 32'h00200313;       //	li	t1,2
     	mem[3] = 32'h00612023;       //	sw	t1,0(sp)
     	mem[4] = 32'hffc10113;       //	addi	sp,sp,-4
     	mem[5] = 32'h00410113;       //	addi	sp,sp,4
     	mem[6] = 32'h00012583;       //	lw	a1,0(sp)
     	mem[7] = 32'h00300313;       //	li	t1,3
     	mem[8] = 32'h00612023;       //	sw	t1,0(sp)
     	mem[9] = 32'hffc10113;       //	addi	sp,sp,-4
     	mem[10] = 32'h00410113;       //	addi	sp,sp,4
     	mem[11] = 32'h00012603;       //	lw	a2,0(sp)
     	mem[12] = 32'h00b12023;       //	sw	a1,0(sp)
     	mem[13] = 32'hffc10113;       //	addi	sp,sp,-4
     	mem[14] = 32'h00c12023;       //	sw	a2,0(sp)
     	mem[15] = 32'hffc10113;       //	addi	sp,sp,-4
     	mem[16] = 32'h00410113;       //	addi	sp,sp,4
     	mem[17] = 32'h00012303;       //	lw	t1,0(sp)
     	mem[18] = 32'h00410113;       //	addi	sp,sp,4
     	mem[19] = 32'h00012383;       //	lw	t2,0(sp)
     	mem[20] = 32'h00730333;       //	add	t1,t1,t2
     	mem[21] = 32'h00612023;       //	sw	t1,0(sp)
     	mem[22] = 32'hffc10113;       //	addi	sp,sp,-4
     	mem[23] = 32'h00410113;       //	addi	sp,sp,4
     	mem[24] = 32'h00012583;       //	lw	a1,0(sp)
     	mem[25] = 32'h00b12023;       //	sw	a1,0(sp)
     	mem[26] = 32'hffc10113;       //	addi	sp,sp,-4
     	mem[27] = 32'h00410113;       //	addi	sp,sp,4
     	mem[28] = 32'h00012503;       //	lw	a0,0(sp)
        mem[29] = 32'b1111100_00000_00000_000_10001_1100011;
    end
endmodule
