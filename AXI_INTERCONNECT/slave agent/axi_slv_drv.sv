//  driver class for axi slave
   class  s_drv extends uvm_driver#(m_xtn);
      //factory register 
      `uvm_component_utils( s_drv)
      //config class handle
      s_cfg cfg;
      //virtual interface
      virtual axi_slave_interface.SLV_DRV_MP vif;
      //declaring 5 queraays of type transaction class
      m_xtn q1[$],q2[$],q3[$];
      int mem[*];
      //semaphores for parralel thread operations synchronization
      semaphore sem=new();
      semaphore sem1=new();
      semaphore sem2=new(1);//write_data
      semaphore sem3=new(1);//write_addr
      semaphore sem4=new(1);//write_res
      semaphore sem5=new(1);//read_addr
      semaphore sem6=new(1);//read_res
      semaphore sem7=new();
     //extern functions 
      extern function new (string name="s_drv",uvm_component parent);
      extern function void build_phase(uvm_phase phase);
      extern function void connect_phase(uvm_phase phase);
      extern task send_to_dut();
      extern task write_address();
      extern task write_data (m_xtn xtn);
      extern task write_response(m_xtn xtn);
      extern task read_address();
      extern task read_data(m_xtn xtn);
     
      extern task run_phase (uvm_phase phase);

    endclass
    
  //constructor new
      function  s_drv::new (string name="s_drv",uvm_component parent);
        super.new(name,parent);
      endfunction  
 //------------------------ build phase ------------------------
      function void s_drv::build_phase(uvm_phase phase);
        super.build_phase(phase);
             if(!uvm_config_db#(s_cfg)::get(this,"","s_cfg",cfg))
              `uvm_fatal("DRV","get failed in drv")
      endfunction
  //-------------------------connect phase ----------------------
      function void s_drv::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif=cfg.vif;
      endfunction
 //-------------------------send to dut -----------------------
       task s_drv::send_to_dut();
         fork
               begin
                  sem3.get(1);
                     //$display("***************slave write address channel calling ***************************");                      
                     write_address();
                  sem.put(1);
                  sem3.put(1);
               end
               begin
                  sem.get(1);
                  sem2.get(1);
                    // $display("***************slave write data channel calling and poping q1***************************");                      
                     write_data(q1.pop_front());
                  sem1.put(1);
                  sem2.put(1);
               end
               begin
                  sem1.get(1);
                  sem4.get(1);
                    // $display("***************slave write response channel calling and poping q3***************************");                      
                     write_response(q3.pop_front());
                  sem4.put(1);
               end
               begin
                  sem5.get(1);
                     //$display("***************slave read address channel calling ***************************");                      
                     read_address();
                  sem7.put(1);
                  sem5.put(1);
               end
               begin
                  sem7.get(1);
                  sem6.get(1);
                     //$display("***************slave read data channel calling and poping q2 ***************************");                      
                     read_data(q2.pop_front());
                  sem6.put(1);
               end

          join
       endtask


//------------------------- run phase -------------------------
task s_drv::run_phase(uvm_phase phase);
   super.run_phase(phase);

   // Initialize all slave outputs to 0 at time 0 so no 'X' enters the interconnect
   vif.slv_drv_cb.AWREADY <= 1'b0;
   vif.slv_drv_cb.WREADY  <= 1'b0;
   vif.slv_drv_cb.BVALID  <= 1'b0;
   vif.slv_drv_cb.BID     <= '0;
   vif.slv_drv_cb.BRESP   <= '0;
   vif.slv_drv_cb.BUSER   <= '0;
   vif.slv_drv_cb.ARREADY <= 1'b0;
   vif.slv_drv_cb.RVALID  <= 1'b0;
   vif.slv_drv_cb.RID     <= '0;
   vif.slv_drv_cb.RDATA   <= '0;
   vif.slv_drv_cb.RRESP   <= '0;
   vif.slv_drv_cb.RLAST   <= 1'b0;
   vif.slv_drv_cb.RUSER   <= '0;

   @(vif.slv_drv_cb);

   forever begin
      send_to_dut();
   end
endtask

