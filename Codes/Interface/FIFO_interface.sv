interface FIFO_interface (clk);
import shared_pkg::*;
    input bit clk;

    reg [FIFO_WIDTH-1:0] data_in;
    reg rst_n, wr_en, rd_en;

    reg [FIFO_WIDTH-1:0] data_out;
    reg wr_ack, overflow;
    reg full, empty, almostfull, almostempty, underflow;

    reg [FIFO_WIDTH-1:0] data_out_ref;
    reg wr_ack_ref, overflow_ref;
    reg full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

    modport DUT (
        input clk,
        input data_in, rst_n, wr_en, rd_en,

        output data_out,
        output wr_ack, overflow,
        output full, empty, almostfull, almostempty, underflow
    );

    modport REF (
        input clk,
        input data_in, rst_n, wr_en, rd_en,

        output data_out_ref,
        output wr_ack_ref, overflow_ref,
        output full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref
    );

    modport TEST (
        input clk,

        input data_out,
        input wr_ack, overflow,
        input full, empty, almostfull, almostempty, underflow,

        input data_out_ref,
        input wr_ack_ref, overflow_ref,
        input full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref,

        output data_in, rst_n, wr_en, rd_en
    );

    modport MONITOR (
        input clk,
        input data_in, rst_n, wr_en, rd_en,

        input data_out,
        input wr_ack, overflow,
        input full, empty, almostfull, almostempty, underflow,

        input data_out_ref,
        input wr_ack_ref, overflow_ref,
        input full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref
    );
endinterface //FIRO_interface