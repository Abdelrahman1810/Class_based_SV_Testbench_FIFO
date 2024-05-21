import shared_pkg::*;
// Testbench for refrence
module refrence_tb ();
    logic [FIFO_WIDTH-1:0] data_in;
    logic clk, rst_n, wr_en, rd_en;
    logic [FIFO_WIDTH-1:0] data_out_ref;
    logic wr_ack_ref, overflow_ref;
    logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    FIFO_ref dut(.*);
    int i;
    initial begin
        $readmemh ("fifoo.dat", dut.mem);
        rst_n = 0; #2; rst_n = 1; #1;
        rst_n = 0; #2; rst_n = 1; #1;

        wr_en = 1; rd_en = 0;
        for (i = 0; i<FIFO_DEPTH; i++) begin
            data_in = i+1;
            @(posedge clk);
        end
        data_in = 0;
        repeat(3) @(posedge clk);

        wr_en = 0; rd_en = 1;
        repeat(FIFO_DEPTH) begin
            @(posedge clk);
        end
        repeat(3) @(posedge clk);

        wr_en = 1; rd_en = 0;
        for (i = 0; i<5; i++) begin
            data_in = i+1;
            @(posedge clk);
        end

        wr_en = 1; rd_en = 1;
        for (i = 5; i<25; i++) begin
            data_in = 25-i;
            @(posedge clk);
        end
    $stop;
    end
endmodule