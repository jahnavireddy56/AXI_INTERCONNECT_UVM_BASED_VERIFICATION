	  
// Scoreboard class for AXI master/slave verification
class sb extends uvm_scoreboard;
  // Factory registration
  `uvm_component_utils(sb)

  // UVM analysis FIFOs for master, slave, and reset agents
  uvm_tlm_analysis_fifo#(m_xtn)   fifo_mstr[];
  uvm_tlm_analysis_fifo#(m_xtn)   fifo_slv[];
  uvm_tlm_analysis_fifo#(rst_xtn) fifo_rst[];

  // Associative arrays of queues to store pending master transactions, indexed by ID
  m_xtn m_write_pending[int][$]; // Key: awid, Value: Queue of write transactions
  m_xtn m_read_pending[int][$];  // Key: arid, Value: Queue of read transactions

  // Handles for Master, Slave, and Reset Coverage Data
  m_xtn   master_cov_data0;
  m_xtn   slave_cov_data0;
  m_xtn   master_cov_data1;
  m_xtn   slave_cov_data1;
  m_xtn   slave_cov_data2;
  rst_xtn rst_cov_data;

  int data_verified_count;
  bit pass = 1;

  //--------------------------------------MASTER COVERGROUPS-------------------------------------------//
  // Covergroup for Master 0
  covergroup master_covgrp0;
    option.per_instance = 0;

    RESET: coverpoint rst_cov_data.reset {bins rst = {0, 1};}

    AW_ID: coverpoint master_cov_data0.awid {
      bins first_id  = {[1:51]};
      bins second_id = {[52:103]};
      bins third_id  = {[104:154]};
      bins fourth_id = {[155:205]};
      bins fifth_id  = {[206:255]};
    }

    AW_ADDR: coverpoint master_cov_data0.awaddr {
      bins first_slave  = {[32'h4000_0000:32'h4000_0fff]};
      bins second_slave = {[32'h4000_1000:32'h4000_1fff]};
      bins third_slave  = {[32'h4000_2000:32'h4000_2fff]};
    }

    AW_LENGTH: coverpoint master_cov_data0.awlen {
      bins fixed_type_awlen1 = {[1:51]}    iff (master_cov_data0.awburst == 2'b00);
      bins fixed_type_awlen2 = {[52:103]}  iff (master_cov_data0.awburst == 2'b00);
      bins fixed_type_awlen3 = {[104:154]} iff (master_cov_data0.awburst == 2'b00);
      bins fixed_type_awlen4 = {[155:205]} iff (master_cov_data0.awburst == 2'b00);
      bins fixed_type_awlen5 = {[206:255]} iff (master_cov_data0.awburst == 2'b00);

      bins incrm_type_awlen1 = {[1:51]}    iff (master_cov_data0.awburst == 2'b01);
      bins incrm_type_awlen2 = {[52:103]}  iff (master_cov_data0.awburst == 2'b01);
      bins incrm_type_awlen3 = {[104:154]} iff (master_cov_data0.awburst == 2'b01);
      bins incrm_type_awlen4 = {[155:205]} iff (master_cov_data0.awburst == 2'b01);
      bins incrm_type_awlen5 = {[206:255]} iff (master_cov_data0.awburst == 2'b01);

      bins wrap_type_awlen1  = {1, 3}      iff (master_cov_data0.awburst == 2'b10);
      bins wrap_type_awlen2  = {7, 15}     iff (master_cov_data0.awburst == 2'b10);
      bins wrap_type_awlen3  = {31, 63}    iff (master_cov_data0.awburst == 2'b10);
      bins wrap_type_awlen4  = {127, 255}  iff (master_cov_data0.awburst == 2'b10);
    }

    AW_BURST_SIZE: coverpoint master_cov_data0.awsize {bins W_B_SIZE[] = {0, 1, 2};}

    AW_BURST_TYPE: coverpoint master_cov_data0.awburst {
      bins fixed_type = {0};
      bins incrm_type = {1};
      bins wrap_type  = {2};
    }

    AW_VALID: coverpoint master_cov_data0.awvalid {bins awvalid = {0, 1};}
    AW_READY: coverpoint master_cov_data0.awready {bins awready = {0, 1};}
    W_LAST:   coverpoint master_cov_data0.wlast   {bins wlast   = {0, 1};}
    W_VALID:  coverpoint master_cov_data0.wvalid  {bins wvalid  = {0, 1};}
    W_READY:  coverpoint master_cov_data0.wready  {bins wready  = {0, 1};}

    B_ID: coverpoint master_cov_data0.bid {
      bins first_id  = {[1:51]};
      bins second_id = {[52:103]};
      bins third_id  = {[104:154]};
      bins fourth_id = {[155:205]};
      bins fifth_id  = {[206:255]};
    }

    WRITE_RESP: coverpoint master_cov_data0.bresp  {bins W_RESP = {0, 1, 2, 3};}
    B_VALID:    coverpoint master_cov_data0.bvalid {bins bvalid = {0, 1};}
    B_READY:    coverpoint master_cov_data0.bready {bins bready = {0, 1};}

    AR_ID: coverpoint master_cov_data0.arid {bins first_id = {[0:255]};}

    AR_ADDR: coverpoint master_cov_data0.araddr {
      bins first_slave  = {[32'h4000_0000:32'h4000_0fff]};
      bins second_slave = {[32'h4000_1000:32'h4000_1fff]};
      bins third_slave  = {[32'h4000_2000:32'h4000_2fff]};
    }

    AR_LENGTH: coverpoint master_cov_data0.arlen {
      bins fixed_type_arlen1 = {[1:51]}    iff (master_cov_data0.arburst == 2'b00);
      bins fixed_type_arlen2 = {[52:103]}  iff (master_cov_data0.arburst == 2'b00);
      bins fixed_type_arlen3 = {[104:154]} iff (master_cov_data0.arburst == 2'b00);
      bins fixed_type_arlen4 = {[155:205]} iff (master_cov_data0.arburst == 2'b00);
      bins fixed_type_arlen5 = {[206:255]} iff (master_cov_data0.arburst == 2'b00);

      bins incrm_type_arlen1 = {[1:51]}    iff (master_cov_data0.arburst == 2'b01);
      bins incrm_type_arlen2 = {[52:103]}  iff (master_cov_data0.arburst == 2'b01);
      bins incrm_type_arlen3 = {[104:154]} iff (master_cov_data0.arburst == 2'b01);
      bins incrm_type_arlen4 = {[155:205]} iff (master_cov_data0.arburst == 2'b01);
      bins incrm_type_arlen5 = {[206:255]} iff (master_cov_data0.arburst == 2'b01);

      bins wrap_type_arlen1  = {1, 3}      iff (master_cov_data0.arburst == 2'b10);
      bins wrap_type_arlen2  = {7, 15}     iff (master_cov_data0.arburst == 2'b10);
      bins wrap_type_arlen3  = {31, 63}    iff (master_cov_data0.arburst == 2'b10);
      bins wrap_type_arlen4  = {127, 255}  iff (master_cov_data0.arburst == 2'b10);
    }

    R_TRANSFER_SIZE: coverpoint master_cov_data0.arsize {
      bins fixed_byte_transfer      = {0} iff (master_cov_data0.arburst == 2'b00);
      bins fixed_half_word_transfer = {1} iff (master_cov_data0.arburst == 2'b00);
      bins fixed_word_transfer      = {2} iff (master_cov_data0.arburst == 2'b00);
      bins incrm_byte_transfer      = {0} iff (master_cov_data0.arburst == 2'b01);
      bins incrm_half_word_transfer = {1} iff (master_cov_data0.arburst == 2'b01);
      bins incrm_word_transfer      = {2} iff (master_cov_data0.arburst == 2'b01);
      bins wrap_byte_transfer       = {0} iff (master_cov_data0.arburst == 2'b10);
      bins wrap_half_word_transfer  = {1} iff (master_cov_data0.arburst == 2'b10);
      bins wrap_word_transfer       = {2} iff (master_cov_data0.arburst == 2'b10);
    }

    AR_BURST_SIZE: coverpoint master_cov_data0.arsize {bins R_B_SIZE = {0, 1, 2};}

    AR_BURST_TYPE: coverpoint master_cov_data0.arburst {
      bins fixed_type = {0};
      bins incrm_type = {1};
      bins wrap_type  = {2};
    }

    ARVALID: coverpoint master_cov_data0.arvalid {bins arvalid    = {0, 1};}
    ARREADY: coverpoint master_cov_data0.arready {bins arready    = {0, 1};}
    R_ID:    coverpoint master_cov_data0.rid     {bins first_id   = {[0:255]};}
    R_LAST:  coverpoint master_cov_data0.rlast   {bins rlast      = {0, 1};}
    R_READY: coverpoint master_cov_data0.rready  {bins rready     = {0, 1};}
    R_VALID: coverpoint master_cov_data0.rvalid  {bins rvalid     = {0, 1};}

    // Read Cross Bins
    ARVALID_ARREADY:       cross ARVALID, ARREADY;
    R_VALID_R_READY:       cross R_READY, R_VALID;
    R_VALID_R_READY_RLAST: cross R_READY, R_VALID, R_LAST;
    R_LEN_X_R_BURST_SIZE:  cross AR_LENGTH, AR_BURST_SIZE;

    // Write Cross Bins
    AW_VALID_X_AWREADY:        cross AW_READY, AW_VALID;
    W_VALID_X_W_READY:         cross W_READY, W_VALID;
    B_VALID_X_B_READY:         cross B_READY, B_VALID;
    W_VALID_X_W_READY_X_W_LAST: cross W_VALID, W_READY, W_LAST;
    W_LEN_X_W_BURST_SIZE:      cross AW_LENGTH, AW_BURST_SIZE;
  endgroup

  covergroup master_dyn_write_covgrp0 with function sample(int i);
    WRITE_DATA: coverpoint master_cov_data0.wdata[i] {
      bins low  = {[32'h0000_0000:32'h4444_4444]};
      bins mid1 = {[32'h4444_4445:32'h8888_8888]};
      bins mid2 = {[32'h8888_8889:32'hcccc_cccc]};
      bins high = {[32'hcccc_cccd:32'hffff_ffff]};
    }

    W_STROBE: coverpoint master_cov_data0.wstrb[i] {bins W_STRB = {1, 2, 3, 4, 8, 12, 14, 15};}
  endgroup

  covergroup master_dyn_read_covgrp0 with function sample(int i);
    READ_DATA: coverpoint master_cov_data0.rdata[i] {
      bins low  = {[32'h0000_0000:32'h4444_4444]};
      bins mid1 = {[32'h4444_4445:32'h8888_8888]};
      bins mid2 = {[32'h8888_8889:32'hcccc_cccc]};
      bins high = {[32'hcccc_cccd:32'hffff_ffff]};
    }

    READ_RESP: coverpoint master_cov_data0.rresp[i] {bins R_RESP = {0, 1, 2, 3};}
  endgroup

  // Covergroup for Master 1
  covergroup master_covgrp1;
    option.per_instance = 0;

    AW_ID: coverpoint master_cov_data1.awid {
      bins first_id  = {[1:51]};
      bins second_id = {[52:103]};
      bins third_id  = {[104:154]};
      bins fourth_id = {[155:205]};
      bins fifth_id  = {[206:255]};
    }

    AW_ADDR: coverpoint master_cov_data1.awaddr {
      bins first_slave  = {[32'h4000_0000:32'h4000_0fff]};
      bins second_slave = {[32'h4000_1000:32'h4000_1fff]};
      bins third_slave  = {[32'h4000_2000:32'h4000_2fff]};
    }

    AW_LENGTH: coverpoint master_cov_data1.awlen {
      bins fixed_type_awlen1 = {[1:51]}    iff (master_cov_data1.awburst == 2'b00);
      bins fixed_type_awlen2 = {[52:103]}  iff (master_cov_data1.awburst == 2'b00);
      bins fixed_type_awlen3 = {[104:154]} iff (master_cov_data1.awburst == 2'b00);
      bins fixed_type_awlen4 = {[155:205]} iff (master_cov_data1.awburst == 2'b00);
      bins fixed_type_awlen5 = {[206:255]} iff (master_cov_data1.awburst == 2'b00);

      bins incrm_type_awlen1 = {[1:51]}    iff (master_cov_data1.awburst == 2'b01);
      bins incrm_type_awlen2 = {[52:103]}  iff (master_cov_data1.awburst == 2'b01);
      bins incrm_type_awlen3 = {[104:154]} iff (master_cov_data1.awburst == 2'b01);
      bins incrm_type_awlen4 = {[155:205]} iff (master_cov_data1.awburst == 2'b01);
      bins incrm_type_awlen5 = {[206:255]} iff (master_cov_data1.awburst == 2'b01);

      bins wrap_type_awlen1  = {1, 3}      iff (master_cov_data1.awburst == 2'b10);
      bins wrap_type_awlen2  = {7, 15}     iff (master_cov_data1.awburst == 2'b10);
      bins wrap_type_awlen3  = {31, 63}    iff (master_cov_data1.awburst == 2'b10);
      bins wrap_type_awlen4  = {127, 255}  iff (master_cov_data1.awburst == 2'b10);
    }

    AW_BURST_SIZE: coverpoint master_cov_data1.awsize {bins W_B_SIZE = {0, 1, 2};}

    AW_BURST_TYPE: coverpoint master_cov_data1.awburst {
      bins fixed_type = {0};
      bins incrm_type = {1};
      bins wrap_type  = {2};
    }

    AW_VALID: coverpoint master_cov_data1.awvalid {bins awvalid = {0, 1};}
    AW_READY: coverpoint master_cov_data1.awready {bins awready = {0, 1};}
    W_LAST:   coverpoint master_cov_data1.wlast   {bins wlast   = {0, 1};}
    W_VALID:  coverpoint master_cov_data1.wvalid  {bins wvalid  = {0, 1};}
    W_READY:  coverpoint master_cov_data1.wready  {bins wready  = {0, 1};}

    B_ID: coverpoint master_cov_data1.bid {
      bins first_id  = {[1:51]};
      bins second_id = {[52:103]};
      bins third_id  = {[104:154]};
      bins fourth_id = {[155:205]};
      bins fifth_id  = {[206:255]};
    }

    WRITE_RESP: coverpoint master_cov_data1.bresp  {bins W_RESP = {0, 1, 2, 3};}
    B_VALID:    coverpoint master_cov_data1.bvalid {bins bvalid = {0, 1};}
    B_READY:    coverpoint master_cov_data1.bready {bins bready = {0, 1};}

    AR_ID: coverpoint master_cov_data1.arid {bins first_id = {[0:255]};}

    AR_ADDR: coverpoint master_cov_data1.araddr {
      bins first_slave  = {[32'h4000_0000:32'h4000_0fff]};
      bins second_slave = {[32'h4000_1000:32'h4000_1fff]};
      bins third_slave  = {[32'h4000_2000:32'h4000_2fff]};
    }

    AR_LENGTH: coverpoint master_cov_data1.arlen {
      bins fixed_type_arlen1 = {[1:51]}    iff (master_cov_data1.arburst == 2'b00);
      bins fixed_type_arlen2 = {[52:103]}  iff (master_cov_data1.arburst == 2'b00);
      bins fixed_type_arlen3 = {[104:154]} iff (master_cov_data1.arburst == 2'b00);
      bins fixed_type_arlen4 = {[155:205]} iff (master_cov_data1.arburst == 2'b00);
      bins fixed_type_arlen5 = {[206:255]} iff (master_cov_data1.arburst == 2'b00);

      bins incrm_type_arlen1 = {[1:51]}    iff (master_cov_data1.arburst == 2'b01);
      bins incrm_type_arlen2 = {[52:103]}  iff (master_cov_data1.arburst == 2'b01);
      bins incrm_type_arlen3 = {[104:154]} iff (master_cov_data1.arburst == 2'b01);
      bins incrm_type_arlen4 = {[155:205]} iff (master_cov_data1.arburst == 2'b01);
      bins incrm_type_arlen5 = {[206:255]} iff (master_cov_data1.arburst == 2'b01);

      bins wrap_type_arlen1  = {1, 3}      iff (master_cov_data1.arburst == 2'b10);
      bins wrap_type_arlen2  = {7, 15}     iff (master_cov_data1.arburst == 2'b10);
      bins wrap_type_arlen3  = {31, 63}    iff (master_cov_data1.arburst == 2'b10);
      bins wrap_type_arlen4  = {127, 255}  iff (master_cov_data1.arburst == 2'b10);
    }

    R_TRANSFER_SIZE: coverpoint master_cov_data1.arsize {
      bins fixed_byte_transfer      = {0} iff (master_cov_data1.arburst == 2'b00);
      bins fixed_half_word_transfer = {1} iff (master_cov_data1.arburst == 2'b00);
      bins fixed_word_transfer      = {2} iff (master_cov_data1.arburst == 2'b00);
      bins incrm_byte_transfer      = {0} iff (master_cov_data1.arburst == 2'b01);
      bins incrm_half_word_transfer = {1} iff (master_cov_data1.arburst == 2'b01);
      bins incrm_word_transfer      = {2} iff (master_cov_data1.arburst == 2'b01);
      bins wrap_byte_transfer       = {0} iff (master_cov_data1.arburst == 2'b10);
      bins wrap_half_word_transfer  = {1} iff (master_cov_data1.arburst == 2'b10);
      bins wrap_word_transfer       = {2} iff (master_cov_data1.arburst == 2'b10);
    }

    AR_BURST_SIZE: coverpoint master_cov_data1.arsize {bins R_B_SIZE = {0, 1, 2};}

    AR_BURST_TYPE: coverpoint master_cov_data1.arburst {
      bins fixed_type = {0};
      bins incrm_type = {1};
      bins wrap_type  = {2};
    }

    ARVALID: coverpoint master_cov_data1.arvalid {bins arvalid  = {0, 1};}
    ARREADY: coverpoint master_cov_data1.arready {bins arready  = {0, 1};}
    R_ID:    coverpoint master_cov_data1.rid     {bins first_id = {[0:255]};}
    R_LAST:  coverpoint master_cov_data1.rlast   {bins rlast    = {0, 1};}
    R_READY: coverpoint master_cov_data1.rready  {bins rready   = {0, 1};}
    R_VALID: coverpoint master_cov_data1.rvalid  {bins rvalid   = {0, 1};}

    // Read Cross Bins
    ARREADY_ARVALID:       cross ARVALID, ARREADY;
    R_VALID_R_READY:       cross R_READY, R_VALID;
    R_VALID_R_READY_RLAST: cross R_READY, R_VALID, R_LAST;
    R_LEN_X_R_BURST_SIZE:  cross AR_LENGTH, AR_BURST_SIZE;

    // Write Cross Bins
    AW_VALID_X_AWREADY:         cross AW_READY, AW_VALID;
    W_VALID_X_W_READY:          cross W_READY, W_VALID;
    B_VALID_X_B_READY:          cross B_READY, B_VALID;
    W_VALID_X_W_READY_X_W_LAST: cross W_VALID, W_READY, W_LAST;
    W_LEN_X_W_BURST_SIZE:       cross AW_LENGTH, AW_BURST_SIZE;
  endgroup

  covergroup master_dyn_write_covgrp1 with function sample(int i);
    WRITE_DATA: coverpoint master_cov_data1.wdata[i] {
      bins low  = {[32'h0000_0000:32'h4444_4444]};
      bins mid1 = {[32'h4444_4445:32'h8888_8888]};
      bins mid2 = {[32'h8888_8889:32'hcccc_cccc]};
      bins high = {[32'hcccc_cccd:32'hffff_ffff]};
    }

    W_STROBE: coverpoint master_cov_data1.wstrb[i] {bins W_STRB = {1, 2, 3, 4, 8, 12, 14, 15};}
  endgroup

  covergroup master_dyn_read_covgrp1 with function sample(int i);
    READ_DATA: coverpoint master_cov_data1.rdata[i] {
      bins low  = {[32'h0000_0000:32'h4444_4444]};
      bins mid1 = {[32'h4444_4445:32'h8888_8888]};
      bins mid2 = {[32'h8888_8889:32'hcccc_cccc]};
      bins high = {[32'hcccc_cccd:32'hffff_ffff]};
    }

    READ_RESP: coverpoint master_cov_data1.rresp[i] {bins R_RESP = {0, 1, 2, 3};}
  endgroup

  //--------------------------------------SLAVE COVERGROUPS-------------------------------------------//
  // Covergroup for Slave 0
  covergroup slave_covgrp0;
    option.per_instance = 0;

    AW_ID: coverpoint slave_cov_data0.awid {
      bins first_id  = {[1:51]};
      bins second_id = {[52:103]};
      bins third_id  = {[104:154]};
      bins fourth_id = {[155:205]};
      bins fifth_id  = {[206:255]};
    }

    AW_ADDR: coverpoint slave_cov_data0.awaddr {bins first_slave = {[32'h4000_0000:32'h4000_0fff]};}

    AW_LENGTH: coverpoint slave_cov_data0.awlen {
      bins fixed_type_awlen1 = {[1:51]}    iff (slave_cov_data0.awburst == 2'b00);
      bins fixed_type_awlen2 = {[52:103]}  iff (slave_cov_data0.awburst == 2'b00);
      bins fixed_type_awlen3 = {[104:154]} iff (slave_cov_data0.awburst == 2'b00);
      bins fixed_type_awlen4 = {[155:205]} iff (slave_cov_data0.awburst == 2'b00);
      bins fixed_type_awlen5 = {[206:255]} iff (slave_cov_data0.awburst == 2'b00);
      bins incrm_type_awlen1 = {[1:51]}    iff (slave_cov_data0.awburst == 2'b01);
      bins incrm_type_awlen2 = {[52:103]}  iff (slave_cov_data0.awburst == 2'b01);
      bins incrm_type_awlen3 = {[104:154]} iff (slave_cov_data0.awburst == 2'b01);
      bins incrm_type_awlen4 = {[155:205]} iff (slave_cov_data0.awburst == 2'b01);
      bins incrm_type_awlen5 = {[206:255]} iff (slave_cov_data0.awburst == 2'b01);
      bins wrap_type_awlen1  = {1, 3}      iff (slave_cov_data0.awburst == 2'b10);
      bins wrap_type_awlen2  = {7, 15}     iff (slave_cov_data0.awburst == 2'b10);
      bins wrap_type_awlen3  = {31, 63}    iff (slave_cov_data0.awburst == 2'b10);
      bins wrap_type_awlen4  = {127, 255}  iff (slave_cov_data0.awburst == 2'b10);
    }

    AW_BURST_SIZE: coverpoint slave_cov_data0.awsize {bins W_B_SIZE = {0, 1, 2};}

    AW_BURST_TYPE: coverpoint slave_cov_data0.awburst {
      bins fixed_type = {0};
      bins incrm_type = {1};
      bins wrap_type  = {2};
    }

    AW_VALID: coverpoint slave_cov_data0.awvalid {bins awvalid = {0, 1};}
    AW_READY: coverpoint slave_cov_data0.awready {bins awready = {0, 1};}
    W_LAST:   coverpoint slave_cov_data0.wlast   {bins wlast   = {0, 1};}
    W_VALID:  coverpoint slave_cov_data0.wvalid  {bins wvalid  = {0, 1};}
    W_READY:  coverpoint slave_cov_data0.wready  {bins wready  = {0, 1};}

    B_ID: coverpoint slave_cov_data0.bid {
      bins first_id  = {[1:51]};
      bins second_id = {[52:103]};
      bins third_id  = {[104:154]};
      bins fourth_id = {[155:205]};
      bins fifth_id  = {[206:255]};
    }

    WRITE_RESP: coverpoint slave_cov_data0.bresp  {bins W_RESP = {0, 1, 2, 3};}
    B_VALID:    coverpoint slave_cov_data0.bvalid {bins bvalid = {0, 1};}
    B_READY:    coverpoint slave_cov_data0.bready {bins bready = {0, 1};}

    AR_ID:   coverpoint slave_cov_data0.arid   {bins first_id    = {[0:255]};}
    AR_ADDR: coverpoint slave_cov_data0.araddr {bins first_slave = {[32'h4000_0000:32'h4000_0fff]};}

    AR_LENGTH: coverpoint slave_cov_data0.arlen {
      bins fixed_type_arlen1 = {[1:51]}    iff (slave_cov_data0.arburst == 2'b00);
      bins fixed_type_arlen2 = {[52:103]}  iff (slave_cov_data0.arburst == 2'b00);
      bins fixed_type_arlen3 = {[104:154]} iff (slave_cov_data0.arburst == 2'b00);
      bins fixed_type_arlen4 = {[155:205]} iff (slave_cov_data0.arburst == 2'b00);
      bins fixed_type_arlen5 = {[206:255]} iff (slave_cov_data0.arburst == 2'b00);
      bins incrm_type_arlen1 = {[1:51]}    iff (slave_cov_data0.arburst == 2'b01);
      bins incrm_type_arlen2 = {[52:103]}  iff (slave_cov_data0.arburst == 2'b01);
      bins incrm_type_arlen3 = {[104:154]} iff (slave_cov_data0.arburst == 2'b01);
      bins incrm_type_arlen4 = {[155:205]} iff (slave_cov_data0.arburst == 2'b01);
      bins incrm_type_arlen5 = {[206:255]} iff (slave_cov_data0.arburst == 2'b01);
      bins wrap_type_arlen1  = {1, 3}      iff (slave_cov_data0.arburst == 2'b10);
      bins wrap_type_arlen2  = {7, 15}     iff (slave_cov_data0.arburst == 2'b10);
      bins wrap_type_arlen3  = {31, 63}    iff (slave_cov_data0.arburst == 2'b10);
      bins wrap_type_arlen4  = {127, 255}  iff (slave_cov_data0.arburst == 2'b10);
    }

    R_TRANSFER_SIZE: coverpoint slave_cov_data0.arsize {
      bins fixed_byte_transfer      = {0} iff (slave_cov_data0.arburst == 2'b00);
      bins fixed_half_word_transfer = {1} iff (slave_cov_data0.arburst == 2'b00);
      bins fixed_word_transfer      = {2} iff (slave_cov_data0.arburst == 2'b00);
      bins incrm_byte_transfer      = {0} iff (slave_cov_data0.arburst == 2'b01);
      bins incrm_half_word_transfer = {1} iff (slave_cov_data0.arburst == 2'b01);
      bins incrm_word_transfer      = {2} iff (slave_cov_data0.arburst == 2'b01);
      bins wrap_byte_transfer       = {0} iff (slave_cov_data0.arburst == 2'b10);
      bins wrap_half_word_transfer  = {1} iff (slave_cov_data0.arburst == 2'b10);
      bins wrap_word_transfer       = {2} iff (slave_cov_data0.arburst == 2'b10);
    }

    AR_BURST_SIZE: coverpoint slave_cov_data0.arsize {bins R_B_SIZE = {0, 1, 2};}

    AR_BURST_TYPE: coverpoint slave_cov_data0.arburst {
      bins fixed_type = {0};
      bins incrm_type = {1};
      bins wrap_type  = {2};
    }

    ARVALID: coverpoint slave_cov_data0.arvalid {bins arvalid  = {0, 1};}
    ARREADY: coverpoint slave_cov_data0.arready {bins arready  = {0, 1};}
    R_ID:    coverpoint slave_cov_data0.rid     {bins first_id = {[0:255]};}
    R_LAST:  coverpoint slave_cov_data0.rlast   {bins rlast    = {0, 1};}
    R_READY: coverpoint slave_cov_data0.rready  {bins rready   = {0, 1};}
    R_VALID: coverpoint slave_cov_data0.rvalid  {bins rvalid   = {0, 1};}

    // Read Cross Bins
    ARVALID_ARREADY:       cross ARVALID, ARREADY;
    R_VALID_R_READY:       cross R_READY, R_VALID;
    R_VALID_R_READY_RLAST: cross R_READY, R_VALID, R_LAST;
    R_LEN_X_R_BURST_SIZE:  cross AR_LENGTH, AR_BURST_SIZE;

    // Write Cross Bins
    AW_VALID_X_AWREADY:         cross AW_READY, AW_VALID;
    W_VALID_X_W_READY:          cross W_READY, W_VALID;
    B_VALID_X_B_READY:          cross B_READY, B_VALID;
    W_VALID_X_W_READY_X_W_LAST: cross W_VALID, W_READY, W_LAST;
    W_LEN_X_W_BURST_SIZE:       cross AW_LENGTH, AW_BURST_SIZE;
  endgroup

  covergroup slave_dyn_write_covgrp0 with function sample(int i);
    WRITE_DATA: coverpoint slave_cov_data0.wdata[i] {
      bins low  = {[32'h0000_0000:32'h4444_4444]};
      bins mid1 = {[32'h4444_4445:32'h8888_8888]};
      bins mid2 = {[32'h8888_8889:32'hcccc_cccc]};
      bins high = {[32'hcccc_cccd:32'hffff_ffff]};
    }

    W_STROBE: coverpoint slave_cov_data0.wstrb[i] {bins W_STRB = {1, 2, 3, 4, 8, 12, 14, 15};}
  endgroup

  covergroup slave_dyn_read_covgrp0 with function sample(int i);
    READ_DATA: coverpoint slave_cov_data0.rdata[i] {
      bins low  = {[32'h0000_0000:32'h4444_4444]};
      bins mid1 = {[32'h4444_4445:32'h8888_8888]};
      bins mid2 = {[32'h8888_8889:32'hcccc_cccc]};
      bins high = {[32'hcccc_cccd:32'hffff_ffff]};
    }

    READ_RESP: coverpoint slave_cov_data0.rresp[i] {bins R_RESP = {0, 1, 2, 3};}
  endgroup

  // Covergroup for Slave 1
  covergroup slave_covgrp1;
    option.per_instance = 0;

    AW_ID: coverpoint slave_cov_data1.awid {
      bins first_id  = {[1:51]};
      bins second_id = {[52:103]};
      bins third_id  = {[104:154]};
      bins fourth_id = {[155:205]};
      bins fifth_id  = {[206:255]};
    }

    AW_ADDR: coverpoint slave_cov_data1.awaddr {bins first_slave = {[32'h4000_1000:32'h4000_1fff]};}

    AW_LENGTH: coverpoint slave_cov_data1.awlen {
      bins fixed_type_awlen1 = {[1:51]}    iff (slave_cov_data1.awburst == 2'b00);
      bins fixed_type_awlen2 = {[52:103]}  iff (slave_cov_data1.awburst == 2'b00);
      bins fixed_type_awlen3 = {[104:154]} iff (slave_cov_data1.awburst == 2'b00);
      bins fixed_type_awlen4 = {[155:205]} iff (slave_cov_data1.awburst == 2'b00);
      bins fixed_type_awlen5 = {[206:255]} iff (slave_cov_data1.awburst == 2'b00);
      bins incrm_type_awlen1 = {[1:51]}    iff (slave_cov_data1.awburst == 2'b01);
      bins incrm_type_awlen2 = {[52:103]}  iff (slave_cov_data1.awburst == 2'b01);
      bins incrm_type_awlen3 = {[104:154]} iff (slave_cov_data1.awburst == 2'b01);
      bins incrm_type_awlen4 = {[155:205]} iff (slave_cov_data1.awburst == 2'b01);
      bins incrm_type_awlen5 = {[206:255]} iff (slave_cov_data1.awburst == 2'b01);
      bins wrap_type_awlen1  = {1, 3}      iff (slave_cov_data1.awburst == 2'b10);
      bins wrap_type_awlen2  = {7, 15}     iff (slave_cov_data1.awburst == 2'b10);
      bins wrap_type_awlen3  = {31, 63}    iff (slave_cov_data1.awburst == 2'b10);
      bins wrap_type_awlen4  = {127, 255}  iff (slave_cov_data1.awburst == 2'b10);
    }

    AW_BURST_SIZE: coverpoint slave_cov_data1.awsize {bins W_B_SIZE = {0, 1, 2};}

    AW_BURST_TYPE: coverpoint slave_cov_data1.awburst {
      bins fixed_type = {0};
      bins incrm_type = {1};
      bins wrap_type  = {2};
    }

    AW_VALID: coverpoint slave_cov_data1.awvalid {bins awvalid = {0, 1};}
    AW_READY: coverpoint slave_cov_data1.awready {bins awready = {0, 1};}
    W_LAST:   coverpoint slave_cov_data1.wlast   {bins wlast   = {0, 1};}
    W_VALID:  coverpoint slave_cov_data1.wvalid  {bins wvalid  = {0, 1};}
    W_READY:  coverpoint slave_cov_data1.wready  {bins wready  = {0, 1};}

    B_ID: coverpoint slave_cov_data1.bid {
      bins first_id  = {[1:51]};
      bins second_id = {[52:103]};
      bins third_id  = {[104:154]};
      bins fourth_id = {[155:205]};
      bins fifth_id  = {[206:255]};
    }

    WRITE_RESP: coverpoint slave_cov_data1.bresp  {bins W_RESP = {0, 1, 2, 3};}
    B_VALID:    coverpoint slave_cov_data1.bvalid {bins bvalid = {0, 1};}
    B_READY:    coverpoint slave_cov_data1.bready {bins bready = {0, 1};}

    AR_ID:   coverpoint slave_cov_data1.arid   {bins first_id    = {[0:255]};}
    AR_ADDR: coverpoint slave_cov_data1.araddr {bins first_slave = {[32'h4000_1000:32'h4000_1fff]};}

    AR_LENGTH: coverpoint slave_cov_data1.arlen {
      bins fixed_type_arlen1 = {[1:51]}    iff (slave_cov_data1.arburst == 2'b00);
      bins fixed_type_arlen2 = {[52:103]}  iff (slave_cov_data1.arburst == 2'b00);
      bins fixed_type_arlen3 = {[104:154]} iff (slave_cov_data1.arburst == 2'b00);
      bins fixed_type_arlen4 = {[155:205]} iff (slave_cov_data1.arburst == 2'b00);
      bins fixed_type_arlen5 = {[206:255]} iff (slave_cov_data1.arburst == 2'b00);
      bins incrm_type_arlen1 = {[1:51]}    iff (slave_cov_data1.arburst == 2'b01);
      bins incrm_type_arlen2 = {[52:103]}  iff (slave_cov_data1.arburst == 2'b01);
      bins incrm_type_arlen3 = {[104:154]} iff (slave_cov_data1.arburst == 2'b01);
      bins incrm_type_arlen4 = {[155:205]} iff (slave_cov_data1.arburst == 2'b01);
      bins incrm_type_arlen5 = {[206:255]} iff (slave_cov_data1.arburst == 2'b01);
      bins wrap_type_arlen1  = {1, 3}      iff (slave_cov_data1.arburst == 2'b10);
      bins wrap_type_arlen2  = {7, 15}     iff (slave_cov_data1.arburst == 2'b10);
      bins wrap_type_arlen3  = {31, 63}    iff (slave_cov_data1.arburst == 2'b10);
      bins wrap_type_arlen4  = {127, 255}  iff (slave_cov_data1.arburst == 2'b10);
    }

    R_TRANSFER_SIZE: coverpoint slave_cov_data1.arsize {
      bins fixed_byte_transfer      = {0} iff (slave_cov_data1.arburst == 2'b00);
      bins fixed_half_word_transfer = {1} iff (slave_cov_data1.arburst == 2'b00);
      bins fixed_word_transfer      = {2} iff (slave_cov_data1.arburst == 2'b00);
      bins incrm_byte_transfer      = {0} iff (slave_cov_data1.arburst == 2'b01);
      bins incrm_half_word_transfer = {1} iff (slave_cov_data1.arburst == 2'b01);
      bins incrm_word_transfer      = {2} iff (slave_cov_data1.arburst == 2'b01);
      bins wrap_byte_transfer       = {0} iff (slave_cov_data1.arburst == 2'b10);
      bins wrap_half_word_transfer  = {1} iff (slave_cov_data1.arburst == 2'b10);
      bins wrap_word_transfer       = {2} iff (slave_cov_data1.arburst == 2'b10);
    }

    AR_BURST_SIZE: coverpoint slave_cov_data1.arsize {bins R_B_SIZE = {0, 1, 2};}

    AR_BURST_TYPE: coverpoint slave_cov_data1.arburst {
      bins fixed_type = {0};
      bins incrm_type = {1};
      bins wrap_type  = {2};
    }

    ARVALID: coverpoint slave_cov_data1.arvalid {bins arvalid  = {0, 1};}
    ARREADY: coverpoint slave_cov_data1.arready {bins arready  = {0, 1};}
    R_ID:    coverpoint slave_cov_data1.rid     {bins first_id = {[0:255]};}
    R_LAST:  coverpoint slave_cov_data1.rlast   {bins rlast    = {0, 1};}
    R_READY: coverpoint slave_cov_data1.rready  {bins rready   = {0, 1};}
    R_VALID: coverpoint slave_cov_data1.rvalid  {bins rvalid   = {0, 1};}

    // Read Cross Bins
    ARVALID_ARREADY:       cross ARVALID, ARREADY;
    R_VALID_R_READY:       cross R_READY, R_VALID;
    R_VALID_R_READY_RLAST: cross R_READY, R_VALID, R_LAST;
    R_LEN_X_R_BURST_SIZE:  cross AR_LENGTH, AR_BURST_SIZE;

    // Write Cross Bins
    AW_VALID_X_AWREADY:         cross AW_READY, AW_VALID;
    W_VALID_X_W_READY:          cross W_READY, W_VALID;
    B_VALID_X_B_READY:          cross B_READY, B_VALID;
    W_VALID_X_W_READY_X_W_LAST: cross W_VALID, W_READY, W_LAST;
    W_LEN_X_W_BURST_SIZE:       cross AW_LENGTH, AW_BURST_SIZE;
  endgroup

  covergroup slave_dyn_write_covgrp1 with function sample(int i);
    WRITE_DATA: coverpoint slave_cov_data1.wdata[i] {
      bins low  = {[32'h0000_0000:32'h4444_4444]};
      bins mid1 = {[32'h4444_4445:32'h8888_8888]};
      bins mid2 = {[32'h8888_8889:32'hcccc_cccc]};
      bins high = {[32'hcccc_cccd:32'hffff_ffff]};
    }

    W_STROBE: coverpoint slave_cov_data1.wstrb[i] {bins W_STRB = {1, 2, 3, 4, 8, 12, 14, 15};}
  endgroup

  covergroup slave_dyn_read_covgrp1 with function sample(int i);
    READ_DATA: coverpoint slave_cov_data1.rdata[i] {
      bins low  = {[32'h0000_0000:32'h4444_4444]};
      bins mid1 = {[32'h4444_4445:32'h8888_8888]};
      bins mid2 = {[32'h8888_8889:32'hcccc_cccc]};
      bins high = {[32'hcccc_cccd:32'hffff_ffff]};
    }

    READ_RESP: coverpoint slave_cov_data1.rresp[i] {bins R_RESP = {0, 1, 2, 3};}
  endgroup

  // Covergroup for Slave 2
  covergroup slave_covgrp2;
    option.per_instance = 0;

    AW_ID: coverpoint slave_cov_data2.awid {
      bins first_id  = {[1:51]};
      bins second_id = {[52:103]};
      bins third_id  = {[104:154]};
      bins fourth_id = {[155:205]};
      bins fifth_id  = {[206:255]};
    }

    AW_ADDR: coverpoint slave_cov_data2.awaddr {bins first_slave = {[32'h4000_2000:32'h4000_2fff]};}

    AW_LENGTH: coverpoint slave_cov_data2.awlen {
      bins fixed_type_awlen1 = {[1:51]}    iff (slave_cov_data2.awburst == 2'b00);
      bins fixed_type_awlen2 = {[52:103]}  iff (slave_cov_data2.awburst == 2'b00);
      bins fixed_type_awlen3 = {[104:154]} iff (slave_cov_data2.awburst == 2'b00);
      bins fixed_type_awlen4 = {[155:205]} iff (slave_cov_data2.awburst == 2'b00);
      bins fixed_type_awlen5 = {[206:255]} iff (slave_cov_data2.awburst == 2'b00);
      bins incrm_type_awlen1 = {[1:51]}    iff (slave_cov_data2.awburst == 2'b01);
      bins incrm_type_awlen2 = {[52:103]}  iff (slave_cov_data2.awburst == 2'b01);
      bins incrm_type_awlen3 = {[104:154]} iff (slave_cov_data2.awburst == 2'b01);
      bins incrm_type_awlen4 = {[155:205]} iff (slave_cov_data2.awburst == 2'b01);
      bins incrm_type_awlen5 = {[206:255]} iff (slave_cov_data2.awburst == 2'b01);
      bins wrap_type_awlen1  = {1, 3}      iff (slave_cov_data2.awburst == 2'b10);
      bins wrap_type_awlen2  = {7, 15}     iff (slave_cov_data2.awburst == 2'b10);
      bins wrap_type_awlen3  = {31, 63}    iff (slave_cov_data2.awburst == 2'b10);
      bins wrap_type_awlen4  = {127, 255}  iff (slave_cov_data2.awburst == 2'b10);
    }

    AW_BURST_SIZE: coverpoint slave_cov_data2.awsize {bins W_B_SIZE = {0, 1, 2};}

    AW_BURST_TYPE: coverpoint slave_cov_data2.awburst {
      bins fixed_type = {0};
      bins incrm_type = {1};
      bins wrap_type  = {2};
    }

    AW_VALID: coverpoint slave_cov_data2.awvalid {bins awvalid = {0, 1};}
    AW_READY: coverpoint slave_cov_data2.awready {bins awready = {0, 1};}
    W_LAST:   coverpoint slave_cov_data2.wlast   {bins wlast   = {0, 1};}
    W_VALID:  coverpoint slave_cov_data2.wvalid  {bins wvalid  = {0, 1};}
    W_READY:  coverpoint slave_cov_data2.wready  {bins wready  = {0, 1};}

    B_ID: coverpoint slave_cov_data2.bid {
      bins first_id  = {[1:51]};
      bins second_id = {[52:103]};
      bins third_id  = {[104:154]};
      bins fourth_id = {[155:205]};
      bins fifth_id  = {[206:255]};
    }

    WRITE_RESP: coverpoint slave_cov_data2.bresp  {bins W_RESP = {0, 1, 2, 3};}
    B_VALID:    coverpoint slave_cov_data2.bvalid {bins bvalid = {0, 1};}
    B_READY:    coverpoint slave_cov_data2.bready {bins bready = {0, 1};}

    AR_ID:   coverpoint slave_cov_data2.arid   {bins first_id    = {[0:255]};}
    AR_ADDR: coverpoint slave_cov_data2.araddr {bins first_slave = {[32'h4000_2000:32'h4000_2fff]};}

    AR_LENGTH: coverpoint slave_cov_data2.arlen {
      bins fixed_type_arlen1 = {[1:51]}    iff (slave_cov_data2.arburst == 2'b00);
      bins fixed_type_arlen2 = {[52:103]}  iff (slave_cov_data2.arburst == 2'b00);
      bins fixed_type_arlen3 = {[104:154]} iff (slave_cov_data2.arburst == 2'b00);
      bins fixed_type_arlen4 = {[155:205]} iff (slave_cov_data2.arburst == 2'b00);
      bins fixed_type_arlen5 = {[206:255]} iff (slave_cov_data2.arburst == 2'b00);
      bins incrm_type_arlen1 = {[1:51]}    iff (slave_cov_data2.arburst == 2'b01);
      bins incrm_type_arlen2 = {[52:103]}  iff (slave_cov_data2.arburst == 2'b01);
      bins incrm_type_arlen3 = {[104:154]} iff (slave_cov_data2.arburst == 2'b01);
      bins incrm_type_arlen4 = {[155:205]} iff (slave_cov_data2.arburst == 2'b01);
      bins incrm_type_arlen5 = {[206:255]} iff (slave_cov_data2.arburst == 2'b01);
      bins wrap_type_arlen1  = {1, 3}      iff (slave_cov_data2.arburst == 2'b10);
      bins wrap_type_arlen2  = {7, 15}     iff (slave_cov_data2.arburst == 2'b10);
      bins wrap_type_arlen3  = {31, 63}    iff (slave_cov_data2.arburst == 2'b10);
      bins wrap_type_arlen4  = {127, 255}  iff (slave_cov_data2.arburst == 2'b10);
    }

    R_TRANSFER_SIZE: coverpoint slave_cov_data2.arsize {
      bins fixed_byte_transfer      = {0} iff (slave_cov_data2.arburst == 2'b00);
      bins fixed_half_word_transfer = {1} iff (slave_cov_data2.arburst == 2'b00);
      bins fixed_word_transfer      = {2} iff (slave_cov_data2.arburst == 2'b00);
      bins incrm_byte_transfer      = {0} iff (slave_cov_data2.arburst == 2'b01);
      bins incrm_half_word_transfer = {1} iff (slave_cov_data2.arburst == 2'b01);
      bins incrm_word_transfer      = {2} iff (slave_cov_data2.arburst == 2'b01);
      bins wrap_byte_transfer       = {0} iff (slave_cov_data2.arburst == 2'b10);
      bins wrap_half_word_transfer  = {1} iff (slave_cov_data2.arburst == 2'b10);
      bins wrap_word_transfer       = {2} iff (slave_cov_data2.arburst == 2'b10);
    }

    AR_BURST_SIZE: coverpoint slave_cov_data2.arsize {bins R_B_SIZE = {0, 1, 2};}

    AR_BURST_TYPE: coverpoint slave_cov_data2.arburst {
      bins fixed_type = {0};
      bins incrm_type = {1};
      bins wrap_type  = {2};
    }

    ARVALID: coverpoint slave_cov_data2.arvalid {bins arvalid  = {0, 1};}
    ARREADY: coverpoint slave_cov_data2.arready {bins arready  = {0, 1};}
    R_ID:    coverpoint slave_cov_data2.rid     {bins first_id = {[0:255]};}
    R_LAST:  coverpoint slave_cov_data2.rlast   {bins rlast    = {0, 1};}
    R_READY: coverpoint slave_cov_data2.rready  {bins rready   = {0, 1};}
    R_VALID: coverpoint slave_cov_data2.rvalid  {bins rvalid   = {0, 1};}

    // Read Cross Bins (Fixed typo: ARAREADY -> ARREADY)
    ARVALID_ARREADY:       cross ARVALID, ARREADY;
    R_VALID_R_READY:       cross R_READY, R_VALID;
    R_VALID_R_READY_RLAST: cross R_READY, R_VALID, R_LAST;
    R_LEN_X_R_BURST_SIZE:  cross AR_LENGTH, AR_BURST_SIZE;

    // Write Cross Bins (Fixed typo: AW_VALID_X_AEREADY -> AW_VALID_X_AWREADY)
    AW_VALID_X_AWREADY:         cross AW_READY, AW_VALID;
    W_VALID_X_W_READY:          cross W_READY, W_VALID;
    B_VALID_X_B_READY:          cross B_READY, B_VALID;
    W_VALID_X_W_READY_X_W_LAST: cross W_VALID, W_READY, W_LAST;
    W_LEN_X_W_BURST_SIZE:       cross AW_LENGTH, AW_BURST_SIZE;
  endgroup

  covergroup slave_dyn_write_covgrp2 with function sample(int i);
    WRITE_DATA: coverpoint slave_cov_data2.wdata[i] {
      bins low  = {[32'h0000_0000:32'h4444_4444]};
      bins mid1 = {[32'h4444_4445:32'h8888_8888]};
      bins mid2 = {[32'h8888_8889:32'hcccc_cccc]};
      bins high = {[32'hcccc_cccd:32'hffff_ffff]};
    }

    W_STROBE: coverpoint slave_cov_data2.wstrb[i] {bins W_STRB = {1, 2, 3, 4, 8, 12, 14, 15};}
  endgroup

  covergroup slave_dyn_read_covgrp2 with function sample(int i);
    READ_DATA: coverpoint slave_cov_data2.rdata[i] {
      bins low  = {[32'h0000_0000:32'h4444_4444]};
      bins mid1 = {[32'h4444_4445:32'h8888_8888]};
      bins mid2 = {[32'h8888_8889:32'hcccc_cccc]};
      bins high = {[32'hcccc_cccd:32'hffff_ffff]};
    }

    READ_RESP: coverpoint slave_cov_data2.rresp[i] {bins R_RESP = {0, 1, 2, 3};}
  endgroup

  // Environment configuration handle
  env_cfg e_cfg;

  // Extern methods
  extern function new(string name = "sb", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function void check_data(m_xtn mast_master_xtn, m_xtn slv_master_xtn);
  extern function void report_phase(uvm_phase phase);

endclass

//--------------- Constructor --------------
function sb::new(string name = "sb", uvm_component parent);
  super.new(name, parent);
  rst_cov_data              = new();
  master_cov_data0          = new();
  slave_cov_data0           = new();
  master_cov_data1          = new();
  slave_cov_data1           = new();
  slave_cov_data2           = new();
  master_covgrp0            = new();
  slave_covgrp0             = new();
  master_covgrp1            = new();
  slave_covgrp1             = new();
  slave_covgrp2             = new();
  master_dyn_write_covgrp0  = new();
  slave_dyn_write_covgrp0   = new();
  master_dyn_write_covgrp1  = new();
  slave_dyn_write_covgrp1   = new();
  slave_dyn_write_covgrp2   = new();
  master_dyn_read_covgrp0   = new();
  slave_dyn_read_covgrp0    = new();
  master_dyn_read_covgrp1   = new();
  slave_dyn_read_covgrp1    = new();
  slave_dyn_read_covgrp2    = new();
endfunction

//--------------- Build Phase --------------
function void sb::build_phase(uvm_phase phase);
  super.build_phase(phase);
  // Get env_cfg from config_db
  if (!uvm_config_db#(env_cfg)::get(this, "", "env_cfg", e_cfg))
    `uvm_fatal("SB", "get env_cfg failed in sb")

  // Allocate dynamic analysis FIFOs based on e_cfg parameters
  fifo_mstr = new[e_cfg.no_of_master];
  fifo_slv  = new[e_cfg.no_of_slave];
  fifo_rst  = new[e_cfg.no_of_rst_agt];

  foreach (fifo_mstr[i]) begin
    fifo_mstr[i] = new($sformatf("fifo_mstr[%0d]", i), this);
  end

  foreach (fifo_slv[i]) begin
    fifo_slv[i] = new($sformatf("fifo_slv[%0d]", i), this);
  end

  foreach (fifo_rst[i]) begin
    fifo_rst[i] = new($sformatf("fifo_rst[%0d]", i), this);
  end
