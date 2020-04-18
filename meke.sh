iverilog -s test_bench test_bench.v computer.v cpu.v ALU_decoder.v ALU.v main_controller.v regfile.v data_mem.v main_decoder.v instr_mem.v
vvp a.out
rm a.out
