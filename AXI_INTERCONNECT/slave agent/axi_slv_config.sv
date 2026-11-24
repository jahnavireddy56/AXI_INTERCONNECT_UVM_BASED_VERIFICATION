//configuration class  for  axi slave
  class s_cfg extends uvm_object;
       //factory registration 
       `uvm_object_utils(s_cfg)
        //is_active parameter
        uvm_active_passive_enum is_active;
       //virtual interface 
       virtual axi_slave_interface vif;
       //extern funtion 
        extern function new (string name="s_cfg");
  endclass
  
  //constructor new
         function s_cfg::new (string name="s_cfg");
            super.new(name);
         endfunction



