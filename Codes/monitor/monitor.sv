import shared_pkg::*;
import scoreboard_pkg::*;
import transaction_pkg::*;
import coverage_pkg::*;

module monitor (FIFO_interface.MONITOR F_if);
    FIFO_transaction tr;
    FIFO_scoreboard sb;
    FIFO_coverage cov;

initial begin
    tr = new();
    sb = new();
    cov = new();
    forever begin

        @(negedge F_if.clk) begin
            // input 
            tr.data_in = F_if.data_in;
            tr.rst_n   = F_if.rst_n;
            tr.wr_en   = F_if.wr_en;
            tr.rd_en   = F_if.rd_en;

            // output
            tr.data_out    = F_if.data_out;
            tr.wr_ack      = F_if.wr_ack;
            tr.overflow    = F_if.overflow;
            tr.full        = F_if.full;
            tr.empty       = F_if.empty;
            tr.almostfull  = F_if.almostfull;
            tr.almostempty = F_if.almostempty;
            tr.underflow   = F_if.underflow;
        end
        
        fork
            // Process 1
            begin
                sb.reference_model(
                    F_if.data_out_ref, F_if.wr_ack_ref, F_if.overflow_ref,
                    F_if.full_ref, F_if.empty_ref, F_if.almostfull_ref,
                    F_if.almostempty_ref, F_if.underflow_ref
                );
                sb.check_data(tr);
            end

            // Process 2
            begin
                cov.sample_data(tr);
            end
        join 
        if (test_finished) begin
            $display("");
            $display("************ **************************************** ************");
            $display("************ *************** summary: *************** ************");
            $display("************ **************************************** ************");
            $display("************ **************************************** ************");
            $display("*********** error_counter = %0d, correct_counter = %0d ***********",error_counter, correct_counter);
            $stop;
        end
    end
end

endmodule