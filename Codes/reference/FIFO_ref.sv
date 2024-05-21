import shared_pkg::*;
module FIFO_ref(FIFO_interface.REF F_if);
    reg [FIFO_WIDTH-1:0] fifoo_q [$];
    
    // Write
    always @(posedge F_if.clk or negedge F_if.rst_n) begin
        if (!F_if.rst_n) begin
            fifoo_q.delete();
            F_if.wr_ack_ref <= 0;
            F_if.overflow_ref <= 0;
        end
        else if (F_if.wr_en && !F_if.full_ref) begin
            fifoo_q.push_back(F_if.data_in);
            F_if.wr_ack_ref <= 1;
            F_if.overflow_ref <= 0;
        end
        else begin
            F_if.wr_ack_ref <= 0;
            if (F_if.full_ref && F_if.wr_en)
                F_if.overflow_ref <= 1;
            else
                F_if.overflow_ref <= 0;
        end
    end

    // Read
    always @(posedge F_if.clk or negedge F_if.rst_n) begin
        if (!F_if.rst_n) begin
            fifoo_q.delete();
            F_if.underflow_ref <= 0;
            F_if.data_out_ref <= 0;
        end
        else if (F_if.rd_en && !F_if.empty_ref) begin
            F_if.data_out_ref <= fifoo_q.pop_front();
            F_if.underflow_ref <= 0;
        end
        else begin
            if (F_if.empty_ref && F_if.rd_en)
                F_if.underflow_ref <= 1;
            else 
                F_if.underflow_ref <= 0;
        end
    end

    assign F_if.almostfull_ref = (fifoo_q.size() == FIFO_DEPTH-1 && F_if.rst_n)? 1:0;
    assign F_if.full_ref = (fifoo_q.size() >= FIFO_DEPTH && F_if.rst_n)? 1:0;

    assign F_if.empty_ref = (fifoo_q.size() == 0 && F_if.rst_n)? 1:0;
    assign F_if.almostempty_ref = (fifoo_q.size() == 1 && F_if.rst_n)? 1:0;
endmodule