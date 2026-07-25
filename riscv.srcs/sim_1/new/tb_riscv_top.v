`timescale 1ns / 1ps

module tb_riscv_top;

    reg clk;
    reg rst;

    riscv_top uut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        #20;
        rst = 0;

        #120;
        $finish;
    end

endmodule