package coverage_pkg;
import transaction_pkg::*;
import shared_pkg::*;
    
class FIFO_coverage;
FIFO_transaction F_cvg_txn = new();        

covergroup CVG;
// rst_n coverage
    rst_cp: coverpoint F_cvg_txn.rst_n{
            bins active = {0};
            bins inactive = {1};
            bins inactive_to_active = (1 => 0);
            bins active_to_inactive = (0 => 1);
    }

// write and read enable signal coverpoint
    wr_en_cp:        coverpoint F_cvg_txn.wr_en{
        bins active = {1};
        bins inactive = {0};
    }
    rd_en_cp:        coverpoint F_cvg_txn.rd_en{
        bins active = {1};
        bins inactive = {0};
    }

// data_out bus coverpoint    
    data_out_cp:     coverpoint F_cvg_txn.data_out{
        bins one_bit_H[] = one_bit_high;
        bins zero = {ZERO};
        bins max = {MAX};
        bins others = default;
    }

// outputs signals coverpoint    
    wr_ack_cp:       coverpoint F_cvg_txn.wr_ack{
        bins active = {1};
        bins inactive = {0};
        bins inactive_to_active = (0 => 1);
        bins active_to_inactive = (1 => 0);
    }
    full_cp:         coverpoint F_cvg_txn.full{
        bins active = {1};
        bins inactive = {0};
        bins active_to_inactive = (1 => 0);
        bins inactive_to_active = (0 => 1);
    }
    empty_cp:        coverpoint F_cvg_txn.empty{
        bins active = {1};
        bins inactive = {0};
        bins active_to_inactive = (1 => 0);
        bins inactive_to_active = (0 => 1);
    }
    almostfull_cp:   coverpoint F_cvg_txn.almostfull{
        bins active = {1};
        bins inactive = {0};
        bins active_to_inactive = (1 => 0);
        bins inactive_to_active = (0 => 1);
    }
    almostempty_cp:  coverpoint F_cvg_txn.almostempty{
        bins active = {1};
        bins inactive = {0};
        bins active_to_inactive = (1 => 0);
        bins inactive_to_active = (0 => 1);
    }
    underflow_cp:    coverpoint F_cvg_txn.underflow{
        bins active = {1};
        bins inactive = {0};
    }
    overflow_cp:     coverpoint F_cvg_txn.overflow{
        bins active = {1};
        bins inactive = {0};
    }

// Cross coverage
// A -> refear to Active
// I -> refear to Inactive

// wr_ack signal 
    // reset
    ack_rst_cross: cross rst_cp, wr_ack_cp {
        bins rst_ack = binsof(rst_cp.active) && binsof(wr_ack_cp.inactive);
        option.cross_auto_bin_max = 0;
    }

    // wr_en and rd_en ** requirement **
    ack_wr_rd_cross: cross wr_ack_cp, wr_en_cp, rd_en_cp;

    // full and wr_en
    // crossing wr_ack with full when wr_ack is active and full is active
    // crossing wr_ack with full when full rose and wr_ack fell
    ack_full_wr_cross: cross wr_ack_cp, wr_en_cp, full_cp{
        bins A_ack_A_wr_I_full = binsof(wr_ack_cp.active)
                                && binsof(wr_en_cp.active)
                                && binsof(full_cp.inactive);
        bins ack_full = binsof(wr_ack_cp.active) && binsof(full_cp.inactive);
        bins A_ack_A_full_trans = binsof(wr_ack_cp.inactive_to_active) && binsof(full_cp.inactive_to_active);
        option.cross_auto_bin_max = 0;
    }

    // empty
    ack_empty_cross: cross empty_cp, wr_ack_cp {
        bins emptyTRANS_ackAC = binsof(wr_ack_cp.active) && binsof(empty_cp.active_to_inactive);
        option.cross_auto_bin_max = 0;
    }

    // almostempty
    ack_almostempty_cross: cross almostempty_cp, wr_ack_cp {
        bins Aack_Ialmostempty = binsof(wr_ack_cp.active) && binsof(almostempty_cp.inactive);
        option.cross_auto_bin_max = 0;
    }

// full signal
    // rst transaction
    rst_full_cross: cross full_cp, rst_cp{
        bins trans_rst_full = binsof(full_cp.active_to_inactive) && binsof(rst_cp.inactive_to_active);
        option.cross_auto_bin_max = 0;
    }
    // wr_en and rd_en ** requirement **
    full_cross: cross full_cp, wr_en_cp, rd_en_cp;

    // almostfull transaction
    // crossing to detect when almostfull trans from active to inactive and full from inactive to active  
    // and oppesite operation  
    almostfull_full_cross: cross almostfull_cp, full_cp{
        bins trans_almostfull_to_full = binsof(almostfull_cp.active_to_inactive) && binsof(full_cp.inactive_to_active);
        bins trans_full_to_almostfull = binsof(almostfull_cp.inactive_to_active) && binsof(full_cp.active_to_inactive);
        option.cross_auto_bin_max = 0;
    }

    // overflow
    // crossing to detect when overflow and full both active 
    full_overflow_cross:   cross overflow_cp, full_cp{
        bins overflow_full = binsof(overflow_cp.active) && binsof(full_cp.active);
        option.cross_auto_bin_max = 0;
    }

