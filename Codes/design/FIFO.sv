import shared_pkg::*;
module FIFO(FIFO_interface.DUT F_if);
 
localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge F_if.clk or negedge F_if.rst_n) begin
	if (!F_if.rst_n) begin
		wr_ptr <= 0;
		F_if.wr_ack <= 0; // FIX
		F_if.overflow <= 0; // FIX
	end
	else if (F_if.wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= F_if.data_in;
		F_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		F_if.overflow <= 0; // FIX
	end
	else begin 
		F_if.wr_ack <= 0; 
		if (F_if.full && F_if.wr_en)// FIX
			F_if.overflow <= 1;
		else
			F_if.overflow <= 0;
	end
end

always @(posedge F_if.clk or negedge F_if.rst_n) begin
	if (!F_if.rst_n) begin
		rd_ptr <= 0;
		F_if.underflow <= 0;// FIX
		F_if.data_out <= 0;// FIX
	end
	else if (F_if.rd_en && count != 0) begin
		F_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		F_if.underflow <= 0; // FIX
	end
	else begin // FIX
		if (F_if.empty && F_if.rd_en)// FIX
			F_if.underflow <= 1;// FIX
		else // FIX
			F_if.underflow <= 0;// FIX
	end // FIX
end

always @(posedge F_if.clk or negedge F_if.rst_n) begin
	if (!F_if.rst_n) begin
		count <= 0;
	end
	else begin
		if (({F_if.wr_en, F_if.rd_en} == 2'b11) && F_if.full) // FIX
			count <= count - 1; // FIX
		else if (({F_if.wr_en, F_if.rd_en} == 2'b11) && F_if.empty) // FIX
			count <= count + 1; // FIX
		else if	( ({F_if.wr_en, F_if.rd_en} == 2'b10) && !F_if.full) 
			count <= count + 1; 
		else if ( ({F_if.wr_en, F_if.rd_en} == 2'b01) && !F_if.empty) 
			count <= count - 1; 
	end
end

assign F_if.full = (count == FIFO_DEPTH)? 1 : 0; 
assign F_if.empty = (count == 0 && F_if.rst_n)? 1 : 0; // FIX

assign F_if.almostfull = (count == FIFO_DEPTH-1)? 1 : 0; 
assign F_if.almostempty = (count == 1)? 1 : 0; 

`ifdef SIM
// Sequences
sequence same_seq;
    (F_if.rd_en && F_if.wr_en && !F_if.empty && !F_if.full);
endsequence
sequence almE_wr_Nrd; // almostempty and write but NOT read
    (F_if.almostempty && F_if.wr_en && !F_if.rd_en);
endsequence
sequence F_wr; // full and write
    (F_if.full && F_if.wr_en);
endsequence
sequence E_wr; // empty and write
    (F_if.empty && F_if.wr_en);
endsequence
sequence E_rd; // empty and write
    (F_if.empty && F_if.rd_en);
endsequence
sequence NF_wr; // NOT full and write
    (!F_if.full && F_if.wr_en);
endsequence
sequence F_rd; // full and read
    (F_if.full && F_if.rd_en);
endsequence
sequence almE_Nwr_rd; // alostempty and read but NOT write
    (F_if.almostempty && !F_if.wr_en && F_if.rd_en);
endsequence
sequence almF_Nwr_rd; // alostfull and read but NOT write
    (F_if.almostfull && !F_if.wr_en && F_if.rd_en);
endsequence
sequence almF_wr_Nrd; // almostfull and write but NOT read
   	(F_if.wr_en && F_if.almostfull && !F_if.rd_en);
endsequence
sequence w_ptr_seq;
	(F_if.wr_en && count < FIFO_DEPTH);
endsequence
sequence inc_rd_ptr_rslt;
	($past(rd_ptr)+1 == rd_ptr)||($past(rd_ptr)==FIFO_DEPTH-1);
	// ($past(rd_ptr)==FIFO_DEPTH-1) => becouse for questa when ptr.past = 7 then ptr should be zero but questa will treats it as 8 NOT zero
	// when $past(rd_ptr) = 7 then $past(rd_ptr) + 1 = 0 (3-bit)
	// for questa $past(rd_ptr) + 1 = 8
endsequence

// ASSERTION
// Internal  signal assertion
count_inc: assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (F_if.wr_en && !F_if.rd_en && !F_if.full) |=> ($past(count)+1 == count));
count_dec: assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (!F_if.wr_en && F_if.rd_en && !F_if.empty)|=> ($past(count)-1 == count));
count_noChange: assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) same_seq |=> ($past(count) == count));


inc_wr_ptr_assert:  assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n)  w_ptr_seq |=> ($past(wr_ptr)+1 == wr_ptr) || ($past(wr_ptr) == FIFO_DEPTH-1) );
inc_rd_ptr_assert:  assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (F_if.rd_en && count != 0) |=> inc_rd_ptr_rslt );

    
    always_comb begin : rst_n_assert
        if (!F_if.rst_n) begin
            assert_count_rst:  assert final (count == 0);
            assert_wr_ptr_rst: assert final (wr_ptr == 0);
            assert_rd_ptr_rst: assert final (rd_ptr == 0);

            assert_wr_akc_rst:    assert final (F_if.wr_ack == 0);
            assert_overflow_rst:  assert final (F_if.overflow == 0);
            assert_underflow_rst: assert final (F_if.underflow == 0);
            assert_data_out_rst:  assert final (F_if.data_out == 0);


            assert_full_rst:        assert final (F_if.full == 0);
            assert_almostfull_rst:  assert final (F_if.almostfull == 0);
            assert_empty_rst:       assert final (F_if.empty == 0);
            assert_almostempty_rst: assert final (F_if.almostempty == 0);
        end
    end

// Global signal assertion
// full
full_count: 	 assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (count >= FIFO_DEPTH) |->  F_if.full);
full_from_almost:assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) almF_wr_Nrd |=> F_if.full);
full_noChange:	 assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) same_seq    |=> !F_if.full);
full_inactive:	 assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) F_rd 	   |=> !F_if.full);

// wr_ack
ack_active:   assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) NF_wr |=> F_if.wr_ack);
ack_inactive: assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) F_wr  |=> !F_if.wr_ack);

// almostfull
almostfull_count:	 assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (count==FIFO_DEPTH-1) |-> F_if.almostfull);
almostfull_from_full:assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) F_rd  |=> ($fell(F_if.full) && $rose(F_if.almostfull)));
almostfull_noChange: assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) same_seq |=> $past(F_if.almostfull) == F_if.almostfull);
almostfull_inactive:  assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) almF_Nwr_rd |=> !F_if.almostfull );

// overflow
overflow_active:assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) F_wr |=> F_if.overflow);
overflow_wr_in: assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) ($past(F_if.overflow) && !F_if.wr_en) |=> !F_if.overflow);
overflow_Nfull:assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) ($past(F_if.overflow) && !F_if.full)  |=> !F_if.overflow);

// almostempty
almostempty_count:	   assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (count==1) |-> F_if.almostempty );
almostempty_noChange:  assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) same_seq |=> ($past(F_if.almostempty) == F_if.almostempty));
almostempty_from_empty:assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) E_wr |=> ($fell(F_if.empty) && $rose(F_if.almostempty)));
almostempty_inactive:  assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) almE_wr_Nrd |=> !F_if.almostempty );

// empty
empty_count:	  assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (count==ZERO) |-> F_if.empty );
empty_noChaneg:   assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) same_seq |=> ($past(F_if.empty) == F_if.empty) );
empty_from_almost:assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) almE_Nwr_rd |=> F_if.empty);
empty_inactive:   assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) E_wr |=> !F_if.empty);

// underflow
underflow_active:  assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) E_rd |=> F_if.underflow);
underflow_Nempty:assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) ($past(F_if.underflow) && !F_if.empty)  |=> !F_if.underflow);
underflow_Nrd:   assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) ($past(F_if.underflow) && !F_if.rd_en)  |=> !F_if.underflow);

// Coverage
// Internal  signal assertion
count_inc_cover: cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (F_if.wr_en && !F_if.rd_en && !F_if.full) |=> ($past(count)+1 == count));
count_dec_cover: cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (!F_if.wr_en && F_if.rd_en && !F_if.empty)|=> ($past(count)-1 == count));
count_noChange_cover: cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) same_seq |=> ($past(count) == count));


inc_wr_ptr_cover:  cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n)  w_ptr_seq |=> ($past(wr_ptr)+1 == wr_ptr) || ($past(wr_ptr) == FIFO_DEPTH-1) );
inc_rd_ptr_cover:  cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (F_if.rd_en && count != 0) |=> inc_rd_ptr_rslt );

    
    always_comb begin : rst_n_cover
        if (!F_if.rst_n) begin
            cover_count_rst:  cover final (count == 0);
            cover_wr_ptr_rst: cover final (wr_ptr == 0);
            cover_rd_ptr_rst: cover final (rd_ptr == 0);

            cover_wr_akc_rst:    cover final (F_if.wr_ack == 0);
            cover_overflow_rst:  cover final (F_if.overflow == 0);
            cover_underflow_rst: cover final (F_if.underflow == 0);
            cover_data_out_rst:  cover final (F_if.data_out == 0);


            cover_full_rst:        cover final (F_if.full == 0);
            cover_almostfull_rst:  cover final (F_if.almostfull == 0);
            cover_empty_rst:       cover final (F_if.empty == 0);
            cover_almostempty_rst: cover final (F_if.almostempty == 0);
        end
    end

// Global signal cover
// full
full_count_cover: 	 cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (count >= FIFO_DEPTH) |->  F_if.full);
full_from_almost_cover:cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) almF_wr_Nrd |=> F_if.full);
full_noChange_cover:	 cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) same_seq    |=> !F_if.full);
full_inactive_cover:	 cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) F_rd 	   |=> !F_if.full);

// wr_ack
ack_active_cover:   cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) NF_wr |=> F_if.wr_ack);
ack_inactive_cover: cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) F_wr  |=> !F_if.wr_ack);

// almostfull
almostfull_count_cover:	 cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (count==FIFO_DEPTH-1) |-> F_if.almostfull);
almostfull_from_full_cover:cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) F_rd  |=> ($fell(F_if.full) && $rose(F_if.almostfull)));
almostfull_noChange_cover: cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) same_seq |=> $past(F_if.almostfull) == F_if.almostfull);
almostfull_inactive_cover:  cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) almF_Nwr_rd |=> !F_if.almostfull );

// overflow
overflow_active_cover:cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) F_wr |=> F_if.overflow);
overflow_wr_in_cover: cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) ($past(F_if.overflow) && !F_if.wr_en) |=> !F_if.overflow);
overflow_Nfull_cover:cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) ($past(F_if.overflow) && !F_if.full)  |=> !F_if.overflow);

// almostempty
almostempty_count_cover:	   cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (count==1) |-> F_if.almostempty );
almostempty_noChange_cover:  cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) same_seq |=> ($past(F_if.almostempty) == F_if.almostempty));
almostempty_from_empty_cover:cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) E_wr |=> ($fell(F_if.empty) && $rose(F_if.almostempty)));
almostempty_inactive_cover:  cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) almE_wr_Nrd |=> !F_if.almostempty );

// empty
empty_count_cover:	  cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (count==ZERO) |-> F_if.empty );
empty_noChaneg_cover:   cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) same_seq |=> ($past(F_if.empty) == F_if.empty) );
empty_from_almost_cover:cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) almE_Nwr_rd |=> F_if.empty);
empty_inactive_cover:   cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) E_wr |=> !F_if.empty);

// underflow
underflow_active_cover:  cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) E_rd |=> F_if.underflow);
underflow_Nempty_cover:cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) ($past(F_if.underflow) && !F_if.empty)  |=> !F_if.underflow);
underflow_Nrd_cover:   cover property (@(posedge F_if.clk) disable iff(!F_if.rst_n) ($past(F_if.underflow) && !F_if.rd_en)  |=> !F_if.underflow);
`endif
endmodule