endfunction

//------------------------------ RUN PHASE ----------------------------------
task sb::run_phase(uvm_phase phase);
  fork
    //-------------------------------------------------
    // MASTER TRANSACTION COLLECTORS
    //-------------------------------------------------
    forever begin
      // --- Master 0 Collector ---
      m_xtn mast_data_local;
      fifo_mstr[0].get(mast_data_local);
      `uvm_info("AXI_SB_MAS_0", "Master 0 Txn Received", UVM_LOW)

      if (mast_data_local.awvalid && mast_data_local.awready)
        m_write_pending[mast_data_local.awid].push_back(mast_data_local);

      if (mast_data_local.arvalid && mast_data_local.arready)
        m_read_pending[mast_data_local.arid].push_back(mast_data_local);

      // --- Handle Coverage ---
      master_cov_data0 = mast_data_local;
      master_covgrp0.sample();
      if (mast_data_local.awvalid && mast_data_local.awready)
        foreach (master_cov_data0.wdata[i])
          master_dyn_write_covgrp0.sample(i);

      if (mast_data_local.arvalid && mast_data_local.arready)
        foreach (master_cov_data0.rdata[i])
          master_dyn_read_covgrp0.sample(i);
    end

    forever begin
      // --- Master 1 Collector ---
      m_xtn mast_data_local1;
      fifo_mstr[1].get(mast_data_local1);
      `uvm_info("AXI_SB_MAS_1", "Master 1 Txn Received", UVM_LOW)

      if (mast_data_local1.awvalid && mast_data_local1.awready)
        m_write_pending[mast_data_local1.awid].push_back(mast_data_local1);

      if (mast_data_local1.arvalid && mast_data_local1.arready)
        m_read_pending[mast_data_local1.arid].push_back(mast_data_local1);

      // --- Handle Coverage ---
      master_cov_data1 = mast_data_local1;
      master_covgrp1.sample();
      foreach (master_cov_data1.wdata[i])
        master_dyn_write_covgrp1.sample(i);

      foreach (master_cov_data1.rdata[i])
        master_dyn_read_covgrp1.sample(i);
    end

    //-------------------------------------------------
    // SLAVE TRANSACTION COLLECTORS & COMPARATORS
    //-------------------------------------------------
    forever begin
      // --- Slave 0 Comparator ---
      m_xtn slv_data_local;
      m_xtn mast_data_match;
      int id;

      fifo_slv[0].get(slv_data_local);
      `uvm_info("AXI_SB_SLV_0", "Slave 0 Txn Received", UVM_LOW)

      if (slv_data_local.awvalid && slv_data_local.awready) begin
        id = slv_data_local.awid;
        wait (m_write_pending.exists(id) && m_write_pending[id].size() > 0);
        mast_data_match = m_write_pending[id].pop_front();
      end

      if (slv_data_local.arvalid && slv_data_local.arready) begin
        id = slv_data_local.arid;
        wait (m_read_pending.exists(id) && m_read_pending[id].size() > 0);
        mast_data_match = m_read_pending[id].pop_front();
      end

      if (slv_data_local.awvalid && slv_data_local.awready)
        if (!((slv_data_local.awaddr >= 32'h4000_0000) && (slv_data_local.awaddr <= 32'h4000_0FFF)))
          `uvm_error("SCORE_BOARD-0", "Data from Slave 0: Write Address is out of range")

      if (slv_data_local.arvalid && slv_data_local.arready)
        if (!((slv_data_local.araddr >= 32'h4000_0000) && (slv_data_local.araddr <= 32'h4000_0FFF)))
          `uvm_error("SCORE_BOARD-0", "Data from Slave 0: Read Address is out of range")

      check_data(mast_data_match, slv_data_local);

      // --- Handle Coverage ---
      slave_cov_data0 = slv_data_local;
      slave_covgrp0.sample();
      if (slv_data_local.rvalid && slv_data_local.rready)
        foreach (slave_cov_data0.rdata[i])
          slave_dyn_read_covgrp0.sample(i);

      if (slv_data_local.wvalid && slv_data_local.wready)
        foreach (slave_cov_data0.wdata[i])
          slave_dyn_write_covgrp0.sample(i);
    end

    forever begin
      // --- Slave 1 Comparator ---
      m_xtn slv_data_local1;
      m_xtn mast_data_match1;
      int id;

      fifo_slv[1].get(slv_data_local1);
      `uvm_info("AXI_SB_SLV_1", "Slave 1 Txn Received", UVM_LOW)
      slv_data_local1.print();

      if (slv_data_local1.awvalid && slv_data_local1.awready) begin
        id = slv_data_local1.awid;
        wait (m_write_pending.exists(id) && m_write_pending[id].size() > 0);
        mast_data_match1 = m_write_pending[id].pop_front();
      end

      if (slv_data_local1.arvalid && slv_data_local1.arready) begin
        id = slv_data_local1.arid;
        wait (m_read_pending.exists(id) && m_read_pending[id].size() > 0);
        mast_data_match1 = m_read_pending[id].pop_front();
      end

      if (slv_data_local1.awvalid && slv_data_local1.awready)
        if (!((slv_data_local1.awaddr >= 32'h4000_1000) && (slv_data_local1.awaddr <= 32'h4000_1FFF)))
          `uvm_error("SCORE_BOARD-1", "Data from Slave 1: Write Address is out of range")

      if (slv_data_local1.arvalid && slv_data_local1.arready)
        if (!((slv_data_local1.araddr >= 32'h4000_1000) && (slv_data_local1.araddr <= 32'h4000_1FFF)))
          `uvm_error("SCORE_BOARD-1", "Data from Slave 1: Read Address is out of range")

      check_data(mast_data_match1, slv_data_local1);

      slave_cov_data1 = slv_data_local1;
      slave_covgrp1.sample();
      if (slv_data_local1.rvalid && slv_data_local1.rready)
        foreach (slave_cov_data1.rdata[i])
          slave_dyn_read_covgrp1.sample(i);

      if (slv_data_local1.wvalid && slv_data_local1.wready)
        foreach (slave_cov_data1.wdata[i])
          slave_dyn_write_covgrp1.sample(i);
    end

    forever begin
      // --- Slave 2 Comparator ---
      m_xtn slv_data_local2;
      m_xtn mast_data_match2;
      int id;

      fifo_slv[2].get(slv_data_local2);
      `uvm_info("AXI_SB_SLV_2", "Slave 2 Txn Received", UVM_LOW)
      slv_data_local2.print();

      if (slv_data_local2.awvalid && slv_data_local2.awready) begin
        id = slv_data_local2.awid;
        wait (m_write_pending.exists(id) && m_write_pending[id].size() > 0);
        mast_data_match2 = m_write_pending[id].pop_front();
      end

      if (slv_data_local2.arvalid && slv_data_local2.arready) begin
        id = slv_data_local2.arid;
        wait (m_read_pending.exists(id) && m_read_pending[id].size() > 0);
        mast_data_match2 = m_read_pending[id].pop_front();
      end

      if (slv_data_local2.awvalid && slv_data_local2.awready)
        if (!((slv_data_local2.awaddr >= 32'h4000_2000) && (slv_data_local2.awaddr <= 32'h4000_2FFF)))
          `uvm_error("SCORE_BOARD-2", "Data from Slave 2: Write Address is out of range")

      if (slv_data_local2.arvalid && slv_data_local2.arready)
        if (!((slv_data_local2.araddr >= 32'h4000_2000) && (slv_data_local2.araddr <= 32'h4000_2FFF)))
          `uvm_error("SCORE_BOARD-2", "Data from Slave 2: Read Address is out of range")

      check_data(mast_data_match2, slv_data_local2);

      slave_cov_data2 = slv_data_local2;
      slave_covgrp2.sample();
      if (slv_data_local2.rvalid && slv_data_local2.rready)
        foreach (slave_cov_data2.rdata[i])
          slave_dyn_read_covgrp2.sample(i);

      foreach (slave_cov_data2.wdata[i])
        slave_dyn_write_covgrp2.sample(i);
    end
  join
endtask

//-------------------------------------- CHECK DATA FUNCTION --------------------------------
function void sb::check_data(m_xtn mast_master_xtn, m_xtn slv_master_xtn);
  $display("******************************************** Report from Scoreboard ***************************************************");

  if (mast_master_xtn.awvalid && mast_master_xtn.awready) begin
    if (mast_master_xtn.awaddr == slv_master_xtn.awaddr)
      `uvm_info("AXI_SCORE-BOARD--WRITE_DATA", "Write Address comparison is Successful", UVM_LOW)
    else begin
      `uvm_error("AXI_SCORE-BOARD--WRITE_DATA", "Write Address comparison is Failed")
      $display("master address= %h, slave address = %h", mast_master_xtn.awaddr, slv_master_xtn.awaddr);
      pass = 0;
    end

    if ((mast_master_xtn.awlen == slv_master_xtn.awlen) &&
        (mast_master_xtn.awsize == slv_master_xtn.awsize) &&
        (mast_master_xtn.awburst == slv_master_xtn.awburst))
      `uvm_info("AXI_SCORE-BOARD--WRITE_DATA", "Write Control information comparison is Successful", UVM_LOW)
    else begin
      `uvm_error("AXI_SCORE-BOARD--WRITE_DATA", "Write Control information comparison is Failed")
      pass = 0;
    end
  end

  if (mast_master_xtn.wvalid && mast_master_xtn.wready) begin
    foreach (slv_master_xtn.wdata[i]) begin
      if (mast_master_xtn.wdata[i] == slv_master_xtn.wdata[i])
        `uvm_info("AXI_SCORE-BOARD--WRITE_DATA", "Write Data comparison is Successful", UVM_LOW)
      else begin
        `uvm_error("AXI_SCORE-BOARD--WRITE_DATA", "Write Data comparison is Failed")
        $display("master data= %h, slave data = %h", mast_master_xtn.wdata[i], slv_master_xtn.wdata[i]);
        pass = 0;
      end
    end

    foreach (slv_master_xtn.wstrb[i]) begin
      if (mast_master_xtn.wstrb[i] == slv_master_xtn.wstrb[i])
        `uvm_info("AXI_SCORE-BOARD--WRITE_DATA", "Write Strobe comparison is Successful", UVM_LOW)
      else begin
        `uvm_error("AXI_SCORE-BOARD--WRITE_DATA", "Write Strobe comparison is Failed")
        pass = 0;
      end
    end
  end

  if (mast_master_xtn.bvalid && mast_master_xtn.bready) begin
    if (mast_master_xtn.bresp == slv_master_xtn.bresp)
      `uvm_info("AXI_SCORE-BOARD--WRITE_DATA", "Write Response comparison is Successful", UVM_LOW)
    else begin
      `uvm_error("AXI_SCORE-BOARD--WRITE_DATA", "Write Response comparison is Failed")
      pass = 0;
    end

    if (mast_master_xtn.bid == slv_master_xtn.bid)
      `uvm_info("AXI_SCORE-BOARD--WRITE_DATA", "Write response ID comparison is Successful", UVM_LOW)
    else begin
      `uvm_error("AXI_SCORE-BOARD--WRITE_DATA", "Write response ID comparison is Failed")
      $display("master bid= %h, slave bid = %h", mast_master_xtn.bid, slv_master_xtn.bid);
      pass = 0;
    end

    if (mast_master_xtn.awid == slv_master_xtn.bid)
      `uvm_info("AXI_SCORE-BOARD--WRITE_DATA", "Write response ID with transfer ID comparison is Successful", UVM_LOW)
    else begin
      `uvm_error("AXI_SCORE-BOARD--WRITE_DATA", "Write response ID with transfer ID comparison is Failed")
      $display("master awid= %h, slave bid = %h", mast_master_xtn.awid, slv_master_xtn.bid);
      pass = 0;
    end
  end

  $display("=====================================SB pg 1096======================================");
  if (mast_master_xtn.arvalid && mast_master_xtn.arready) begin
    $display("^^^^^^^^^^^^^^^^^^^^^^ Score Board Read-Transaction Comparison ^^^^^^^^^^^^^^^^^^^^^^^^^^^^");

    if (mast_master_xtn.araddr == slv_master_xtn.araddr)
      `uvm_info("AXI_SCORE-BOARD--READ_DATA", "Read Address comparison is Successful", UVM_LOW)
    else begin
      `uvm_error("AXI_SCORE-BOARD--READ_DATA", "Read Address comparison is Failed")
      pass = 0;
    end

    if ((mast_master_xtn.arlen == slv_master_xtn.arlen) &&
        (mast_master_xtn.arsize == slv_master_xtn.arsize) &&
        (mast_master_xtn.arburst == slv_master_xtn.arburst))
      `uvm_info("AXI_SCORE-BOARD--READ_DATA", "Read Control information comparison is Successful", UVM_LOW)
    else begin
      `uvm_error("AXI_SCORE-BOARD--READ_DATA", "Read Control information comparison is Failed")
      pass = 0;
    end
  end

  if (mast_master_xtn.rvalid && mast_master_xtn.rready) begin
    foreach (slv_master_xtn.rdata[i]) begin
      if (mast_master_xtn.rdata[i] == slv_master_xtn.rdata[i])
        `uvm_info("AXI_SCORE-BOARD--Read_DATA", "Read Data comparison is Successful", UVM_LOW)
      else begin
        `uvm_error("AXI_SCORE-BOARD--Read_DATA", "Read Data comparison is Failed")
        pass = 0;
      end
    end

    foreach (slv_master_xtn.rresp[i]) begin
      if (mast_master_xtn.rresp[i] == slv_master_xtn.rresp[i])
        `uvm_info("AXI_SCORE-BOARD--Read_DATA", "Read Response comparison is Successful", UVM_LOW)
      else begin
        `uvm_error("AXI_SCORE-BOARD--Read_DATA", "Read Response comparison is Failed")
        pass = 0;
      end
    end

    if (mast_master_xtn.rid == slv_master_xtn.rid)
      `uvm_info("AXI_SCORE-BOARD--READ_DATA", "Read response ID comparison is Successful", UVM_LOW)
    else begin
      `uvm_error("AXI_SCORE-BOARD--Read_DATA", "Read response ID comparison is Failed")
      $display("master rid= %h, slave rid = %h", mast_master_xtn.rid, slv_master_xtn.rid);
      pass = 0;
    end

    if (mast_master_xtn.arid == slv_master_xtn.rid)
      `uvm_info("AXI_SCORE-BOARD--READ_DATA", "Read response ID with transfer ID comparison is Successful", UVM_LOW)
    else begin
      `uvm_error("AXI_SCORE-BOARD--Read_DATA", "Read response ID with transfer ID comparison is Failed")
      $display("master arid= %h, slave rid = %h", mast_master_xtn.arid, slv_master_xtn.rid);
      pass = 0;
    end

    $display("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
  end

  data_verified_count++;
  $display("*******************************************************************************************************************");
endfunction

//---------------------------------------------- REPORT PHASE -----------------------------------------------
function void sb::report_phase(uvm_phase phase);
  // Check for any master transactions that were never matched by a slave
  foreach (m_write_pending[i]) begin
    if (m_write_pending[i].size() > 0) begin
      `uvm_error("AXI_SB_REPORT", $sformatf("Found %0d un-matched master WRITE transactions with ID %0h", m_write_pending[i].size(), i))
      pass = 0;
    end
  end

  foreach (m_read_pending[i]) begin
    if (m_read_pending[i].size() > 0) begin
      `uvm_error("AXI_SB_REPORT", $sformatf("Found %0d un-matched master READ transactions with ID %0h", m_read_pending[i].size(), i))
      pass = 0;
    end
  end

  if (pass) begin
    $display("================================================Success=============================================================");
  end else begin
    $display("===============================================================FAIL====================================================");
  end
endfunction
    
	    
	
  

	     


    
  



       

