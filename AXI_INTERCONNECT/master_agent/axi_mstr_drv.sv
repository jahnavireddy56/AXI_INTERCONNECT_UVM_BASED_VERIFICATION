//  driver class for axi master
   class  m_drv extends uvm_driver#(m_xtn);
      //factory register 
      `uvm_component_utils( m_drv)
      //config class handle
      m_cfg cfg;
      //virtual interface
      virtual axi_master_interface.MAST_DRV_MP vif;
      //declaring 5 queraays of type transaction class
      m_xtn q1[$],q2[$],q3[$],q4[$],q5[$];
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
      extern function new (string name="m_drv",uvm_component parent);
      extern function void build_phase(uvm_phase phase);
      extern function void connect_phase(uvm_phase phase);
      extern task send_to_dut(m_xtn xtn);
      extern task write_address(m_xtn xtn);
      extern task write_data (m_xtn xtn);
      extern task write_response(m_xtn xtn);
      extern task read_address(m_xtn xtn);
      extern task read_data(m_xtn xtn);
      extern task run_phase (uvm_phase phase);
   endclass
    
  //----------------------- constructor new ----------------------- 
      function  m_drv::new (string name="m_drv",uvm_component parent);
        super.new(name,parent);
      endfunction
  //------------------------ build phase ------------------------
      function void m_drv::build_phase(uvm_phase phase);
        super.build_phase(phase);
             if(!uvm_config_db#(m_cfg)::get(this,"","m_cfg",cfg))
              `uvm_fatal("DRV","get failed in drv")
      endfunction
  //-------------------------connect phase ----------------------
      function void m_drv::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif=cfg.vif;
      endfunction
//------------------------- run phase -------------------------
task m_drv::run_phase(uvm_phase phase);
   super.run_phase(phase);

   // Initialize all master outputs to 0 so idle masters never drive 'X' into the interconnect
   vif.mast_drv_cb.AWVALID <= 1'b0;
   vif.mast_drv_cb.AWID    <= '0;
   vif.mast_drv_cb.AWADDR  <= '0;
   vif.mast_drv_cb.AWLEN   <= '0;
   vif.mast_drv_cb.AWSIZE  <= '0;
   vif.mast_drv_cb.AWBURST <= '0;
   vif.mast_drv_cb.AWLOCK  <= '0;
   vif.mast_drv_cb.AWCACHE <= '0;
   vif.mast_drv_cb.AWPROT  <= '0;
   vif.mast_drv_cb.AWQOS   <= '0;
   vif.mast_drv_cb.AWUSER  <= '0;

   vif.mast_drv_cb.WVALID  <= 1'b0;
   vif.mast_drv_cb.WDATA   <= '0;
   vif.mast_drv_cb.WSTRB   <= '0;
   vif.mast_drv_cb.WLAST   <= 1'b0;
   vif.mast_drv_cb.WUSER   <= '0;

   vif.mast_drv_cb.BREADY  <= 1'b0;

   vif.mast_drv_cb.ARVALID <= 1'b0;
   vif.mast_drv_cb.ARID    <= '0;
   vif.mast_drv_cb.ARADDR  <= '0;
   vif.mast_drv_cb.ARLEN   <= '0;
   vif.mast_drv_cb.ARSIZE  <= '0;
   vif.mast_drv_cb.ARBURST <= '0;
   vif.mast_drv_cb.ARLOCK  <= '0;
   vif.mast_drv_cb.ARCACHE <= '0;
   vif.mast_drv_cb.ARPROT  <= '0;
   vif.mast_drv_cb.ARQOS   <= '0;
   vif.mast_drv_cb.ARUSER  <= '0;

   vif.mast_drv_cb.RREADY  <= 1'b0;

   @(vif.mast_drv_cb);

   forever begin
      //$display("driver getting data from seq");
      seq_item_port.get_next_item(req);
      send_to_dut(req);
      seq_item_port.item_done();
   end
endtask
 //-------------------------send to dut -----------------------
       task m_drv::send_to_dut(m_xtn xtn);
          q1.push_back(xtn);
          q2.push_back(xtn);
          q3.push_back(xtn);
          q4.push_back(xtn);
          q5.push_back(xtn);

          fork
               begin
                  sem3.get(1);
                    // $display("***************poping q1 to write address***************************"); 
                     write_address(q1.pop_front());
                  sem.put(1);
                  sem3.put(1);
               end
               begin
                  sem.get(1);
                  sem2.get(1);
                     //$display("***************poping q2 to write data***************************"); 
                     write_data(q2.pop_front());
                  sem1.put(1);
                  sem2.put(1);
               end
               begin
                  sem1.get(1);
                  sem4.get(1);
                     //$display("***************poping q3 to write resp***************************"); 
                     write_response(q3.pop_front());
                  sem4.put(1);
               end
               begin
                  sem5.get(1);
                     //$display("***************poping q4 to read address***************************"); 
                     read_address(q4.pop_front());
                  sem7.put(1);
                  sem5.put(1);
               end
               begin
                  sem7.get(1);
                  sem6.get(1);
                    // $display("***************poping q5 to read data***************************"); 
                     read_data(q5.pop_front());
                  sem6.put(1);
               end

          join
       endtask

