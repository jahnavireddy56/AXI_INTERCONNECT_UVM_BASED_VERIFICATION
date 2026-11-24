//configuration  for  axi master
  class m_cfg extends uvm_object;
       //factory registration 
       `uvm_object_utils(m_cfg)
        //is_active parameter
        uvm_active_passive_enum is_active;
        //virtual interface 
        virtual axi_master_interface vif;
       //extern funtion 
        extern function new (string name="m_cfg");
  endclass
  
  //constructor new
         function m_cfg::new (string name="m_cfg");
            super.new(name);
         endfunction


