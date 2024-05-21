module top ();
    bit clk;
    initial begin
        forever #1 clk = ~clk;
    end

    FIFO_interface F_if(clk);

    FIFO dut(F_if);
    FIFO_ref gld(F_if);
    testbench tb(F_if);
    monitor mon(F_if);
endmodule