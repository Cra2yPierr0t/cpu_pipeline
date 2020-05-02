#include<iostream>
#include<verilated.h>
#include"verilated_vcd_c.h"
#include"Vcomputer.h"

unsigned int main_time = 0;

int main(int argc, char *argv[]){
    Verilated::commandArgs(argc, argv);

    Vcomputer *computer = new Vcomputer();

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    computer->trace(tfp, 99);
    tfp->open("wave.vcd");

    computer->clk = 0;

    while(!Verilated::gotFinish()){
        if((main_time % 2) == 0)
            computer->clk = !computer->clk;

        computer->eval();
        tfp->dump(main_time);

        if(main_time > 200000)
            break;

        main_time++;
    }

    tfp->close();
    computer->final();
}
