//environment class for axi master
   class env extends uvm_env;
      //factory register 
      `uvm_component_utils(env)
      //config handles 
       env_cfg e_cfg;
      //scoreboard
      sb sb_h;
      //master and slave handles
       m_agt_top m_agt_top_h;
       s_agt_top s_agt_top_h;
       rst_agt_top   r_agt_top_h;
      //extern functions 
      extern function new (string name="env",uvm_component parent);
      extern function void build_phase (uvm_phase phase);
      extern function void connect_phase(uvm_phase phase);
   endclass
    
  //constructor new
      function env::new (string name="env",uvm_component parent);
        super.new(name,parent);
      endfunction 
 
  //--------------  build phase ---------------------
      function void env::build_phase (uvm_phase phase);
          //get env_cgf 
          if(!uvm_config_db#(env_cfg)::get(this,"","env_cfg",e_cfg))
            `uvm_fatal("ENV","get failed in a env")

          super.build_phase(phase);
          if(e_cfg.has_master)
             m_agt_top_h=m_agt_top::type_id::create("m_agt_top_h",this);

          if(e_cfg.has_slave)
             s_agt_top_h=s_agt_top::type_id::create("s_agt_top_h",this);

          if(e_cfg.has_rst_agt)
             r_agt_top_h=rst_agt_top::type_id::create("r_agt_top_h",this);

          if(e_cfg.has_sb)
             sb_h=sb::type_id::create("sb_h",this);
      endfunction

  //----------------------connect phase --------------------------
       function void env::connect_phase (uvm_phase phase);
          super.connect_phase(phase);
            for(int i=0;i<(e_cfg.no_of_master);i++)
		begin
			m_agt_top_h.m_agt_h[i].m_mon_h.master_ap.connect(sb_h.fifo_mstr[i].analysis_export);
		end
            for(int i=0;i<(e_cfg.no_of_slave);i++)
		begin
			s_agt_top_h.s_agt_h[i].s_mon_h.slave_ap.connect(sb_h.fifo_slv[i].analysis_export);
		end

            for(int i=0;i<(e_cfg.no_of_rst_agt);i++)
		begin
			r_agt_top_h.r_agt_h[i].r_mon_h.reset_ap.connect(sb_h.fifo_rst[i].analysis_export);
		end
          endfunction
