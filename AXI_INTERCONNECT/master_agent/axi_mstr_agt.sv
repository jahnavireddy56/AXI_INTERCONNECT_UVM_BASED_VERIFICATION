//  agent  class for axi master
   class  m_agt extends uvm_agent;
      //factory register 
      `uvm_component_utils( m_agt)
      //handles for drv,mon,seqr
      m_seqr m_seqr_h;
      m_drv  m_drv_h;
      m_mon  m_mon_h;
      //handle of config
      m_cfg m_cfg_h;
      //extern functions 
      extern function new (string name=" m_agt",uvm_component parent);
      extern function void build_phase(uvm_phase phase);
      extern function void connect_phase (uvm_phase phase);
   endclass
    
  //------------------------constructor new-------------------------
      function  m_agt::new (string name=" m_agt",uvm_component parent);
        super.new(name,parent);
      endfunction 

 //--------------------------  build phase   ----------------------
      function void m_agt::build_phase(uvm_phase phase);
        //get configuration 
           if(!uvm_config_db#(m_cfg)::get(this,"","m_cfg",m_cfg_h))
             `uvm_fatal("MASTER_AGENT","get failed in master agent")
         super.build_phase(phase);
         m_mon_h=m_mon::type_id::create("m_mon_h",this);
         if(m_cfg_h.is_active==UVM_ACTIVE)
           begin
              m_drv_h=m_drv::type_id::create("m_drv_h",this);
              m_seqr_h=m_seqr::type_id::create("m_seqr_h",this);
           end
       endfunction
        
  //-------------------------connect phase ----------------------
       function void m_agt::connect_phase(uvm_phase phase);
         super.connect_phase(phase);
         if(m_cfg_h.is_active==UVM_ACTIVE)
            begin
              m_drv_h.seq_item_port.connect(m_seqr_h.seq_item_export);
            end
       endfunction         
