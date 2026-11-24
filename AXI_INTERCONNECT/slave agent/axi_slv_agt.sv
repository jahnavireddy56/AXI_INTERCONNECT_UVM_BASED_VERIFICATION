//  agent  class for axi slave
   class  s_agt extends uvm_agent;
      //factory register 
      `uvm_component_utils( s_agt)
      //handles for drv,mon,seqr
      s_seqr s_seqr_h;
      s_drv  s_drv_h;
      s_mon  s_mon_h;
      //handle of config
      s_cfg s_cfg_h;
      //extern functions 
      extern function new (string name=" s_agt",uvm_component parent);
      extern function void build_phase(uvm_phase phase);
   endclass
    
  //constructor new
      function  s_agt::new (string name=" s_agt",uvm_component parent);
        super.new(name,parent);
      endfunction 

 //---------------   build phase   ----------------------
      function void s_agt::build_phase(uvm_phase phase);
        //get configuration 
           if(!uvm_config_db#(s_cfg)::get(this,"","s_cfg",s_cfg_h))
             `uvm_fatal("MASTER_AGENT","get failed in master agent")
         super.build_phase(phase);
         s_mon_h=s_mon::type_id::create("s_mon_h",this);
         if(s_cfg_h.is_active==UVM_ACTIVE)
           begin
              s_drv_h=s_drv::type_id::create("s_drv_h",this);
              s_seqr_h=s_seqr::type_id::create("s_seqr_h",this);
           end
       endfunction
        


