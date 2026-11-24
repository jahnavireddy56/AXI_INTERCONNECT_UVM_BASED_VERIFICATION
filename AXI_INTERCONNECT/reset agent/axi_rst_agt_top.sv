//  agent top  class for axi master
   class  rst_agt_top extends uvm_env;
      //factory register 
      `uvm_component_utils(rst_agt_top)
      //agent handle 
      rst_agt r_agt_h[];
      //config handles
      env_cfg e_cfg;
      rst_cfg  r_cfg_h[];
      //extern functions 
      extern function new (string name="rst_agt_top",uvm_component parent);
      extern function void build_phase(uvm_phase phase);

   endclass
    
  //constructor new
      function rst_agt_top::new (string name="rst_agt_top",uvm_component parent);
        super.new(name,parent);
      endfunction  

 //------------  build phase ------------
      function void rst_agt_top::build_phase(uvm_phase phase);
         //get e_cfg
          if(!uvm_config_db#(env_cfg)::get(this,"","env_cfg",e_cfg))
            `uvm_fatal("MASTER_AGENT_TOP","ENV condig get failed in a agenth top")
         //configure dynamic config,agent
          r_cfg_h=new[e_cfg.no_of_rst_agt];
          r_agt_h=new[e_cfg.no_of_rst_agt];


          super.build_phase(phase);
         //creating instance for the agent 

         foreach(r_agt_h[i])
              begin
                  r_agt_h[i]=rst_agt::type_id::create($sformatf("r_agt_h[%0d]",i),this);
              end
         //set config to agent

          foreach(r_cfg_h[i])
               begin
                   uvm_config_db#(rst_cfg)::set(this,"*","rst_cfg",e_cfg.r_cfg_h[i]);
               end

       endfunction

