//  agent  class for axi master
   class  rst_agt extends uvm_agent;
      //factory register 
      `uvm_component_utils( rst_agt)
      //handles for drv,mon,seqr
      rst_seqr r_seqr_h;
      rst_drv  r_drv_h;
      rst_mon  r_mon_h;
      //handle of config
      rst_cfg r_cfg_h;
      //extern functions 
      extern function new (string name=" rst_agt",uvm_component parent);
      extern function void build_phase(uvm_phase phase);
   endclass
    
  //constructor new
      function  rst_agt::new (string name=" rst_agt",uvm_component parent);
        super.new(name,parent);
      endfunction 

 //---------------   build phase   ----------------------
      function void rst_agt::build_phase(uvm_phase phase);
        //get configuration 
           if(!uvm_config_db#(rst_cfg)::get(this,"","rst_cfg",r_cfg_h))
             `uvm_fatal("RESET_AGENT","get failed in reset agent")
         super.build_phase(phase);
         r_mon_h=rst_mon::type_id::create("r_mon_h",this);
         if(r_cfg_h.is_active==UVM_ACTIVE)
           begin
              r_drv_h=rst_drv::type_id::create("r_drv_h",this);
              r_seqr_h=rst_seqr::type_id::create("r_seqr_h",this);
           end
       endfunction
        


