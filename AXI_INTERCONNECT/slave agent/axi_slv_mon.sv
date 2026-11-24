//  sequncer class for axi slave
   class  s_mon extends uvm_monitor;
      //factory register 
      `uvm_component_utils( s_mon)
      //config handle
      s_cfg s_cfg_h;
      //Analysis port 
      uvm_analysis_port  #(m_xtn) slave_ap;
      //virtual interface handle 
      virtual axi_slave_interface.SLV_MON_MP vif;

      //extern functions 
        extern function new (string name=" s_mon",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task handle_write_transaction(m_xtn xtn);
	extern task handle_read_transaction(m_xtn xtn);
   endclass
    
  //--------------------------constructor new-----------------------
      function  s_mon::new (string name=" s_mon",uvm_component parent);
        super.new(name,parent);
        slave_ap=new("slave_ap",this);
      endfunction  
  //---------------------------build phase ---------------------------
       function void s_mon:: build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(s_cfg):: get(this,"","s_cfg",s_cfg_h))
			`uvm_fatal("s_mon","getting config failed")
	endfunction
  //---------------------------connect phase --------------------------
	function void s_mon:: connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		 vif=s_cfg_h.vif;
	endfunction
  //---------------------------run phase -------------------------------------
	task s_mon:: run_phase(uvm_phase phase);
		fork
			forever
				begin
					m_xtn write_xtn;
					@(vif.slv_mon_cb);
					wait((vif.slv_mon_cb.AWVALID) && (vif.slv_mon_cb.AWREADY));
					
					write_xtn=m_xtn::type_id::create("write_xtn");
					write_xtn.awid= vif.slv_mon_cb.AWID;	 
					write_xtn.awaddr = vif.slv_mon_cb.AWADDR;
					write_xtn.awlen= vif.slv_mon_cb.AWLEN;
					write_xtn.awsize = vif.slv_mon_cb.AWSIZE;
					write_xtn.awburst = vif.slv_mon_cb.AWBURST;
					write_xtn.awuser= vif.slv_mon_cb.AWUSER;
					write_xtn.awlock = vif.slv_mon_cb.AWLOCK;
					write_xtn.awprot = vif.slv_mon_cb.AWPROT;
					write_xtn.awqos= vif.slv_mon_cb.AWQOS;
					write_xtn.awcache = vif.slv_mon_cb.AWCACHE;
					write_xtn.awvalid = vif.slv_mon_cb.AWVALID;
					write_xtn.awready = vif.slv_mon_cb.AWREADY;

					write_xtn.wdata = new[write_xtn.awlen+1];
					write_xtn.wstrb = new[write_xtn.awlen+1];
                                        foreach(write_xtn.wdata[i])
					begin
						wait((vif.slv_mon_cb.WVALID) && (vif.slv_mon_cb.WREADY));
						
						write_xtn.wdata[i] = vif.slv_mon_cb.WDATA;
						write_xtn.wstrb[i] = vif.slv_mon_cb.WSTRB;
						if(i==(write_xtn.wdata.size-1))
						begin
							write_xtn.wlast = vif.slv_mon_cb.WLAST;
						end
						//write_xtn.wuser = vif.slv_mon_cb.WUSER;		
						write_xtn.wvalid = vif.slv_mon_cb.WVALID;	
						write_xtn.wready = vif.slv_mon_cb.WREADY;

												
					end

					fork
						handle_write_transaction(write_xtn);
					join_none
				end

			forever
				begin
					m_xtn read_xtn;
					@(vif.slv_mon_cb);

					wait((vif.slv_mon_cb.ARVALID) && (vif.slv_mon_cb.ARREADY));
					read_xtn=m_xtn::type_id::create("read_xtn");
					read_xtn.arid = vif.slv_mon_cb.ARID;
					read_xtn.araddr = vif.slv_mon_cb.ARADDR;
					read_xtn.arlen= vif.slv_mon_cb.ARLEN;
					read_xtn.arsize = vif.slv_mon_cb.ARSIZE;
					read_xtn.arburst = vif.slv_mon_cb.ARBURST;
					read_xtn.arlock= vif.slv_mon_cb.ARLOCK;
					read_xtn.arcache = vif.slv_mon_cb.ARCACHE;
					read_xtn.aruser= vif.slv_mon_cb.ARUSER;
					read_xtn.arqos= vif.slv_mon_cb.ARQOS;
					read_xtn.arprot = vif.slv_mon_cb.ARPROT;
					read_xtn.arvalid = vif.slv_mon_cb.ARVALID;
					read_xtn.arready = vif.slv_mon_cb.ARREADY;
					
					fork
						handle_read_transaction(read_xtn);
					join_none
				end
		join
	endtask	

	task s_mon:: handle_write_transaction(m_xtn xtn);
				
		@(vif.slv_mon_cb);
		wait((vif.slv_mon_cb.BVALID) && (vif.slv_mon_cb.BREADY));
			xtn.bid = vif.slv_mon_cb.BID;		
		xtn.bresp= vif.slv_mon_cb.BRESP;		
		xtn.buser = vif.slv_mon_cb.BUSER;		
		xtn.bvalid = vif.slv_mon_cb.BVALID;		
		xtn.bready = vif.slv_mon_cb.BREADY;
		
		slave_ap.write(xtn);
               `uvm_info("SLAVE monitor write channels",$sformatf("write channel sampling %s",xtn.sprint()),UVM_MEDIUM);
				

	endtask

	task s_mon::handle_read_transaction(m_xtn xtn);
			
		xtn.rdata = new[xtn.arlen+1];
		xtn.rresp = new[xtn.arlen+1];
		
		foreach(xtn.rdata[i])
		begin
			@(vif.slv_mon_cb);
			wait((vif.slv_mon_cb.RVALID) && (vif.slv_mon_cb.RREADY));
			xtn.rid = vif.slv_mon_cb.RID;
			xtn.rdata[i] = vif.slv_mon_cb.RDATA;
			xtn.rresp[i] = vif.slv_mon_cb.RRESP;
			if(i==(xtn.rdata.size-1))
			begin
				xtn.rlast = vif.slv_mon_cb.RLAST;
			end
			xtn.rvalid = vif.slv_mon_cb.RVALID;
			xtn.rready = vif.slv_mon_cb.RREADY;
		end

		slave_ap.write(xtn);
               `uvm_info("SLAVE monitor write channels",$sformatf("write channel sampling %s",xtn.sprint()),UVM_MEDIUM);

	endtask



