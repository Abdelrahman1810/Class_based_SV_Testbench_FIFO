import shared_pkg::*;
import transaction_pkg::*;

module testbench (FIFO_interface.TEST F_if);
FIFO_transaction tr = new();

initial begin
// All constraint
// tr.CONSTRAINT_NAME.constraint_mode(0); => Turn OFF specific constraint
// tr.CONSTRAINT_NAME.constraint_mode(1); => Turn ON specific constraint

// disable all constraint
tr.constraint_mode(0);

RESET_ACTIVE = 10;
// turn on reset constraint in all tb cases
tr.CON_RESET.constraint_mode(1);


// turn ON requirement constraint
tr.CON_W_R_DIST.constraint_mode(1);
$display("%0t: Turn ON CON_W_R_DIST",$time);

tr.CON_DATA_OUT_ONE_BIT.constraint_mode(1); // ON constraint data_in to be only one bit high 
$display("%0t: Turn ON CON_DATA_OUT_ONE_BIT",$time);
    repeat(LOOP2) randomization;
$display("%0t: Turn OFF CON_DATA_OUT_ONE_BIT",$time);
tr.CON_DATA_OUT_ONE_BIT.constraint_mode(0); // OFF constraint data_in to be only one bit high 

tr.CON_DATA_OUT_M_Z.constraint_mode(1); // ON constraint data_in to be MAX or ZERO
$display("%0t: Turn ON CON_DATA_OUT_M_Z ",$time);
    repeat(LOOP1) randomization;
$display("%0t: Turn OFF CON_DATA_OUT_M_Z ",$time);
tr.CON_DATA_OUT_M_Z.constraint_mode(0); // OFF constraint data_in to be MAX or ZERO

$display("%0t: Turn OFF CON_W_R_DIST",$time);
tr.CON_W_R_DIST.constraint_mode(0); // turn OFF requirement constraint

// turn on MY_CON_ONLEY_W constraint => wr_en always active, rd_en always inactive
tr.MY_CON_ONLEY_W.constraint_mode(1);
$display("%0t: Turn ON MY_CON_ONLEY_W",$time);
    repeat(FIFO_DEPTH) randomization;
$display("%0t: Turn OFF MY_CON_ONLEY_W",$time);
tr.MY_CON_ONLEY_W.constraint_mode(0);

// reset
reset;

// turn on MY_CON_ONLEY_W constraint => wr_en always active, rd_en always inactive
tr.MY_CON_ONLEY_W.constraint_mode(1);
$display("%0t: Turn ON MY_CON_ONLEY_W",$time);
    repeat(FIFO_DEPTH * 4) randomization;
$display("%0t: Turn OFF MY_CON_ONLEY_W",$time);
tr.MY_CON_ONLEY_W.constraint_mode(0);

// turn on MY_CON_ONLEY_R constraint => rd_en always active, wr_en always inactive
tr.MY_CON_ONLEY_R.constraint_mode(1);
$display("%0t: Turn ON MY_CON_ONLEY_R",$time);
    repeat(FIFO_DEPTH-1) randomization;
$display("%0t: Turn OFF MY_CON_ONLEY_R",$time);
tr.MY_CON_ONLEY_R.constraint_mode(0);

// turn on MY_CON_BOTH_ACTIVE constraint => rd_en always active, wr_en always active
tr.MY_CON_BOTH_ACTIVE.constraint_mode(1);
$display("%0t: Turn ON MY_CON_BOTH_ACTIVE",$time);
    repeat(LOOP1) randomization;
$display("%0t: Turn OFF MY_CON_BOTH_ACTIVE",$time);
tr.MY_CON_BOTH_ACTIVE.constraint_mode(0);

// turn on MY_CON_OPPSITE constraint => rd_en always invert of wr_en
tr.MY_CON_OPPSITE.constraint_mode(1);
$display("%0t: Turn ON MY_CON_OPPSITE",$time);
    repeat(LOOP1) randomization;
$display("%0t: Turn OFF MY_CON_OPPSITE",$time);
tr.MY_CON_OPPSITE.constraint_mode(0);

// TURN on toggle => wr_en and rd_en toggle every clk cycle
tr.toggle = 1;
$display("%0t: Turn ON Toggle",$time);
repeat(LOOP1) randomization;
$display("%0t: Turn OFF Toggle",$time);
tr.toggle = 0;

