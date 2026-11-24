//  agent top  class for axi master
   class  m_agt_top extends uvm_env;
      //factory register 
      `uvm_component_utils(m_agt_top)
      //agent handle 
      m_agt m_agt_h[];
      //config handles
      env_cfg e_cfg;
      m_cfg  m_cfg_h[];
      //extern functions 
      extern function new (string name="m_agt_top",uvm_component parent);
      extern function void build_phase(uvm_phase phase);

   endclass
    
  //constructor new
      function m_agt_top::new (string name="m_agt_top",uvm_component parent);
        super.new(name,parent);
      endfunction  

 //------------  build phase ------------
      function void m_agt_top::build_phase(uvm_phase phase);
         //get e_cfg
          if(!uvm_config_db#(env_cfg)::get(this,"","env_cfg",e_cfg))
            `uvm_fatal("MASTER_AGENT_TOP","ENV condig get failed in a agenth top")
         //configure dynamic config,agent
          m_cfg_h=new[e_cfg.no_of_master];
          m_agt_h=new[e_cfg.no_of_master];


          super.build_phase(phase);
         //creating instance for the agent 

         foreach(m_agt_h[i])
              begin
                  m_agt_h[i]=m_agt::type_id::create($sformatf("m_agt_h[%0d]",i),this);
              end
         //set config to agent

          foreach(m_cfg_h[i])
               begin
                uvm_config_db#(m_cfg)::set(this, $sformatf("m_agt_h[%0d]*", i), "m_cfg", e_cfg.m_cfg_h[i]);
               end

       endfunction