//------------------------------ drive write address channel----------------------------
task m_drv::write_address(m_xtn xtn);
   @(vif.mast_drv_cb);
   vif.mast_drv_cb.AWVALID <= 1'b1;
   vif.mast_drv_cb.AWID    <= xtn.awid;
   vif.mast_drv_cb.AWADDR  <= xtn.awaddr;
   vif.mast_drv_cb.AWLEN   <= xtn.awlen;
   vif.mast_drv_cb.AWSIZE  <= xtn.awsize;
   vif.mast_drv_cb.AWBURST <= xtn.awburst;
   vif.mast_drv_cb.AWLOCK  <= xtn.awlock;
   vif.mast_drv_cb.AWCACHE <= xtn.awcache;
   vif.mast_drv_cb.AWPROT  <= xtn.awprot;
   vif.mast_drv_cb.AWQOS   <= xtn.awqos;
   vif.mast_drv_cb.AWUSER  <= xtn.awuser;

   // Wait until a clock edge where AWREADY is sampled high (1'b1) while AWVALID is high
   do begin
      @(vif.mast_drv_cb);
   end while (vif.mast_drv_cb.AWREADY !== 1'b1);

   vif.mast_drv_cb.AWVALID <= 1'b0;
   `uvm_info("write address channel", $sformatf("write address drive %s", xtn.sprint()), UVM_MEDIUM)

   repeat(5) @(vif.mast_drv_cb);
endtask

//---------------------------drive write data channel-----------------------------------
task m_drv::write_data(m_xtn xtn);
   for (int i = 0; i < xtn.awlen + 1; i++) begin
      @(vif.mast_drv_cb);
      vif.mast_drv_cb.WVALID <= 1'b1;
      vif.mast_drv_cb.WUSER  <= xtn.wuser;
      vif.mast_drv_cb.WDATA  <= xtn.wdata[i];
      vif.mast_drv_cb.WSTRB  <= xtn.wstrb[i];
      vif.mast_drv_cb.WLAST  <= (i == xtn.awlen) ? 1'b1 : 1'b0;

      do begin
         @(vif.mast_drv_cb);
      end while (vif.mast_drv_cb.WREADY !== 1'b1);

      vif.mast_drv_cb.WVALID <= 1'b0;
      vif.mast_drv_cb.WLAST  <= 1'b0;
      `uvm_info("write data channel", $sformatf("write data drive %s", xtn.sprint()), UVM_MEDIUM)

      repeat(5) @(vif.mast_drv_cb);
   end
endtask

//--------------------------drive write response channel---------------------------------
task m_drv::write_response(m_xtn xtn);
   @(vif.mast_drv_cb);
   vif.mast_drv_cb.BREADY <= 1'b1;

   do begin
      @(vif.mast_drv_cb);
   end while (vif.mast_drv_cb.BVALID !== 1'b1);

   vif.mast_drv_cb.BREADY <= 1'b0;
   `uvm_info("write response channel", $sformatf("write response drive %s", xtn.sprint()), UVM_MEDIUM)
   repeat(5) @(vif.mast_drv_cb);
endtask

//-------------------------drive read address channel-----------------------------------
task m_drv::read_address(m_xtn xtn);
   @(vif.mast_drv_cb);
   vif.mast_drv_cb.ARVALID <= 1'b1;
   vif.mast_drv_cb.ARID    <= xtn.arid;
   vif.mast_drv_cb.ARADDR  <= xtn.araddr;
   vif.mast_drv_cb.ARLEN   <= xtn.arlen;
   vif.mast_drv_cb.ARSIZE  <= xtn.arsize;
   vif.mast_drv_cb.ARBURST <= xtn.arburst;
   vif.mast_drv_cb.ARLOCK  <= xtn.arlock;
   vif.mast_drv_cb.ARCACHE <= xtn.arcache;
   vif.mast_drv_cb.ARPROT  <= xtn.arprot;
   vif.mast_drv_cb.ARQOS   <= xtn.arqos;
   vif.mast_drv_cb.ARUSER  <= xtn.aruser;

   do begin
      @(vif.mast_drv_cb);
   end while (vif.mast_drv_cb.ARREADY !== 1'b1);

   vif.mast_drv_cb.ARVALID <= 1'b0;
   `uvm_info("read address channel", $sformatf("read address drive %s", xtn.sprint()), UVM_MEDIUM)
   repeat(5) @(vif.mast_drv_cb);
endtask

//------------------------------drive read data channel------------------------------------
task m_drv::read_data(m_xtn xtn);
   xtn.read_addr_cal();
   xtn.rdata = new[xtn.arlen + 1];
   for (int i = 0; i < xtn.arlen + 1; i++) begin
      @(vif.mast_drv_cb);
      vif.mast_drv_cb.RREADY <= 1'b1;

      do begin
         @(vif.mast_drv_cb);
      end while (vif.mast_drv_cb.RVALID !== 1'b1);

      vif.mast_drv_cb.RREADY <= 1'b0;
      `uvm_info("read data channel", $sformatf("read data drive %s", xtn.sprint()), UVM_MEDIUM)
      repeat(5) @(vif.mast_drv_cb);
   end
endtask
