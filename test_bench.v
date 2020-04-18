module test_bench();
    reg clk = 0;

    computer computer(
                .clk(clk)
             );

    always #1 begin
        clk = ~clk;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, computer);
        #1000;
        $finish;
    end
endmodule