// turn on MY_CON_ONLEY_R constraint => rd_en always active, wr_en always inactive
tr.MY_CON_ONLEY_R.constraint_mode(1);
$display("%0t: Turn ON MY_CON_ONLEY_R",$time);
    repeat(FIFO_DEPTH * 5) randomization;
$display("%0t: Turn OFF MY_CON_ONLEY_R",$time);
tr.MY_CON_ONLEY_R.constraint_mode(0);

// turn on MY_CON_ONLEY_W constraint => wr_en always active, rd_en always inactive
tr.MY_CON_ONLEY_W.constraint_mode(1);
$display("%0t: Turn ON MY_CON_ONLEY_W",$time);
    repeat(FIFO_DEPTH - 1) randomization;
$display("%0t: Turn OFF MY_CON_ONLEY_W",$time);
tr.MY_CON_ONLEY_W.constraint_mode(0);

// turn on MY_CON_BOTH_ACTIVE constraint => rd_en always active, wr_en always active
tr.MY_CON_BOTH_ACTIVE.constraint_mode(1);
$display("%0t: Turn ON MY_CON_BOTH_ACTIVE",$time);
    repeat(LOOP1) randomization;
$display("%0t: Turn OFF MY_CON_BOTH_ACTIVE",$time);
tr.MY_CON_BOTH_ACTIVE.constraint_mode(0);

// turn on MY_CON_ONLEY_W constraint => wr_en always active, rd_en always inactive
tr.MY_CON_ONLEY_W.constraint_mode(1);
$display("%0t: Turn ON MY_CON_ONLEY_W",$time);
    repeat(FIFO_DEPTH) randomization;
$display("%0t: Turn OFF MY_CON_ONLEY_W",$time);
tr.MY_CON_ONLEY_W.constraint_mode(0);

// turn on MY_CON_ONLEY_R constraint => rd_en always active, wr_en always inactive
tr.MY_CON_ONLEY_R.constraint_mode(1);
$display("%0t: Turn ON MY_CON_ONLEY_R",$time);
    repeat(FIFO_DEPTH - 1) randomization;
$display("%0t: Turn OFF MY_CON_ONLEY_R",$time);
tr.MY_CON_ONLEY_R.constraint_mode(0);

// turn on MY_CON_BOTH_ACTIVE constraint => rd_en always active, wr_en always active
tr.MY_CON_BOTH_ACTIVE.constraint_mode(1);
$display("%0t: Turn ON MY_CON_BOTH_ACTIVE",$time);
    repeat(LOOP0) randomization;
$display("%0t: Turn OFF MY_CON_BOTH_ACTIVE",$time);
tr.MY_CON_BOTH_ACTIVE.constraint_mode(0);

// reset
reset;

tr.constraint_mode(0);
WR_EN_ON_DIST = 30; // change probablty of wr_en get high
RD_EN_ON_DIST = 70; // change probablty of rd_en get high
tr.CON_W_R_DIST.constraint_mode(1);
$display("%0t: Turn ON CON_W_R_DIST",$time);
    repeat(LOOP2) randomization;
$display("%0t: Turn OFF CON_W_R_DIST",$time);
tr.CON_W_R_DIST.constraint_mode(0);

tr.constraint_mode(0);
// reset
reset;
RESET_ACTIVE = 10; // change probablty of rst_n get active
// turn of rst constraint
tr.CON_RESET.constraint_mode(1);
repeat(LOOP3) randomization;

// Test Finished
test_finished = 1;
@(negedge F_if.clk);
//$stop;
end
task randomization;
        assert(tr.randomize());
        assigned_tr_itf;
        @(negedge F_if.clk);
endtask //
task assigned_tr_itf;
    F_if.data_in = tr.data_in;
    F_if.rst_n   = tr.rst_n;
    F_if.wr_en   = tr.wr_en;
    F_if.rd_en   = tr.rd_en;
endtask //

task reset;
    F_if.rst_n = 0;
    tr.rst_n = F_if.rst_n;
    repeat(3) @(negedge F_if.clk);
    F_if.rst_n = 1;
    tr.rst_n = F_if.rst_n;
endtask //
endmodule