//------------------------------ drive write address channel----------------------------
task s_drv::write_address();
   m_xtn xtn1 = m_xtn::type_id::create("xtn1");

   @(vif.slv_drv_cb);
   vif.slv_drv_cb.AWREADY <= 1'b1;
   //$display("**********slv AWREADY SENDING VALUE =1 AT TIME %0t ****************", $time);

   // Wait synchronously until a rising clock edge where AWVALID is 1'b1
   do begin
      @(vif.slv_drv_cb);
   end while (vif.slv_drv_cb.AWVALID !== 1'b1);

  // $display("****************SLV: Handshake complete! AWVALID=%0d at time=%0t**********************", vif.slv_drv_cb.AWVALID, $time);

   xtn1.awid    = vif.slv_drv_cb.AWID;
   xtn1.awaddr  = vif.slv_drv_cb.AWADDR;
   xtn1.awlen   = vif.slv_drv_cb.AWLEN;
   xtn1.awsize  = vif.slv_drv_cb.AWSIZE;
   xtn1.awburst = vif.slv_drv_cb.AWBURST;
   xtn1.awlock  = vif.slv_drv_cb.AWLOCK;
   xtn1.awcache = vif.slv_drv_cb.AWCACHE;
   xtn1.awprot  = vif.slv_drv_cb.AWPROT;
   xtn1.awqos   = vif.slv_drv_cb.AWQOS;
   xtn1.awuser  = vif.slv_drv_cb.AWUSER;
   xtn1.awvalid = vif.slv_drv_cb.AWVALID;

   q1.push_back(xtn1);
   q3.push_back(xtn1);

   vif.slv_drv_cb.AWREADY <= 1'b0;
   `uvm_info("SLV: write address channels", $sformatf("write address channel driving %s", xtn1.sprint()), UVM_MEDIUM)

   repeat(5) @(vif.slv_drv_cb);
endtask

//---------------------------drive write data channel-----------------------------------
task s_drv::write_data(m_xtn xtn);
   m_xtn xtn2;
   xtn2 = xtn;
   xtn2.write_addr_cal();
   xtn2.wdata = new[xtn2.awlen + 1];
   xtn2.wstrb = new[xtn2.awlen + 1];

   foreach(xtn2.wdata[i]) begin
      @(vif.slv_drv_cb);
      vif.slv_drv_cb.WREADY <= 1'b1;

      do begin
         @(vif.slv_drv_cb);
      end while (vif.slv_drv_cb.WVALID !== 1'b1);

      xtn2.wuser    = vif.slv_drv_cb.WUSER;
      xtn2.wvalid   = vif.slv_drv_cb.WVALID;
      xtn2.wdata[i] = vif.slv_drv_cb.WDATA;
      xtn2.wstrb[i] = vif.slv_drv_cb.WSTRB;

      if(xtn2.wstrb[i] == 4'b1111)
         mem[xtn2.w_addr[i]] = vif.slv_drv_cb.WDATA;
      else if(xtn2.wstrb[i] == 4'b0011)
         mem[xtn2.w_addr[i]] = vif.slv_drv_cb.WDATA[15:0];
      else if(xtn2.wstrb[i] == 4'b0001)
         mem[xtn2.w_addr[i]] = vif.slv_drv_cb.WDATA[7:0];
      else if(xtn2.wstrb[i] == 4'b1110)
         mem[xtn2.w_addr[i]] = vif.slv_drv_cb.WDATA[31:8];
      else if(xtn2.wstrb[i] == 4'b1100)
         mem[xtn2.w_addr[i]] = vif.slv_drv_cb.WDATA[31:16];
      else if(xtn2.wstrb[i] == 4'b1000)
         mem[xtn2.w_addr[i]] = vif.slv_drv_cb.WDATA[31:24];
      else if(xtn2.wstrb[i] == 4'b0100)
         mem[xtn2.w_addr[i]] = vif.slv_drv_cb.WDATA[23:16];
      else if(xtn2.wstrb[i] == 4'b0010)
         mem[xtn2.w_addr[i]] = vif.slv_drv_cb.WDATA[15:8];

      vif.slv_drv_cb.WREADY <= 1'b0;
      `uvm_info("SLV: write data channels", $sformatf("write data channel driving %s", xtn2.sprint()), UVM_MEDIUM)

      repeat(5) @(vif.slv_drv_cb);
   end
endtask

//--------------------------drive write response channel---------------------------------
task s_drv::write_response(m_xtn xtn);
   m_xtn xtn3;
   xtn3 = xtn; // Must use xtn so BID matches the received AWID!

   @(vif.slv_drv_cb);
   vif.slv_drv_cb.BVALID <= 1'b1;
   vif.slv_drv_cb.BID    <= xtn3.awid;
   vif.slv_drv_cb.BUSER  <= xtn3.buser;
   vif.slv_drv_cb.BRESP  <= 2'b00;

   do begin
      @(vif.slv_drv_cb);
   end while (vif.slv_drv_cb.BREADY !== 1'b1);

   vif.slv_drv_cb.BVALID <= 1'b0;
   `uvm_info("SLV: write response channels", $sformatf("write response channel driving %s", xtn3.sprint()), UVM_MEDIUM)

   repeat(5) @(vif.slv_drv_cb);
endtask

//-------------------------drive read address channel-----------------------------------
task s_drv::read_address();
   m_xtn xtn4 = m_xtn::type_id::create("xtn4");

   @(vif.slv_drv_cb);
   vif.slv_drv_cb.ARREADY <= 1'b1;
   //$display("**********slv ARREADY SENDING VALUE =1 AT TIME %0t ****************", $time);

   do begin
      @(vif.slv_drv_cb);
   end while (vif.slv_drv_cb.ARVALID !== 1'b1);

   //$display("****************SLV: Read Address Handshake complete! ARVALID=%0d at time=%0t**********************", vif.slv_drv_cb.ARVALID, $time);

   xtn4.araddr  = vif.slv_drv_cb.ARADDR;
   xtn4.arlen   = vif.slv_drv_cb.ARLEN;
   xtn4.arid    = vif.slv_drv_cb.ARID;
   xtn4.arsize  = vif.slv_drv_cb.ARSIZE;
   xtn4.arburst = vif.slv_drv_cb.ARBURST;
   xtn4.arlock  = vif.slv_drv_cb.ARLOCK;
   xtn4.arcache = vif.slv_drv_cb.ARCACHE;
   xtn4.arprot  = vif.slv_drv_cb.ARPROT;
   xtn4.arqos   = vif.slv_drv_cb.ARQOS;
   xtn4.aruser  = vif.slv_drv_cb.ARUSER;
   xtn4.arvalid = vif.slv_drv_cb.ARVALID;

   q2.push_back(xtn4);
   vif.slv_drv_cb.ARREADY <= 1'b0;
   `uvm_info("SLV: read address channels", $sformatf("read address channel driving %s", xtn4.sprint()), UVM_MEDIUM)

   repeat(5) @(vif.slv_drv_cb);
endtask

//------------------------------drive read data channel------------------------------------
task s_drv::read_data(m_xtn xtn);
   m_xtn xtn5;
   xtn5 = xtn;
   xtn5.read_addr_cal();
   xtn5.rdata = new[xtn5.arlen + 1];

   for(int i = 0; i < (xtn5.arlen + 1); i++) begin
      @(vif.slv_drv_cb);
      vif.slv_drv_cb.RVALID <= 1'b1;
      vif.slv_drv_cb.RID    <= xtn5.arid;
      vif.slv_drv_cb.RUSER  <= xtn5.ruser;
      vif.slv_drv_cb.RDATA  <= $urandom;
      vif.slv_drv_cb.RRESP  <= 2'b00;
      vif.slv_drv_cb.RLAST  <= (i == xtn5.arlen) ? 1'b1 : 1'b0;

      do begin
         @(vif.slv_drv_cb);
      end while (vif.slv_drv_cb.RREADY !== 1'b1);

      vif.slv_drv_cb.RVALID <= 1'b0;
      vif.slv_drv_cb.RLAST  <= 1'b0;
      `uvm_info("SLV: read data channels", $sformatf("read data channel driving %s", xtn5.sprint()), UVM_MEDIUM)

      repeat(5) @(vif.slv_drv_cb);
   end
endtask
      
      
