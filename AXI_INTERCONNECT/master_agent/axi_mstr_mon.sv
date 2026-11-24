//  monitor class for axi master
   class  m_mon extends uvm_monitor;
      //factory register 
      `uvm_component_utils( m_mon)
      //analysis port 
      uvm_analysis_port #(m_xtn) master_ap;
      //config handle
      m_cfg cfg;
      //virtual interface
      virtual axi_master_interface.MAST_MON_MP vif;

      //extern functions 
      extern function new (string name=" m_mon",uvm_component parent);
      extern function void build_phase(uvm_phase phase);
      extern function void connect_phase(uvm_phase phase);
      extern task run_phase (uvm_phase phase);
      extern task handle_write_transaction(m_xtn xtn);
      extern task handle_read_transaction(m_xtn xtn);

   endclass
    
  //------------------------constructor new-----------------------
      function  m_mon::new (string name=" m_mon",uvm_component parent);
        super.new(name,parent);
        master_ap=new("master_ap",this);
      endfunction  

 //--------------------------build phase -------------------------
      function void m_mon::build_phase(uvm_phase phase);
        super.build_phase(phase);
             if(!uvm_config_db#(m_cfg)::get(this,"*","m_cfg",cfg))
              `uvm_fatal("MON","get failed in master monitor ")
      endfunction

  //-------------------------connect phase ---------------
      function void m_mon::connect_phase(uvm_phase phase);
       super.connect_phase(phase);
        vif=cfg.vif;
      endfunction
  //-------------------------run phase ------------------
      task m_mon:: run_phase(uvm_phase phase);
		fork
			forever
				begin
					m_xtn write_xtn;
					@(vif.mast_mon_cb);
					wait((vif.mast_mon_cb.AWVALID) && (vif.mast_mon_cb.AWREADY));	
					write_xtn=m_xtn::type_id::create("write_xtn");
					write_xtn.awid   = vif.mast_mon_cb.AWID;	 
					write_xtn.awaddr = vif.mast_mon_cb.AWADDR;
					write_xtn.awlen  = vif.mast_mon_cb.AWLEN;
					write_xtn.awsize = vif.mast_mon_cb.AWSIZE;
					write_xtn.awburst = vif.mast_mon_cb.AWBURST;
					write_xtn.awuser = vif.mast_mon_cb.AWUSER;
					write_xtn.awlock = vif.mast_mon_cb.AWLOCK;
					write_xtn.awprot = vif.mast_mon_cb.AWPROT;
					write_xtn.awqos = vif.mast_mon_cb.AWQOS;
					write_xtn.awcache = vif.mast_mon_cb.AWCACHE;
					write_xtn.awvalid = vif.mast_mon_cb.AWVALID;
					write_xtn.awready = vif.mast_mon_cb.AWREADY;

					write_xtn.wdata = new[write_xtn.awlen+1];
					write_xtn.wstrb  = new[write_xtn.awlen+1];
				        //collect write data
					foreach(write_xtn.wdata[i])
					begin
						wait((vif.mast_mon_cb.WVALID) && (vif.mast_mon_cb.WREADY));
						
						write_xtn.wdata[i] = vif.mast_mon_cb.WDATA;
						write_xtn.wstrb[i] = vif.mast_mon_cb.WSTRB;
						if(i==(write_xtn.wdata.size-1))
						begin
							write_xtn.wlast = vif.mast_mon_cb.WLAST;
						end
						write_xtn.wuser = vif.mast_mon_cb.WUSER;		
						write_xtn.wvalid = vif.mast_mon_cb.WVALID;	
						write_xtn.wready = vif.mast_mon_cb.WREADY;

							
					end

					fork
						handle_write_transaction(write_xtn);
					join_none
				end

			forever
				begin
					m_xtn read_xtn;
					@(vif.mast_mon_cb);

					wait((vif.mast_mon_cb.ARVALID) && (vif.mast_mon_cb.ARREADY));
					read_xtn=m_xtn::type_id::create("read_xtn");
					read_xtn.arid= vif.mast_mon_cb.ARID;
					read_xtn.araddr = vif.mast_mon_cb.ARADDR;
					read_xtn.arlen= vif.mast_mon_cb.ARLEN;
					read_xtn.arsize = vif.mast_mon_cb.ARSIZE;
					read_xtn.arburst = vif.mast_mon_cb.ARBURST;
					read_xtn.arlock= vif.mast_mon_cb.ARLOCK;
					read_xtn.arcache = vif.mast_mon_cb.ARCACHE;
					read_xtn.aruser= vif.mast_mon_cb.ARUSER;
					read_xtn.arqos= vif.mast_mon_cb.ARQOS;
					read_xtn.arprot = vif.mast_mon_cb.ARPROT;
					read_xtn.arvalid = vif.mast_mon_cb.ARVALID;
					read_xtn.arready = vif.mast_mon_cb.ARREADY;
					
					fork

						handle_read_transaction(read_xtn);
					join_none
				end
		join
	endtask	

	task m_mon :: handle_write_transaction(m_xtn xtn);
		
		@(vif.mast_mon_cb);
		wait((vif.mast_mon_cb.BVALID) && (vif.mast_mon_cb.BREADY));

		xtn.bid = vif.mast_mon_cb.BID;		
		xtn.bresp = vif.mast_mon_cb.BRESP;		
		xtn.buser = vif.mast_mon_cb.BUSER;		
		xtn.bvalid = vif.mast_mon_cb.BVALID;		
		xtn.bready = vif.mast_mon_cb.BREADY;
               `uvm_info("master monitor write channels",$sformatf("write channel sampling %s",xtn.sprint()),UVM_MEDIUM);
		
		master_ap.write(xtn);
		

	endtask

	task m_mon ::handle_read_transaction(m_xtn xtn);
		
		xtn.rdata = new[xtn.arlen+1];
		xtn.rresp = new[xtn.arlen+1];
		
		foreach(xtn.rdata[i])
		begin
			@(vif.mast_mon_cb);
			wait((vif.mast_mon_cb.RVALID) && (vif.mast_mon_cb.RREADY));
			xtn.rid = vif.mast_mon_cb.RID;
			xtn.rdata[i] = vif.mast_mon_cb.RDATA;
			xtn.rresp[i] = vif.mast_mon_cb.RRESP;
			if(i==(xtn.rdata.size-1))
			begin
				xtn.rlast = vif.mast_mon_cb.RLAST;
			end
			xtn.rvalid = vif.mast_mon_cb.RVALID;
			xtn.rready = vif.mast_mon_cb.RREADY;
		end
               `uvm_info("master monitor read channels",$sformatf("read channel sampling %s",xtn.sprint()),UVM_MEDIUM);
		master_ap.write(xtn);
		
	endtask

