package transaction_pkg;
import shared_pkg::*;

class FIFO_transaction;
// input
    rand bit [FIFO_WIDTH-1:0] data_in;
    rand bit rst_n, wr_en, rd_en;
    // bit clk;

// output
    bit [FIFO_WIDTH-1:0] data_out;
    bit wr_ack, overflow;
    bit full, empty, almostfull, almostempty, underflow;

bit toggle;
// Costraint Block
    // requirement constraint
    constraint CON_RESET {
        rst_n dist {1:=100-RESET_ACTIVE, 0:=RESET_ACTIVE};
    }
    constraint CON_W_R_DIST {
        wr_en dist {ACTIVE:=WR_EN_ON_DIST, INACTIVE:=100-WR_EN_ON_DIST};
        rd_en dist {ACTIVE:=RD_EN_ON_DIST, INACTIVE:=100-RD_EN_ON_DIST};
    }

    // constraint to assert onley write with constraint one bit high to data_in
    constraint MY_CON_ONLEY_W {
        wr_en == ACTIVE;
        rd_en == INACTIVE;
    }
    
    // constraint to assert onley read with constraint zero or MAX ro data_in
    constraint MY_CON_ONLEY_R {
        wr_en == INACTIVE;
        rd_en == ACTIVE;
    }

    // constraint to Toggle write and read enable
    constraint MY_CON_OPPSITE {
        wr_en == ~rd_en;
    }

    // constraint to make write and read active at the same time
    constraint MY_CON_BOTH_ACTIVE {
        wr_en == ACTIVE;
        rd_en == ACTIVE;
    }

    constraint CON_DATA_OUT_ONE_BIT{
        data_in inside{one_bit_high};
        unique {data_in};
    }
    constraint CON_DATA_OUT_M_Z{
        ((data_in == ZERO) || (data_in == MAX));
    }

// Mythods
    int wr_old = 0, rd_old = 0;
    function void pre_randomize();
        wr_old = wr_en;
        rd_old = rd_en;
    endfunction

    // I want to assert rst for the first 5 clk cycle
    int first_rst = 0;
    function void post_randomize();
        if (first_rst <= 5) begin
            first_rst++;
            rst_n = 0;
        end
        if (toggle) begin
            wr_en = ~wr_old;
            rd_en = ~rd_old;
        end
    endfunction


    function void assigned_values(
        //  output 
        output bit [FIFO_WIDTH-1:0] data_in,
        output bit rst_n, wr_en, rd_en,

        // input
        input bit [FIFO_WIDTH-1:0] data_out,
        input bit wr_ack, overflow,
        input bit full, empty, almostfull, almostempty, underflow
    );
        // output
        data_in = this.data_in;
        rst_n   = this.rst_n;
        wr_en   = this.wr_en;
        rd_en   = this.rd_en;

        // input
        this.data_out    = data_out;
        this.wr_ack      = wr_ack;
        this.overflow    = overflow;
        this.full        = full;
        this.empty       = empty;
        this.almostfull  = almostfull;
        this.almostempty = almostempty;
        this.underflow   = underflow;
    endfunction

    function new();
    endfunction //new()
endclass //FIFO_transaction
endpackage