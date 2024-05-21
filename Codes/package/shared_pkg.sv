package shared_pkg;
        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;
        parameter ACTIVE = 1;
        parameter INACTIVE = 0;

        int WR_EN_ON_DIST = 70;
        int RD_EN_ON_DIST = 30;
        int RESET_ACTIVE = 20;

        parameter ZERO = 0;
        parameter MAX = (2**FIFO_DEPTH) - 1;
        reg [FIFO_WIDTH-1:0] one_bit_high [16] = '{16'h1, 16'h2, 16'h4, 16'h8, 16'h10, 16'h20, 16'h40, 16'h80,
                                                   16'h100, 16'h200, 16'h400, 16'h800, 16'h1000, 16'h2000, 16'h4000, 16'h8000};
        //bit [FIFO_WIDTH-1:0] one_bit_high [16] = '{16'b0000_0000_0000_0001,
        //                                           16'b0000_0000_0000_0010,
        //                                           16'b0000_0000_0000_0100,
        //                                           16'b0000_0000_0000_1000,
        //                                           16'b0000_0000_0001_0000,
        //                                           16'b0000_0000_0010_0000,
        //                                           16'b0000_0000_0100_0000,
        //                                           16'b0000_0000_1000_0000,
        //                                           16'b0000_0001_0000_0000,
        //                                           16'b0000_0010_0000_0000,
        //                                           16'b0000_0100_0000_0000,
        //                                           16'b0000_1000_0000_0000,
        //                                           16'b0001_0000_0000_0000,
        //                                           16'b0010_0000_0000_0000,
        //                                           16'b0100_0000_0000_0000,
        //                                           16'b1000_0000_0000_0000}
        bit test_finished;
        int error_counter = 0; 
        int correct_counter = 0;
        int inc_correct_counter = 0;

        int LOOP0 = 1_00;
        int LOOP1 = 1_000;
        int LOOP2 = 10_000;
        int LOOP3 = 100_000;
endpackage