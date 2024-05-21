package scoreboard_pkg;
import transaction_pkg::*;
import shared_pkg::*;

class FIFO_scoreboard;
// input
    bit [FIFO_WIDTH-1:0] data_in;
    bit rst_n, wr_en, rd_en;

// output refrence
    bit [FIFO_WIDTH-1:0] data_out_ref;
    bit wr_ack_ref, overflow_ref;
    bit full_ref, empty_ref, almostfull_ref;
    bit almostempty_ref, underflow_ref;

    function void reference_model(
        input bit [FIFO_WIDTH-1:0] data_out_,
        input bit wr_ack_, overflow_, full_, empty_,
        input bit almostfull_, almostempty_, underflow_
    );
        data_out_ref     = data_out_;
        wr_ack_ref       = wr_ack_;
        overflow_ref     = overflow_;
        full_ref         = full_;
        empty_ref        = empty_;
        almostfull_ref   = almostfull_;
        almostempty_ref  = almostempty_;
        underflow_ref    = underflow_;
    endfunction // reference_model()

    function void check_data (input FIFO_transaction F_txn);
        if (data_out_ref != F_txn.data_out) begin
            $error("%t: Error - data_out_ref = %0d, data_out = %0d",$time, data_out_ref, F_txn.data_out);
            inc_correct_counter++;
        end
        display_errors(wr_ack_ref, F_txn.wr_ack, "wr_ack");
        display_errors(full_ref, F_txn.full, "full");
        display_errors(empty_ref, F_txn.empty, "empty");
        display_errors(almostfull_ref, F_txn.almostfull, "almostfull");
        display_errors(almostempty_ref, F_txn.almostempty, "almostempty");
        display_errors(overflow_ref, F_txn.overflow, "overflow");
        display_errors(underflow_ref, F_txn.underflow, "underflow");
        if (inc_correct_counter == 7) begin
            correct_counter++;
            inc_correct_counter = 0;
        end
    endfunction //check_data ()

    function void display_errors (input bit gld, dut, input string x);
        if (gld!=dut) begin
            $error("%s = %0d, %s_ref = %0d", x, dut, x, gld);
            error_counter++;
        end else
            inc_correct_counter++;
    endfunction

    function new();
    endfunction //new()
endclass //FIFO_scoreboard
    
endpackage