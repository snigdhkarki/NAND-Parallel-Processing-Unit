`timescale 1ns/1ps

module multi_core_tb;

    reg clk;
    reg [7:0] sw;
    wire [7:0] led;
    wire [31:0] accumulator_outputs;

    multi_core uut (
        .clk(clk),
        .sw(sw),  
        .led(led), 
        .accumulator_outputs(accumulator_outputs)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("multi_core.vcd");
        $dumpvars(0, multi_core_tb);

        sw = 8'b11011110;
       
        clk = 0;
        
        #300;

        $display("\n*** Final RAM 1 Contents (Data Memory) ***");
        $display("Addr 0: %b", sw[0]);
        $display("Addr 1: %b", sw[1]);
        $display("Addr 2: %b", sw[2]);
        $display("Addr 3: %b", sw[3]);
        $display("Addr 4: %b", sw[4]);
        $display("Addr 5: %b", sw[5]);
        $display("Addr 6: %b", sw[6]);
        $display("Addr 7: %b", sw[7]);
        $display("Addr 32: %b", led[0]);
        $display("Addr 33: %b", led[1]);
        $display("Addr 34: %b", led[2]);
        $display("Addr 32: %b", led[3]);
        $display("Addr 33: %b", led[4]);
        $display("Addr 34: %b", led[5]);
        $display("Addr 32: %b", led[6]);
        $display("Addr 33: %b", led[7]);

        $finish;

    end

endmodule