// empty signal
    // rst 
    rst_empty_cross: cross empty_cp, rst_cp {
        bins rst_empty = binsof(empty_cp.inactive) && binsof(rst_cp.active);
        option.cross_auto_bin_max = 0;
    }

    // almostempty trans
    // crossing to detect when almostempty trans from active to inactive and empty from inactive to active  
    // and oppesite operation 
    almostempty_empty_cross: cross almostempty_cp, empty_cp{
        bins trans_almostempty_to_empty = binsof(almostempty_cp.active_to_inactive) && binsof(empty_cp.inactive_to_active);
        bins trans_empty_to_almostempty = binsof(almostempty_cp.inactive_to_active) && binsof(empty_cp.active_to_inactive);
        option.cross_auto_bin_max = 0;
    }
    
    // rd_en and wr_en
    empty_cross: cross empty_cp, wr_en_cp, rd_en_cp;

    // underflow
    // crossing to detect when underflow and empty both active  
    empty_underflow_cross: cross underflow_cp, empty_cp{
        bins underflow_empty = binsof(underflow_cp.active) && binsof(empty_cp.active);
        option.cross_auto_bin_max = 0;
    }

// overflow signal
    // rst
    rst_overflow_cross: cross rst_cp, overflow_cp {
        bins rst_ack = binsof(rst_cp.active) && binsof(overflow_cp.inactive);
        option.cross_auto_bin_max = 0;
    }

    // wr_en
    // crossing to detect when overflow and write enabe both active  
    wr_overflow_cross: cross wr_en_cp, rd_en_cp, overflow_cp{
        bins both_high = binsof(wr_en_cp.active) && binsof(overflow_cp.active);
    }

// underflow signal
    // rst
    rst_underflow_cross: cross rst_cp, underflow_cp {
        bins rst_ack = binsof(rst_cp.active) && binsof(underflow_cp.inactive);
        option.cross_auto_bin_max = 0;
    }

    // rd_en
    // crossing to detect when underflow and read enabe both active 
    rd_underflow_cross: cross wr_en_cp, rd_en_cp, underflow_cp{
        bins both_high = binsof(rd_en_cp.active) && binsof(underflow_cp.active);
    }

// almostempty signal
    // rst
    rst_almostempty_cross: cross rst_cp, almostempty_cp{
        bins rst_almostempty = binsof(rst_cp.active) && binsof(almostempty_cp.inactive);
        option.cross_auto_bin_max = 0;
    }

    // rd_en and wr_en
    almostempty_cross:  cross wr_en_cp, rd_en_cp, almostempty_cp{
        bins both_Wr_high = binsof(wr_en_cp.active) && binsof(almostempty_cp.active);
        bins INalmostEmp_Awr = binsof(wr_en_cp.active) && binsof(almostempty_cp.inactive);
        bins both_Re_high = binsof(rd_en_cp.active) && binsof(almostempty_cp.active);
        bins INalmostEmp_Ard = binsof(rd_en_cp.active) && binsof(almostempty_cp.inactive);
    }

// almostfull signal
    // rst
    rst_almostfull_cross: cross rst_cp, almostfull_cp{
        bins rst_almostfull = binsof(rst_cp.active) && binsof(almostfull_cp.inactive);
        option.cross_auto_bin_max = 0;
    }

    // wr_en and rd_en
    almostfull_cross:   cross wr_en_cp, rd_en_cp, almostfull_cp{
        bins both_Wr_high = binsof(wr_en_cp.active) && binsof(almostfull_cp.active);
        bins INalmostfull_Awr = binsof(wr_en_cp.active) && binsof(almostfull_cp.inactive);
        bins both_Re_high = binsof(rd_en_cp.active) && binsof(almostfull_cp.active);
        bins INalmostfull_Ard = binsof(rd_en_cp.active) && binsof(almostfull_cp.inactive);
    }

// data_out bus
    // reset
    rst_data_out_cross: cross rst_cp, data_out_cp {
        bins rst_data = binsof(rst_cp.active) && binsof(data_out_cp.zero);
        option.cross_auto_bin_max = 0;
    }

    // rd_en and wr_en ** requirement **
    data_out_cross:     cross data_out_cp, wr_en_cp, rd_en_cp;

// Crossing onley read and write
    rd_wr_cross:           cross rd_en_cp, wr_en_cp;
endgroup
// methods
    function new();
        CVG = new();
    endfunction //new()

    function void sample_data(FIFO_transaction F_txn);
        F_cvg_txn = F_txn; // shallow copy
        CVG.sample();
    endfunction //sample_data()
endclass //FIFO_coverage
endpackage